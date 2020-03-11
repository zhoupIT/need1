//
//  ZPNetWorkTool.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPNetWorkTool.h"
#import "ZPLoginController.h"
#import "ZPBaseNavigationController.h"
@interface ZPNetWorkTool()
@property (nonatomic, strong) NSMutableDictionary *taskDictionary;
@property (nonatomic, strong) NSDictionary *allApiMethods;
@end
@implementation ZPNetWorkTool
ZPSingletonM(ZPNetWorkTool)

#pragma mark - 网络请求
- (void)GETRequestWith:(NSString *)apiName parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failed:(void (^)(NSURLSessionDataTask *, NSError *))failed className:(__unsafe_unretained Class)className {
    NSString *classString = NSStringFromClass(className);
    
    NSURLSessionDataTask *dataTask = [[ZPNetWorkManager shareNetWorkManager] GET:self.allApiMethods[apiName] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        ZPLog(@"请求地址%@,responseObject%@",self.allApiMethods[apiName],responseObject);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        if (success) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                 [MBProgressHUD hideHUD];
                 [self switchToLoginPage:classString];
            }else if ([[responseObject objectForKey:@"code"] integerValue] == 402) {
                [self clearLoginInfo];
                [LEEAlert alert].config
                .LeeContent([responseObject objectForKey:@"message"])
                .LeeAction(@"确认", ^{
                     [MBProgressHUD hideHUD];
                     [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
                })
                .LeeShow();
            } else {
            success(task, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZPLog(@"error===%@, task%@", error, task);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        NSString *errorDesc = error.localizedDescription;
        if (![errorDesc isEqualToString:@"已取消"]) {
            if (failed) {
                failed(task, error);
            }
        }else {
            NSLog(@"取消请求或者控制器销毁");
        }
    }];
    
    [self addTaskToDictionaryWith:classString task:dataTask];
}


- (void)GETRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failed:(void (^)(NSURLSessionDataTask *, NSError *))failed className:(__unsafe_unretained Class)className {
    NSString *classString = NSStringFromClass(className);
    
    NSURLSessionDataTask *dataTask = [[ZPNetWorkManager shareNetWorkManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ZPLog(@"responseObject%@", responseObject);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        if (success) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                 [MBProgressHUD hideHUD];
                 [self switchToLoginPage:classString];
            } else if ([[responseObject objectForKey:@"code"] integerValue] == 402) {
                [self clearLoginInfo];
                [LEEAlert alert].config
                .LeeContent([responseObject objectForKey:@"message"])
                .LeeAction(@"确认", ^{
                    [MBProgressHUD hideHUD];
                    [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
                })
                .LeeShow();
            }else {
                success(task, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZPLog(@"error===%@, task%@", error, task);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        NSString *errorDesc = error.localizedDescription;
        if (![errorDesc isEqualToString:@"已取消"]) {
            if (failed) {
                failed(task, error);
            }
        }else {
            NSLog(@"取消请求或者控制器销毁");
        }
    }];
    
    [self addTaskToDictionaryWith:classString task:dataTask];
}

- (void)POSTRequestWith:(NSString *)apiName parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failed:(void (^)(NSURLSessionDataTask *, NSError *))failed className:(Class)className {
    NSString *classString = NSStringFromClass(className);
    NSURLSessionDataTask *dataTask = [[ZPNetWorkManager shareNetWorkManager] POST:self.allApiMethods[apiName] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZPLog(@"responseObject%@", responseObject);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        if ([apiName isEqualToString:@"login"] || [apiName isEqualToString:@"wx/login"]) {
            
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZPBaseUrl,self.allApiMethods[apiName]]]];
            for (NSHTTPCookie *cookie in cookies)
            {
                NSDictionary * cookieDic = [cookie properties];
                 ZPLog(@"cookie值是:%@",cookieDic);
                if ([[cookieDic allKeys] containsObject:@"Name"] && [cookieDic[@"Name"] isEqualToString:@"_IDENTIY_KEY_"]) {
                    NSString *cookieValue = cookieDic[@"Value"];
                    [kUSER_DEFAULT setValue:cookieValue forKey:@"lectureToken"];
                    [kUSER_DEFAULT synchronize];
                }
            }
            
            NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            [kUSER_DEFAULT setObject: cookiesData forKey:@"_IDENTIY_KEY_"];
            [kUSER_DEFAULT synchronize];
            
        }
        if (success) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                 [MBProgressHUD hideHUD];
                 [self switchToLoginPage:classString];
            }else if ([[responseObject objectForKey:@"code"] integerValue] == 402) {
                [self clearLoginInfo];
                [LEEAlert alert].config
                .LeeContent([responseObject objectForKey:@"message"])
                .LeeAction(@"确认", ^{
                     [MBProgressHUD hideHUD];
                    [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
                })
                .LeeShow();
            } else {
                success(task, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZPLog(@"error===%@, task%@", error, task);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        NSString *errorDesc = error.localizedDescription;
        if (![errorDesc isEqualToString:@"已取消"]) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (responses.statusCode == 401) { // token错误退出登录
                if (!self.isSwitchToLoginVC) {
                    
                }
            }else {
                if (failed) {
                    failed(task, error);
                }
            }
        }else {
            ZPLog(@"取消请求或者控制器销毁");
        }
    }];
    
    [self addTaskToDictionaryWith:classString task:dataTask];
}

- (void)POSTRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failed:(void (^)(NSURLSessionDataTask *, NSError *))failed className:(Class)className {
    NSString *classString = NSStringFromClass(className);
    NSURLSessionDataTask *dataTask = [[ZPNetWorkManager shareNetWorkManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZPLog(@"responseObject%@", responseObject);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        
        if (success) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                 [MBProgressHUD hideHUD];
                 [self switchToLoginPage:classString];
            }else if ([[responseObject objectForKey:@"code"] integerValue] == 402) {
                [self clearLoginInfo];
                [LEEAlert alert].config
                .LeeContent([responseObject objectForKey:@"message"])
                .LeeAction(@"确认", ^{
                     [MBProgressHUD hideHUD];
                    [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
                })
                .LeeShow();
            } else {
                success(task, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZPLog(@"error===%@, task%@", error, task);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        NSString *errorDesc = error.localizedDescription;
        if (![errorDesc isEqualToString:@"已取消"]) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (responses.statusCode == 401) { // token错误退出登录
                if (!self.isSwitchToLoginVC) {
                    
                }
            }else {
                if (failed) {
                    failed(task, error);
                }
            }
        }else {
            ZPLog(@"取消请求或者控制器销毁");
        }
    }];
    
    [self addTaskToDictionaryWith:classString task:dataTask];
}

- (void)POSTRequestWith:(NSString *)apiName parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failed:(void (^)(NSURLSessionDataTask *, NSError *))failed className:(Class)className {
    NSString *classString = NSStringFromClass(className);
    
    NSURLSessionDataTask *dataTask = [[ZPNetWorkManager shareNetWorkManager] POST:self.allApiMethods[apiName] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZPLog(@"responseObject%@", responseObject);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        if (success) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 401) {
                 [MBProgressHUD hideHUD];
                [self switchToLoginPage:classString];
            } else if ([[responseObject objectForKey:@"code"] integerValue] == 402) {
                [self clearLoginInfo];
                [LEEAlert alert].config
                .LeeContent([responseObject objectForKey:@"message"])
                .LeeAction(@"确认", ^{
                     [MBProgressHUD hideHUD];
                    [[NSNotificationCenter defaultCenter] postNotificationName:classString object:nil];
                })
                .LeeShow();
            }else {
                success(task, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         ZPLog(@"error===%@, task%@", error, task);
        NSMutableArray *taskArray = self.taskDictionary[classString];
        [taskArray removeObject:task];
        NSString *errorDesc = error.localizedDescription;
        if (![errorDesc isEqualToString:@"已取消"]) {
            if (failed) {
                failed(task, error);
            }
        }else {
            ZPLog(@"取消请求或者控制器销毁");
        }
    }];
    
    [self addTaskToDictionaryWith:classString task:dataTask];
    
}

- (void)cancelAllRequest {
    [[ZPNetWorkManager shareNetWorkManager].operationQueue cancelAllOperations];
}

- (void)cancelAllRequestsWith:(Class)className {
    NSString *classString = NSStringFromClass(className);
    NSMutableArray *taskArray = self.taskDictionary[classString];
    if (taskArray.count) {
        [taskArray enumerateObjectsUsingBlock:^(NSURLSessionTask *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.taskDictionary removeObjectForKey:className];
    }
}

- (void)addTaskToDictionaryWith:(NSString *)className task:(NSURLSessionTask *)task {
    if (task !=nil) {
        NSMutableArray *taskArray = self.taskDictionary[className];
        if (taskArray == nil) {
            taskArray = [NSMutableArray array];
            self.taskDictionary[className] = taskArray;
        }
        [taskArray addObject:task];
    }
}

- (void)switchToLoginPage:(NSString *)className {
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
    //弹出登录页面
    [[NSNotificationCenter defaultCenter] postNotificationName:className object:nil];
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

- (NSMutableDictionary *)taskDictionary {
    if (!_taskDictionary) {
        _taskDictionary = [NSMutableDictionary dictionary];
    }
    return _taskDictionary;
}

- (NSDictionary *)allApiMethods {
    if (!_allApiMethods) {
        _allApiMethods = @{
                           @"customer/steps":@"/api/common/customer/steps",
                           @"login":@"/api/common/customer/auth/login",
                           @"token":@"/api/common/customer/auth/im/info",
                           @"register/oneself":@"/api/common/customer/auth/register/oneself",
                           @"register/company":@"/api/common/customer/auth/register/company",
                           @"forget":@"/api/common/customer/auth/password/forget",
                           @"receiveAddress/list":@"/api/common/receiveAddress/list",
                           @"phone":@"/api/common/customer/auth/phone",
                           @"password/reset":@"/api/common/customer/auth/password/reset",
                           @"modifyUserInfo":@"/api/common/customer",
                           @"file":@"/api/file/aliyun/oss/upload",
                           @"bind":@"/api/common/company/code/bind",
                           @"appComment/save":@"/api/common/app/comment/save",
                           @"store/commodity":@"/api/store/commodity/list",
                           @"cart":@"/api/store/shopping/cart",
                           @"order":@"/api/order/order",
                           @"consult/list":@"/api/advisory/consult/list",
                           @"advisory/doctor":@"/api/advisory/doctor",
                           @"payment/wechat":@"/api/order/payment/wechat",
                           @"medicalCity/list":@"/api/green/channel/medicalCity/list",
                           @"medicalPerson/list":@"/api/green/channel/medicalPerson/list",
                           @"channel/medicalPerson":@"/api/green/channel/medicalPerson",
                           @"channel/service":@"/api/green/channel/green/channel/service",
                           @"redDot":@"/api/order/order/pay/message",
                           @"receiveAddress/default":@"/api/common/receiveAddress/default",
                           @"receiveAddress":@"/api/common/receiveAddress",
                           @"plan/list":@"/api/my/plan/personal/plan/list",
                           @"personal/plan":@"/api/my/plan/personal/plan",
                           @"item":@"/api/my/plan/plan/item",
                           @"healthDirection/list":@"/api/article/health/direction",
                           @"healthInformation/list":@"/api/article/health/information",
                           @"cancellation":@"/api/order/order/cancellation",
                           @"nibp":@"/api/chronic/nibp",
                           @"ua":@"/api/chronic/ua",
                           @"spo":@"/api/chronic/spo2",
                           @"glu":@"/api/chronic/glu",
                           @"bodyIndex":@"/api/chronic/bodyIndex",
                           @"weight":@"/api/chronic/weight",
                           @"bf":@"/api/chronic/bf",
                           @"nibp/level/count":@"/api/chronic/nibp/level/count",
                           @"glu/level/count":@"/api/chronic/glu/level/count",
                           @"idata/message":@"/api/chronic/receive/idata/message",
                           @"message/list":@"/api/chronic/receive/idata/message/list",
                           @"message/message":@"/api/message/message",
                           @"authcode/phone/check":@"/api/common/customer/auth/authcode/phone/check",
                           @"psychologicalAssessment/register":@"/api/psychological/assessment/register",
                           @"psychologicalAssessment":@"/api/psychological/assessment/postInfo",
                           @"get/scores":@"/api/psychological/assessment/get/scores",
                           @"selftest":@"/api/common/selftest",
                           @"assessment/get/report":@"/api/psychological/assessment/get/report",
                           @"version":@"/api/common/app/version/present/IOS",
                           @"archives":@"/api/chronic/my/archives",
                           @"my/archives":@"/api/chronic/my/archives",
                           @"article/comment":@"/api/article/comment/list",
                           @"comment/like":@"/api/article/comment/like",
                           @"alipay/result/return_url":@"/api/order/payment/alipay/result/return_url",
                           @"banner":@"/api/common/banner",
                           @"consult/remain":@"/api/common/company/code/consult/remain",
                           @"wx/login":@"/api/common/customer/auth/wx/login",
                           @"wx/bind/status":@"/api/common/customer/auth/wx/bind/status",
                           @"wx/bind":@"/api/common/customer/auth/wx/bind",
                           @"advisory/channel":@"/api/advisory/channel/list",
                           @"channel/detail":@"/api/advisory/channel/detail",
                           @"doctor/commodity":@"/api/advisory/channel/doctor/commodity",
                           @"lecture/list":@"/api/advisory/channel/doctor/lecture/list",
                           @"lecture/all":@"/api/advisory/channel/doctor/lecture/all",
                           @"lecture/history":@"/api/advisory/channel/doctor/lecture/others",
                           @"traces":@"/api/order/logistics/traces",
                           @"dynamic":@"/api/article/health/dynamic",
                           @"cabin/detail":@"/api/advisory/health/cabin/detail",
                           @"order/receipt/confirm":@"/api/order/order/receipt/confirm",
                           @"cityService/hospital":@"/api/green/channel/cityService/hospital",
                           @"customer/tags":@"/api/common/customer/tags",
                           @"settlement":@"/api/store/shopping/cart/settlement",
                           @"commodity/settlement":@"/api/store/commodity/settlement",
                           @"psychologicalAssessment/register":@"/api/psychological/assessment/register"
                           };
    }
    return _allApiMethods;
}
@end
