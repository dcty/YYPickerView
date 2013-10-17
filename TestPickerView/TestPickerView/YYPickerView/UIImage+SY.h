//
// Created by ivan on 13-5-8.
//
//


#import <Foundation/Foundation.h>

@interface UIImage (SY)
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width;

- (UIImage *)resizableImageCenter;
- (UIImage *)resizableImageWithCGSize:(CGSize)size;
@end