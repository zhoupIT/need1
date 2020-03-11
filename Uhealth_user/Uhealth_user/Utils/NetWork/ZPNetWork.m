//
//  ZPNetWork.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPNetWork.h"
#import "ZPLoginController.h"
#import "ZPBaseNavigationController.h"
@implementation ZPNetWork

ZPSingletonM(ZPNetWork)

- (void)requestWithUrl:(NSString *)urlStr andHTTPMethod:(NSString *)httpMethod andDict:(NSDictionary *)dict success:(void(^)(NSDictionary *response))success failed:(void (^)(NSError *error))failed withClassName:(NSString *)classString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ZPBaseUrl,urlStr]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = httpMethod;
    
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
    if (dict == nil) {
        dict = @{};
    }
    NSDictionary *msg = dict;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
    
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        ZPLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUD];
            if (error == nil) {
                NSDictionary *dict = [data mj_JSONObject];
                if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                    if (success) {
                       success(dict);
                    }
                } else if ([[dict objectForKey:@"code"] integerValue]  == 401){
                    //未登录页面
                    [self logoutwithClassName:classString];
                } else if ([[dict objectForKey:@"code"] integerValue] == 402) {
                    [self clearLoginInfo];
                    [LEEAlert alert].config
                    .LeeContent([dict objectForKey:@"message"])
                    .LeeAction(@"确认", ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
                    })
                    .LeeShow();
                }else {
                    [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    if (failed) {
                        failed(error);
                    }
                }
            } else {
                [MBProgressHUD showError:error.localizedDescription];
                if (failed) {
                    failed(error);
                }
            }
        });
        
    }] resume];
}

- (void)logoutwithClassName:(NSString *)classString {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
    [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
}

//清除登录信息
- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
}
@end
