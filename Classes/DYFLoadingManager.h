//
//  DYFLoadingManager.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DYFLoadingManager : NSObject

/**
 Whether to set a dim background.
 */
@property (nonatomic, assign) BOOL dimBackground;

/**
 Sets a central image of a loading view.
 */
@property (nonatomic, strong) UIImage *centralImage;

/**
 Sets the width for a ring.
 */
@property (nonatomic, assign) CGFloat ringWidth;

/**
 Sets the color for a ring.
 */
@property (nonatomic, strong) UIColor *ringColor;

/**
 It is used to the background color for a loading view.
 */
@property (nonatomic, strong) UIColor *color;

/**
 It is used to set text for label.
 */
@property (nonatomic, copy  ) NSString *text;

/**
 It is used to set text color for label.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 It is used to set font for label.
 */
@property (nonatomic, strong) UIFont *font;

/**
 It is used to set corner for a loading view.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 Returns a `DYFLoadingManager` singleton.
 */
+ (instancetype)shared;

/**
 Is there loading on display, return true or false.
 */
- (BOOL)hasLoading;

/**
 Shows loading in the super view.
 */
- (void)showLoading;

/**
 Shows loading in the specified view.
 */
- (void)showLoadingInView:(UIView *)view;

/**
 Hides and removes loading from the super view.
 */
- (void)hideLoading;

@end
