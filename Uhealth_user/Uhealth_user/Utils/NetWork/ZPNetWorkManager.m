//
//  ZPNetWorkManager.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPNetWorkManager.h"

@implementation ZPNetWorkManager
static ZPNetWorkManager *_instance = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareNetWorkManager {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:ZPBaseUrl]];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        
        
        // 设置请求传输格式为json
//        _instance.requestSerializer = [AFHTTPRequestSerializer serializer];
          _instance.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置响应传输格式为二进制
        //        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_instance.requestSerializer setValue:@"kzxw-ios" forHTTPHeaderField:@"User-Agent"];
        //        [_instance.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {            
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"_IDENTIY_KEY_"]];
            NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie * cookie in cookies){
                [cookieStorage setCookie: cookie];
            }
        } 
        [_instance.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _instance.requestSerializer.timeoutInterval = 30.0;
        [_instance.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return _instance;
}

+ (void)destroyInstance {
    onceToken = 0;
    _instance = nil;
    
}
@end
