#import <Foundation/Foundation.h>

#define NoResultViewTag 598

@interface UIView (YY)

@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;
@property CGFloat centerX;
@property CGFloat centerY;
@property CGFloat height;
@property CGFloat width;

+ (id)viewWithFrame:(CGRect)frame;

- (void)debug;

- (void)fuckBlur;

@end