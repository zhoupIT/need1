//
//  UIImage+ZPImage.m
//  IDevent
//
//  Created by peng on 16/3/17.
//  Copyright © 2016年 IDevent.inc. All rights reserved.
//

#import "UIImage+ZPImage.h"

@implementation UIImage (ZPImage)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



+ (UIImage *)getPicZoomImage:(UIImage *)image andH:(CGFloat)PicAfterZoomHeight andW:(CGFloat)PicAfterZoomWidth{
    
    UIImage *img = image;
    
    int h = img.size.height;
    int w = img.size.width;
    if(h <= PicAfterZoomWidth && w <= PicAfterZoomHeight)
    {
        image = img;
    }
    else
    {
        float b = (float)PicAfterZoomWidth/w < (float)PicAfterZoomHeight/h ? (float)PicAfterZoomWidth/w : (float)PicAfterZoomHeight/h;
        CGSize itemSize = CGSizeMake(b*w, b*h);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
        [img drawInRect:imageRect];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return img;
}

+ (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size isScaleToMax:(BOOL)isScaleToMax {
    CGFloat scale =  [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGSize aspectFitSize = CGSizeZero;
    if (image.size.width != 0 && image.size.height != 0) {
        CGFloat rateWidth = size.width / image.size.width;
        CGFloat rateHeight = size.height / image.size.height;
        
        CGFloat rate = isScaleToMax ? MAX(rateHeight, rateWidth) : MIN(rateHeight, rateWidth);
        aspectFitSize = CGSizeMake(image.size.width * rate, image.size.height * rate);
    }
    
    [image drawInRect:CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}
+ (UIImage*)imageWithColor:(UIColor *)color forSize:(CGSize)size
{
    if (size.width <= 0 || size.height<= 0 )
    {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect _rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(_rect.size);
    CGContextRef _context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(_context, [color CGColor]);
    CGContextFillRect(_context, _rect);
    
    UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    CGRect _rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(_rect.size);
    CGContextRef _context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *_path = [UIBezierPath bezierPathWithRoundedRect:_rect cornerRadius:cornerRadius];
    CGContextSetFillColorWithColor(_context, [color CGColor]);
    CGContextAddPath(_context, _path.CGPath);
    CGContextFillPath(_context);
    
    UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _image;
}

- (UIImage *)imageWithSize:(CGSize)size
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= size.width && height <= size.height){
        return self;
    }
    
    if (width == 0 || height == 0){
        return self;
    }
    
    CGFloat widthFactor = size.width / width;
    CGFloat heightFactor = size.height / height;
    CGFloat scaleFactor = MIN(widthFactor, heightFactor);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)_scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // to do
    return nil;
}

//指定宽度按比例缩放
+(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)zp_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor {
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    CGFloat radius = MIN(size.width, size.height) * 0.5;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [fillColor setFill];
    UIRectFill(rect);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    [self drawInRect:rect];
    UIImage *cornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cornerImage;
}
@end
