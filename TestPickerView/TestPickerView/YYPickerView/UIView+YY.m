//
// Created by cai on 13-3-6.
//
//


//
// Created by cai on 13-3-6.
//
//


#import <QuartzCore/QuartzCore.h>
#import "UIView+YY.h"


@implementation UIView (Cai)
- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    self.top = bottom - self.height;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right
{
    self.left = right - self.width;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


+ (id)viewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

/**
 *  UIView添加一个border，方便调UI
 */
- (void)debug
{
    self.layer.borderColor = [UIColor colorWithRed:((CGFloat) (abs(arc4random() % 256)) / 255) green:((CGFloat) (abs(arc4random() % 256)) / 255) blue:((CGFloat) (abs(arc4random() % 256)) / 255) alpha:1.0].CGColor;
    self.layer.borderWidth = 1.0f;
}

/**
 *   干掉view模糊
 */
- (void)fuckBlur
{
    int x = (int) self.frame.origin.x;
    int y = (int) self.frame.origin.y;
    int width = (int) self.frame.size.width;
    int height = (int) self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}
@end