//
//  NSString+QISURLEncoding.m
//  Ask
//
//  Created by xianyuxie on 10/9/14.
//  Copyright (c) 2014 SQN. All rights reserved.
//

#import "NSString+QISURLEncoding.h"

@implementation NSString (QISURLEncoding)

// url encoded/decoded string
- (NSString*)urlDecodedString
{
    return [self urlDecodedStringUsingEncoding:kCFStringEncodingUTF8];
}

- (NSString*)urlEncodedString
{
    return [self urlEncodedStringUsingEncoding:kCFStringEncodingUTF8];
}

// CFStringEncoding
// NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

- (NSString*)urlDecodedStringUsingEncoding:(CFStringEncoding)encodeing
{
    CFStringRef cfStrRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), encodeing);
    return (__bridge_transfer NSString *)cfStrRef;
}

- (NSString*)urlEncodedStringUsingEncoding:(CFStringEncoding)encodeing
{
    // characters from AFN lib, but remove * character for java not encode *
    CFStringRef cfStrRef = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                   (__bridge CFStringRef)self,
                                                                   NULL,
                                                                   (CFStringRef)@":/?&=;+!@#$()',~", /*from AFN lib*/
                                                                   encodeing);
    return (__bridge_transfer NSString *)cfStrRef;
}

@end
