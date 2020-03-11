//
//  UIImage+ZPImage.h
//  IDevent
//
//  Created by peng on 16/3/17.
//  Copyright © 2016年 IDevent.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZPImage)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
+ (UIImage *)getPicZoomImage:(UIImage *)image andH:(CGFloat)PicAfterZoomHeight andW:(CGFloat)PicAfterZoomWidth;
+ (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size isScaleToMax:(BOOL)isScaleToMax;
+ (UIImage*)imageWithColor:(UIColor *)color forSize:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

- (UIImage *)imageWithSize:(CGSize)size;
+(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

- (UIImage *)zp_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor;
@end
