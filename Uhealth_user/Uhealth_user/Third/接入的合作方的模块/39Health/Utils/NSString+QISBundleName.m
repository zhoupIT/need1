//
//  NSString+QISBundleName.m
//  YYK
//
//  Created by xiexianyu on 5/13/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "NSString+QISBundleName.h"
#import <UIKit/UIKit.h>

@implementation NSString (QISBundleName)

- (NSString*)bundleNameForDevice
{
    UIUserInterfaceIdiom idiom = [UIDevice currentDevice].userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPad) {
        // ipad
        return [NSString stringWithFormat:@"%@_iPad", self];
    }
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    NSString *name = nil;
    if (screenHeight > 812.0 - 0.1) {
        //iPhoneX
        name = [NSString stringWithFormat:@"%@_6Plus", self];
    }
    else if (screenHeight > 736.0 + 0.1) {
        // maybe iphone in future
        name = [NSString stringWithFormat:@"%@_6Plus", self];
    }
    else if (screenHeight > 736.0 - 0.1) {
        name = [NSString stringWithFormat:@"%@_6Plus", self];
    }
    else if(screenHeight > 667.0 - 0.1) {
        name = [NSString stringWithFormat:@"%@_6", self];
    }
    else if(screenHeight > 568.0 - 0.1) {
        name = [NSString stringWithFormat:@"%@_5S", self];
    }
    else if (screenHeight > 480.0 - 0.1) {
        name = [NSString stringWithFormat:@"%@", self];
    }
    
    return name;
}

@end
