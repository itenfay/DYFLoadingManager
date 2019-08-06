//
//  DYFLoadingView.m
//
//  Created by dyf on 16/07/26.
//  Copyright © 2016 dyf.
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

#import "DYFLoadingView.h"

#define DEGREES_TO_RADIANS(angle)    ((angle) / 180 * M_PI)
#define RADIANS_TO_DEGREES(radians)  ((radians) * (180 / M_PI))
#define STROKE_PROCESS_RADIAN(angle) (angle) / RADIANS_TO_DEGREES(M_PI)
#define STROKE_END_RADIAN			  180 / RADIANS_TO_DEGREES(M_PI)

#define RING_SPEED                    6       // The speed of a ring.
#define RING_LINE_WIDTH               3       // The line width of a ring.
#define STROKE_STEP                   160     // The Stroke step.
#define DRAW_LINE_RATE                9       // Drawing line rate.
#define DRAW_CYCLE                    4       // Drawing cycle.
#define DRAW_LINE_ROTATION            M_PI_4

#define RING_COLOR [UIColor colorWithRed:0.9 green:0 blue:0 alpha:1.0]

@interface DYFSpinnerRing : CAShapeLayer

+ (instancetype)layerWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame;

@end

@implementation DYFSpinnerRing

+ (instancetype)layerWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)init {
    if (self = [super init]) {
        self.lineWidth   = RING_LINE_WIDTH;
        self.strokeColor = RING_COLOR.CGColor;
        self.fillColor   = [UIColor clearColor].CGColor;
        self.lineCap     = kCALineCapRound;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([self init]) {
        self.frame = frame;
    }
    return self;
}

@end

@interface DYFLoadingView ()

@property (nonatomic, strong) CALayer          *container;
@property (nonatomic, strong) DYFSpinnerRing   *layerLeft;
@property (nonatomic, strong) DYFSpinnerRing   *layerRight;

@property (nonatomic, strong) CABasicAnimation *strokeEndAnimation;
@property (nonatomic, strong) CABasicAnimation *rotateAnimation;

@property (nonatomic, strong) UIImage          *image;
@property (nonatomic, strong) UIImageView      *imageView;

@property (nonatomic, assign) CGFloat          radius;

@end

@implementation DYFLoadingView

+ (instancetype)loadingViewWithFrame:(CGRect)frame {
    return [self loadingViewWithFrame:frame image:nil];
}

+ (instancetype)loadingViewWithFrame:(CGRect)frame image:(UIImage *)image {
    return [[self alloc] initWithFrame:frame image:image];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    if ([self initWithFrame:frame]) {
        [self setImage:image];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addAppActivityObserver];
    }
    return self;
}

- (void)startAnimation {
    _isLoading = YES;
    
    [self checkSpeed];
    [self checkLineWidth];
    [self configureImageView];
    
    [self layoutIfNeeded];
    
    [self changeAnchor:NO];
    [self clearAllAnimation];
    [self checkLineColor];
    
    [self.layerLeft  addAnimation:self.strokeEndAnimation forKey:self.strokeEndAnimation.keyPath];
    [self.layerRight addAnimation:self.strokeEndAnimation forKey:self.strokeEndAnimation.keyPath];
    [self.container  addAnimation:   self.rotateAnimation forKey:   self.rotateAnimation.keyPath];
}

- (void)stopAnimation {
    _isLoading = NO;
    [self clearAllAnimation];
}

- (void)drawLineWithPercent:(CGFloat)percent {
    [self checkLineWidth];
    [self checkLineColor];
    
    if (percent >= STROKE_PROCESS_RADIAN(160)) {
        percent  = STROKE_PROCESS_RADIAN(160);
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.layerLeft  setStrokeEnd:percent];
        [self.layerRight setStrokeEnd:percent];
        self.container.transform = CATransform3DMakeRotation(DRAW_LINE_ROTATION*percent, 0, 0, 1);
    }];
}

- (void)clearAllAnimation {
    [self.layer removeAllAnimations];
    [self resetAnimation];
}

- (void)resetAnimation {
    [self.layerLeft  removeAllAnimations];
    [self.layerRight removeAllAnimations];
    
    self.container.transform = CATransform3DIdentity;
    [self.container  removeAllAnimations];
    
    [self.layerLeft  setStrokeEnd:0.01];
    [self.layerRight setStrokeEnd:0.01];
}

- (void)checkSpeed {
    if (self.speed <= 0) {
        self.speed = RING_SPEED;
    }
}

- (void)checkLineWidth {
    if (self.lineWidth <= 0) {
        self.lineWidth = RING_LINE_WIDTH;
    }
    if (self.lineWidth != self.layerLeft.lineWidth) {
        [self changeLineWidth:self.lineWidth];
    }
}

- (void)checkLineColor {
    if (self.lineColor && self.lineColor.CGColor != self.layerLeft.strokeColor) {
        [self changeLineColor:self.lineColor];
    }
}

- (void)changeAnchor:(BOOL)isEnd {
    CGSize  size   = self.bounds.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    CGFloat radius = self.radius;
    
    NSDictionary *angleResult = [self calculateAngle:30];
    if (isEnd) {
        angleResult = [self calculateAngle:-115];
    }
    
    CGFloat leftStartAngle  = [[[angleResult objectForKey:@"left"]  objectForKey:@"start"] doubleValue];
    CGFloat leftEndAngle    = [[[angleResult objectForKey:@"left"]  objectForKey:@"end"]   doubleValue];
    CGFloat rightStartAngle = [[[angleResult objectForKey:@"right"] objectForKey:@"start"] doubleValue];
    CGFloat rightEndAngle   = [[[angleResult objectForKey:@"right"] objectForKey:@"end"]   doubleValue];
    UIBezierPath *lineLeft  = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(leftStartAngle) endAngle:DEGREES_TO_RADIANS(leftEndAngle) clockwise:YES];
    
    UIBezierPath *lineRight = [UIBezierPath bezierPathWithArcCenter:center radius:radius  startAngle:DEGREES_TO_RADIANS(rightStartAngle) endAngle:DEGREES_TO_RADIANS(rightEndAngle) clockwise:YES];
    
    self.layerLeft.path     = lineLeft.CGPath;
    self.layerRight.path    = lineRight.CGPath;
}

- (NSDictionary *)calculateAngle:(CGFloat)leftStartPosition {
    CGFloat leftStartAngle  = leftStartPosition;
    CGFloat leftEndAngle    = leftStartPosition > 0 ? (leftStartPosition + STROKE_STEP) - 360 : STROKE_STEP + leftStartPosition;
    
    CGFloat rightStartAngle = leftEndAngle + 10;
    CGFloat rightEndAngle   = leftStartAngle - 10;
    
    return @{ @"left" : @{ @"start": @(leftStartAngle ), @"end": @(leftEndAngle) },
              @"right": @{ @"start": @(rightStartAngle), @"end": @(rightEndAngle) }
            };
}

- (void)configureImageView {
    if (self.image) {
        self.imageView.image = self.image;
        [self addSubview:self.imageView];
    }
}

- (void)adjustImageViewFrame {
    CGSize size = self.bounds.size;
    self.radius = size.width/2.f;
    
    if (self.image) {
        CGSize imgSize = self.image.size;
        CGFloat maxW   = MAX(imgSize.width, imgSize.height);
        
        if (maxW > size.width - 20) {
            maxW = size.width - 20.f;
        }
        
        self.imageView.center = CGPointMake(size.width/2, size.height/2);
        self.imageView.bounds = CGRectMake(0, 0, maxW, maxW);
    }
}

- (void)updateLayouts {
    [self adjustImageViewFrame];
    [self adjustLayerFrame];
}

- (void)layoutSubviews {
    [self updateLayouts];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = UIColor.clearColor;
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (void)changeLineColor:(UIColor *)color {
    self.layerLeft.strokeColor  = color.CGColor;
    self.layerRight.strokeColor = color.CGColor;
}

- (void)changeLineWidth:(CGFloat)width {
    self.layerLeft.lineWidth  = width;
    self.layerRight.lineWidth = width;
}

- (void)adjustLayerFrame {
    self.container.frame  = self.bounds;
    self.layerLeft.frame  = self.bounds;
    self.layerRight.frame = self.bounds;
}

- (CALayer *)container {
    if (!_container) {
        _container = [CALayer layer];
        [self.layer addSublayer:_container];
    }
    return _container;
}

- (DYFSpinnerRing *)layerLeft {
    if (!_layerLeft) {
        _layerLeft = [DYFSpinnerRing layerWithFrame:self.bounds];
        [self.container addSublayer:_layerLeft];
    }
    return _layerLeft;
}

- (DYFSpinnerRing *)layerRight {
    if (!_layerRight) {
        _layerRight = [DYFSpinnerRing layerWithFrame:self.bounds];
        [self.container addSublayer:_layerRight];
    }
    return _layerRight;
}

- (CABasicAnimation *)strokeEndAnimation {
    if (!_strokeEndAnimation) {
        _strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeEndAnimation.fromValue           = @(1 - STROKE_END_RADIAN);
        _strokeEndAnimation.toValue             = @(STROKE_PROCESS_RADIAN(160));
        _strokeEndAnimation.duration            = DRAW_LINE_RATE / self.speed;
        _strokeEndAnimation.repeatCount         = HUGE_VAL;
        _strokeEndAnimation.removedOnCompletion = NO;
        _strokeEndAnimation.autoreverses        = YES;
    }
    return _strokeEndAnimation;
}

- (CABasicAnimation *)rotateAnimation {
    if (!_rotateAnimation) {
        _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.duration            = self.strokeEndAnimation.duration / DRAW_CYCLE;
        _rotateAnimation.fromValue           = @(DRAW_LINE_ROTATION + DEGREES_TO_RADIANS(30));
        _rotateAnimation.toValue             = @(DRAW_LINE_ROTATION + DEGREES_TO_RADIANS(30) + M_PI);
        _rotateAnimation.repeatCount         = HUGE_VAL;
        _rotateAnimation.autoreverses        = NO;
        _rotateAnimation.removedOnCompletion = NO;
        _rotateAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    return _rotateAnimation;
}

- (void)handleAppActivity:(NSNotification *)noti {
    if (noti.name == UIApplicationDidEnterBackgroundNotification) {
        
        // 记录暂停时间
        CFTimeInterval pauseTime  = [self.container convertTime:CACurrentMediaTime() fromLayer:nil];
        // 设置动画速度为0
        self.container.speed      = 0;
        // 设置动画的偏移时间
        self.container.timeOffset = pauseTime;
        
    } else if (noti.name == UIApplicationWillEnterForegroundNotification) {
        
        // 暂停的时间
        CFTimeInterval pauseTime      = self.container.timeOffset;
        // 设置动画速度为1
        self.container.speed          = 1;
        // 重置偏移时间
        self.container.timeOffset     = 0;
        // 重置开始时间
        self.container.beginTime      = 0;
        // 计算开始时间
        CFTimeInterval timeSincePause = [self.container convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
        // 设置开始时间
        self.container.beginTime      = timeSincePause;
    }
}

- (void)addAppActivityObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleAppActivity:)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleAppActivity:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)removeAppActivityObserver {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    [self removeAppActivityObserver];
}

@end
