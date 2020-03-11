//
//  Utils.h
//  SocketDemo
//
//  Created by smy on 2017/11/24.
//  Copyright © 2017年 smy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
/**
 *  Object转换为JSON
 *
 *  @param object NSArray，NSDictionary
 *
 *  @return JSON
 */
+ (NSString *)jsonString:(id)object;

/**
 *  JSON转换为Object
 *
 *  @param json JSON字符串
 *
 *  @return Object
 */
+ (id)jsonToObject:(NSString *)json;

/**
 *  校验手机号
 *
 *  @param phone 手机号码
 *
 *  @return BOOL
 */
+ (BOOL)checkPhoneNumber:(NSString *)phone;

/**
 *  校验验证码
 *
 *  @param code 验证码
 *
 *  @return BOOL
 */
+ (BOOL)checkSmsCode:(NSString *)code;

/**
 *  校验验证码
 *
 *  @param password 密码
 *
 *  @return BOOL
 */
+ (BOOL)checkPassword:(NSString *)password;

/**
 *  验证身份证号码
 *
 *  @param cardNo 身份证号码
 *
 *  @return BOOL
 */
+ (BOOL)checkIDCardNumber:(NSString *)cardNo;

/**
 *  生成纯色图片（给button赋值）
 *
 *  @param color 颜色
 *
 *  @param size 尺寸，可传CGSizeZero
 *
 *  @param radius 圆角，传0时不需要圆角
 *
 *  @return UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;

/**
 *  将普通字符串转换成base64字符串
 *
 *  @param text 普通字符串
 *
 *  @return base64字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 *  将base64字符串转换成普通字符串
 *
 *  @param base64 base64字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)textFromBase64String:(NSString *)base64;

/**
 *  判断字符串里是否存在中文
 *
 *  @param text 普通字符串
 *
 *  @return BOOL
 */
+ (BOOL)hasChinese:(NSString *)text;
//判断是否有emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

/** 适配不同屏幕的高度(默认设置的是6机型) */
+ (CGFloat)ZPDeviceHeightRation;
/** 适配不同屏幕的宽度(默认设置的是6机型) */
+ (CGFloat)ZPDeviceWidthRation;

/**
 *  比较两个版本号的大小
 *
 *  @param v1 第一个版本号
 *  @param v2 第二个版本号
 *  @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;
@end
