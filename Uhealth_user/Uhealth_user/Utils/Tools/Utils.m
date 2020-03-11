//
//  Utils.m
//  SocketDemo
//
//  Created by smy on 2017/11/24.
//  Copyright © 2017年 smy. All rights reserved.
//

#import "Utils.h"
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (([[UIScreen mainScreen] bounds].size.height == 667) ? YES : NO)

#define IOS_IPhone6plusS (([[UIScreen mainScreen] bounds].size.height = 736) ? YES : NO)
@implementation Utils
+ (NSString *)jsonString:(id)object {
    NSString *jsonStr;
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        if (data) {
            jsonStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return jsonStr;
}

+ (id)jsonToObject:(NSString *)json {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

+ (BOOL)checkPhoneNumber:(NSString *)phone {
    if (!phone) return NO;
    NSString *regex = @"^1[3456789]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [predicate evaluateWithObject:phone];
    return isValid;
}

+ (BOOL)checkSmsCode:(NSString *)code {
    if (!code) return NO;
    NSString *regex = @"^[0-9]{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [predicate evaluateWithObject:code];
    return isValid;
}

+ (BOOL)checkPassword:(NSString *)password {
    if (!password) return NO;
    NSString *regex = @"^[0-9A-Za-z]]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [predicate evaluateWithObject:password];
    return isValid;
}

/// 验证身份证号码
+ (BOOL)checkIDCardNumber:(NSString *)cardNo {
    NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X)$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:cardNo]) return NO;
    // 省份代码。如果需要更精确的话，可以把六位行政区划代码都列举出来比较。
    NSString *provinceCode = [cardNo substringToIndex:2];
    NSArray *proviceCodes = @[@"11", @"12", @"13", @"14", @"15",
                              @"21", @"22", @"23",
                              @"31", @"32", @"33", @"34", @"35", @"36", @"37",
                              @"41", @"42", @"43", @"44", @"45", @"46",
                              @"50", @"51", @"52", @"53", @"54",
                              @"61", @"62", @"63", @"64", @"65",
                              @"71", @"81", @"82", @"91"];
    if (![proviceCodes containsObject:provinceCode]) return NO;
    
//    if (cardNo.length == 15) {
//        return [self validate15DigitsIDCardNumber:cardNo];
//    } else {
        return [self validate18DigitsIDCardNumber:cardNo];
//    }
}

#pragma mark Helpers
/// 15位身份证号码验证。6位行政区划代码 + 6位出生日期码(yyMMdd) + 3位顺序码
+ (BOOL)validate15DigitsIDCardNumber:(NSString *)cardNo {
    NSString *birthday = [NSString stringWithFormat:@"19%@", [cardNo substringWithRange:NSMakeRange(6, 6)]]; // 00后都是18位的身份证号
    
    return [self validateBirthDate:birthday];
}

/// 18位身份证号码验证。6位行政区划代码 + 8位出生日期码(yyyyMMdd) + 3位顺序码 + 1位校验码
+ (BOOL)validate18DigitsIDCardNumber:(NSString *)cardNo {
    NSString *birthday = [cardNo substringWithRange:NSMakeRange(6, 8)];
    if (![self validateBirthDate:birthday]) return NO;
    
    // 验证校验码
    int weight[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    
    int sum = 0;
    for (int i = 0; i < 17; i ++) {
        sum += [cardNo substringWithRange:NSMakeRange(i, 1)].intValue * weight[i];
    }
    int mod11 = sum % 11;
    NSArray<NSString *> *validationCodes = [@"1 0 X 9 8 7 6 5 4 3 2" componentsSeparatedByString:@" "];
    NSString *validationCode = validationCodes[mod11];
    
    return [cardNo hasSuffix:validationCode];
}

/// 验证出生年月日(yyyyMMdd)
+ (BOOL)validateBirthDate:(NSString *)birthday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:birthday];
    return date != nil;
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    if (size.width == 0) {
        size.width = kSCREEN_WIDTH;
    }
    if (size.height == 0) {
        size.height = kSCREEN_HEIGHT;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    if (radius > 0) {
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    }
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (NSString *)base64StringFromText:(NSString *)text {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSString *)textFromBase64String:(NSString *)base64 {
    NSData *data =[base64 dataUsingEncoding:NSUTF8StringEncoding];
     NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
}

+ (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

//判断是否有emoji
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//默认的尺寸是6
+ (CGFloat)ZPDeviceHeightRation {
    if (IS_IPHONE4) {
        return 0.720;
    }
    else if (IS_IPHONE5){
        return 0.852;
    }
    else if (IS_IPhone6){
        return 1.000;
    }
    else {
        return 1.103;
    }
}

+ (CGFloat)ZPDeviceWidthRation {
    if (IS_IPHONE4) {
        return 0.853;
    }
    else if (IS_IPHONE5){
        return 0.853;
    }
    else if (IS_IPhone6){
        return 1.000;
    }
    else {
        return 1.104;
    }
}

+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}
@end
