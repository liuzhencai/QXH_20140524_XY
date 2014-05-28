//
//  UIViewAdditions.h
//  DWiPhone
//
//  Created by steven sun on 6/11/12.
//  Copyright 2012 Steven sun. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "NIAttributedLabel.h"

#define kActivityTag        9212111
@interface UIView (DWCategory) 

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

//@property(nonatomic,readonly) CGFloat screenX;
//@property(nonatomic,readonly) CGFloat screenY;
//@property(nonatomic,readonly) CGFloat screenViewX;
//@property(nonatomic,readonly) CGFloat screenViewY;
//@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;


/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)viewController;

- (void)setOriginY:(CGFloat)originY;
- (void)setOriginX:(CGFloat)originx;

-(void)removeAllSubViews;


// DRAW GRADIENT
+ (void) drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors;
+ (void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colors;


// DRAW ROUNDED RECTANGLE
+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;

// DRAW LINE
+ (void) drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors;
+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap;

// FILL RECT
+ (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius;
+ (void)drawRect:(CGRect)rect fillColor:(UIColor *)fillColor radius:(CGFloat)radius;

// STROKE RECT
+ (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor ;



- (UIActivityIndicatorView *) activityWithOrigin:(CGPoint)pt;
- (UIActivityIndicatorView *) activityAtCenter;
- (UIActivityIndicatorView *) activityAtCenterWithSize:(CGSize)size;

@end

@interface UIView(setFrameQuick)

- (void)setOriginX:(float)x;
- (void)setOriginY:(float)y;
- (void)setOriginXAdd:(float)addX;
- (void)setOriginYAdd:(float)addY;
- (void)setOriginYDec:(float)decY;
- (void)setSizeHeight:(float)heigth;
- (void)setSizeHeightAdd:(float)addHeigth;
- (void)setSizeHeightDec:(float)decHeigth;
- (void)setSizeWidth:(float)width;

//- (NIAttributedLabel *)addAtrtibutedLabelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color;
- (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color;
- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                         color:(UIColor *)color
                          font:(UIFont *)font;
- (UIImageView *)addImageViewWithFrame:(CGRect)frame imageName:(UIImage *)imageName;
- (UIButton *)addButtonWithFrame:(CGRect)frame withTitle:(NSString *)title withTitleColor:(UIColor *)color;
@end

@interface UIImageView(base)
+ (UIImageView *)imageViewWithName:(NSString *)name;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame;
@end

@interface UILabel (base)
+ (UILabel *)labelWithFrame:(CGRect)frame;
+ (UILabel *)labelWithFrame:(CGRect)frame color:(UIColor *)aColor text:(NSString *)aText font:(CGFloat)aFont;
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font x:(CGFloat)x y:(CGFloat)y;

//- (CGFloat) resizeLabel:(UILabel *)theLabel;
//
//- (CGFloat) resizeLabel:(UILabel *)theLabel shrinkViewIfLabelShrinks:(BOOL)canShrink;
@end

@interface UIBarButtonItem (base)

+(UIBarButtonItem *)initWithTitle:(NSString *)title target:(id)target image:(NSString *)path action:(SEL)action;

@end

