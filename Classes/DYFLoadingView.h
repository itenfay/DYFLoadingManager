//
//  DYFLoadingView.h
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

#import <UIKit/UIKit.h>

@interface DYFLoadingView : UIView

/** Whether it is loading or not. */
@property (nonatomic, assign, readonly) BOOL isLoading;

/** The speed of the circling animation. */
@property (nonatomic, assign) CGFloat speed;

/** The line width of a circle. */
@property (nonatomic, assign) CGFloat lineWidth;

/** The line color of a circle. */
@property (nonatomic, strong, nullable) UIColor *lineColor;

/**
 Initializes and returns a newly allocated view object with the specified frame rectangle.
 */
+ (nullable instancetype)loadingViewWithFrame:(CGRect)frame;

/**
 Initializes and returns a newly allocated view object with the specified frame rectangle and an object that manages image data.
 */
+ (nullable instancetype)loadingViewWithFrame:(CGRect)frame image:(nullable UIImage *)image;

/**
 Starts animation.
 */
- (void)startAnimation;

/**
 Stops animation.
 */
- (void)stopAnimation;

@end
