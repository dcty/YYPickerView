//
// Created by ivan on 13-5-8.
//
//


#import "UIImage+SY.h"


@implementation UIImage (SY)
- (UIImage *)resizableImageCenter
{
    CGSize imageSize = self.size;
    CGFloat centerX = imageSize.width / 2;
    CGFloat centerY = imageSize.height / 2;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(centerY - 0.5, centerX - 0.5, centerY + 0.5, centerX + 0.5);
    return [self resizableImageWithCapInsets:edgeInsets];
}

- (UIImage *)resizableImageWithCGSize:(CGSize)size
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(size.height, size.width, size.height, size.width)];
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;

    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end