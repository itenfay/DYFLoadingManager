//
//  DYFLoadingManager.m
//
//  Created by dyf on 16/07/29.
//  Copyright © 2016 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFLoadingManager.h"
#import "DYFLoadingView.h"

// The width and height of the screen.
#define S_W  [UIScreen mainScreen].bounds.size.width
#define S_H  [UIScreen mainScreen].bounds.size.height

// The width and height of the loading.
#define C_W  160.f
#define C_H  130.f

@interface DYFLoadingManager () <UIGestureRecognizerDelegate>

/**
 A dim mask as loading background.
 */
@property (nonatomic, strong) UIView *dimMask;

/**
 A text label that shows prompt for users.
 */
@property (nonatomic, strong) UILabel *textLabel;

/**
 A content view as loading super view.
 */
@property (nonatomic, strong) UIImageView *contentView;

/**
 A loading view that shows the loading animations.
 */
@property (nonatomic, strong) DYFLoadingView *loadingView;

@end

@implementation DYFLoadingManager

+ (instancetype)shared {
    static DYFLoadingManager *_instance;
    @synchronized(self) {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDimBackground:YES];
        [self addRotationObserver];
    }
    return self;
}

- (BOOL)hasLoading {
    return _loadingView ? YES : NO;
}

- (void)showLoading {
    [self showLoadingInView:nil];
}

- (void)showLoadingInView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupSubviewsInView:view];
    });
}

- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideSubviews];
    });
}

- (UIView *)dimMask {
    if (!_dimMask) {
        _dimMask = [[UIView alloc] init];
        _dimMask.userInteractionEnabled = YES;
        
        if (self.dimBackground) {
            _dimMask.alpha           = 0.3f;
            _dimMask.backgroundColor = [UIColor blackColor];
        } else {
            _dimMask.backgroundColor = [UIColor clearColor];
        }
        
        _dimMask.autoresizingMask    = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    return _dimMask;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = UIColor.clearColor;
        _textLabel.textAlignment   = NSTextAlignmentCenter;
        _textLabel.numberOfLines   = 1;
        _textLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
    }
    return _textLabel;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        _contentView.backgroundColor = UIColor.clearColor;
        _contentView.contentMode = UIViewContentModeScaleToFill;
    }
    return _contentView;
}

- (DYFLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [DYFLoadingView loadingViewWithFrame:CGRectZero image:self.centralImage];
    }
    return _loadingView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_dimMask]) {
        return NO;
    }
    return YES;
}

- (void)dimMaskTapped:(UITapGestureRecognizer *)gestureRecognizer {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

- (void)setupSubviewsInView:(UIView *)view {
    if (!_contentView) {
        UIView *inView     = view ? view : self.visibleView;
        CGSize v_size      = inView.frame.size;
        self.dimMask.frame = CGRectMake(0, 0, v_size.width, v_size.height);
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        tapGR.delegate = self;
        [tapGR addTarget:self action:@selector(dimMaskTapped:)];
        [self.dimMask addGestureRecognizer:tapGR];
        
        CGPoint origin         = [self contentViewOrigin:inView];
        CGRect  rect           = CGRectMake(origin.x, origin.y, C_W, C_H);
        self.contentView.frame = rect;
        
        UIColor *blackColor    = [UIColor colorWithWhite:0 alpha:0.75];
        UIColor *fillColor     = self.color ? self.color : blackColor;
        CGFloat radius         = self.cornerRadius > 0 ? self.cornerRadius : 10.f;
        self.clipCorner(fillColor, radius, self.contentView);
        
        [inView addSubview:self.dimMask];
        [inView addSubview:self.contentView];
        
        CGFloat topMargin          = 20.f;
        CGFloat loadW              = 60.f;
        CGFloat loadH              = loadW;
        CGRect  loadRect           = CGRectMake((C_W - loadW)/2.f, topMargin, loadW, loadH);
        self.loadingView.frame     = loadRect;
        self.loadingView.lineWidth = self.ringWidth > 0 ? self.ringWidth : 3.f;
        self.loadingView.lineColor = self.ringColor ? self. ringColor : UIColor.orangeColor;
        
        CGFloat tLabX              = 10.f;
        CGFloat tLabH              = 20.f;
        CGFloat tLabY              = C_H - tLabH - topMargin;
        CGFloat tLabW              = C_W - tLabX*2;
        CGRect  tLabRect           = CGRectMake(tLabX, tLabY, tLabW, tLabH);
        self.textLabel.frame       = tLabRect;
        self.textLabel.font        = self.font ? self.font : [UIFont systemFontOfSize:14.f];
        self.textLabel.text        = self.text;
        self.textLabel.textColor   = self.textColor ? self.textColor : UIColor.whiteColor;
        
        [self.contentView addSubview:self.loadingView];
        [self.contentView addSubview:self.textLabel];
        
        [self.loadingView startAnimation];
    }
}

- (void)hideSubviews {
    if (_contentView) {
        [UIView animateWithDuration:0.3 animations:^{
            [self makeViewsTransparent];
        } completion:^(BOOL finished) {
            if (finished) {
                [self clearAllViews];
            }
        }];
    }
}

- (void)makeViewsTransparent {
    _contentView.alpha = 0.f;
    _dimMask.alpha     = 0.f;
}

- (void)clearAllViews {
    [_loadingView stopAnimation];
    
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    [_textLabel removeFromSuperview];
    _textLabel   = nil;
    [_contentView removeFromSuperview];
    _contentView = nil;
    [_dimMask removeFromSuperview];
    _dimMask     = nil;
}

- (void)updateLayouts {
    if (_contentView) {
        UIView *view       = _contentView;
        UIView *superview  = view.superview;
        
        CGPoint origin     = [self contentViewOrigin:superview];
        CGRect  frame      = CGRectMake(origin.x, origin.y, view.bounds.size.width, view.bounds.size.height);
        _contentView.frame = frame;
        
        [superview bringSubviewToFront:_dimMask];
        [superview bringSubviewToFront:_contentView];
    }
}

- (CGPoint)contentViewOrigin:(UIView *)view {
    CGFloat cX = 0.f;
    CGFloat cY = 0.f;
    if (view) {
        cX = (view.frame.size.width  - C_W)/2.f;
        cY = (view.frame.size.height - C_H)/2.f;
    } else {
        if (self.isPortrait || self.iOS8OrNewer) {
            cX = (S_W - C_W)/2.f;
            cY = (S_H - C_H)/2.f;
        } else {
            cX = (S_H - C_W)/2.f;
            cY = (S_W - C_H)/2.f;
        }
    }
    return CGPointMake(cX, cY);
}

- (void (^)(UIColor *color, CGFloat radius, UIImageView *forView))clipCorner {
    void (^clipCornerBlock)(UIColor *color, CGFloat radius, UIImageView *forView) = ^(UIColor *color, CGFloat radius, UIImageView *forView) {
        UIImage *m_image   = nil;
        
        CGRect m_rect      = forView.bounds;
        CGSize m_size      = m_rect.size;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:m_rect cornerRadius:radius];
        
        if (@available(iOS 10.0, *)) {
            UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:m_size];
            
            m_image = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                UIGraphicsImageRendererContext *ctx = rendererContext;
                
                CGContextSetFillColorWithColor  (ctx.CGContext, color.CGColor);
                CGContextSetStrokeColorWithColor(ctx.CGContext, UIColor.clearColor.CGColor);
                CGContextSetLineWidth           (ctx.CGContext, 0);
                
                [path addClip];
                
                CGContextAddPath (ctx.CGContext, path.CGPath);
                CGContextDrawPath(ctx.CGContext, kCGPathFillStroke);
            }];
        } else {
            UIGraphicsBeginImageContext(m_size);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetFillColorWithColor  (context, color.CGColor);
            CGContextSetStrokeColorWithColor(context, UIColor.clearColor.CGColor);
            CGContextSetLineWidth           (context, 0);
            
            [path addClip];
            
            CGContextAddPath (context, path.CGPath);
            CGContextDrawPath(context, kCGPathFillStroke);
            
            m_image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        
        forView.image = m_image;
    };
    
    return clipCornerBlock;
}

- (BOOL)isPortrait {
    UIApplication *app = UIApplication.sharedApplication;
    return UIInterfaceOrientationIsPortrait(app.statusBarOrientation);
}

- (BOOL)iOS8OrNewer {
    NSComparisonResult result = [[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch];
    return (result != NSOrderedAscending);
}

- (UIViewController *)visibleViewController {
    UIApplication *app = UIApplication.sharedApplication;
    UIWindow *window = app.windows.firstObject;
    UIViewController *vc = window.rootViewController;
    while (vc) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tbc = (UITabBarController *)vc;
            vc = tbc.selectedViewController;
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (UINavigationController *)vc;
            vc = nc.visibleViewController;
        } else {
            if (!vc.presentedViewController) {
                break;
            }
            vc = vc.presentedViewController;
        }
    }
    return vc;
}

- (UIView *)visibleView {
    return self.visibleViewController.view;
}

- (void)handleRotationNotification {
    [self delayToUpdateLayouts];
}

- (void)delayToUpdateLayouts {
    if (_contentView) {
        [self updateLayouts];
        _contentView.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(0.2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^
        {
            _contentView.hidden = NO;
        });
    }
}

- (void)addRotationObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleRotationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)removeRotationObserver {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)dealloc {
    [self removeRotationObserver];
}

@end
