//
//  UIImage+QISCompressToJPG.m
//  Ask
//
//  Created by xiexianyu on 11/5/14.
//  Copyright (c) 2014 SQN. All rights reserved.
//

#import "UIImage+QISCompressToJPG.h"

@implementation UIImage (QISCompressToJPG)

- (BOOL)isTransparentAtPoint:(CGPoint)point
{
    UIImage *fixedImage = [self imageWithFixedOrientation];
    CGImageRef inImage = [fixedImage CGImage];
    size_t w = CGImageGetWidth(inImage);
    //size_t h = CGImageGetHeight(inImage);
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    // RGBA format
    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger index = ((w  * point.y * scale) + point.x * scale) * 4; // The image is png
    //UInt8 red = data[index];
    //UInt8 green = data[index+1];
    //UInt8 blue = data[index+2];
    UInt8 alpha = data[index+3];
    
    CFRelease(pixelData);
    
    //DebugLog(@"r%f g%f b%f", red/1.0, green/1.0, blue/1.0);
    //DebugLog(@"alpha %f", alpha/1.0);
    UInt8 thresholdAlpha = 16;
    if (alpha > thresholdAlpha) {
        return NO;
    }
    else {
        // transparent
        return YES;
    }
    
    return NO;
}

// helper
- (UIImage *)imageWithFixedOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
