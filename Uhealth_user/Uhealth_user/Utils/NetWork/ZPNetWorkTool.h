//
//  ZPNetWorkTool.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singleton.h"
#import "ZPNetWorkManager.h"
@interface ZPNetWorkTool : NSObject
@property (nonatomic, assign) BOOL isSwitchToLoginVC;

ZPSingletonH(ZPNetWorkTool)


/**
 GET请求
 
 @param apiName 自己定义的接口名字
 @param parameters 接口参数
 @param progress 进度
 @param success 成功回调
 @param failed 失败回调
 @param className 当前发起请求的类名
 */
- (void)GETRequestWith:(NSString *)apiName
            parameters:(NSDictionary *)parameters
              progress:(void(^)(NSProgress *progress))progress
               success:(void(^)(NSURLSessionDataTask *task, id response))success
                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed className:(Class)className;


- (void)GETRequestWithUrlString:(NSString *)apiName
            parameters:(NSDictionary *)parameters
              progress:(void(^)(NSProgress *progress))progress
               success:(void(^)(NSURLSessionDataTask *task, id response))success
                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed className:(Class)className;


/**
 POST请求
 
 @param apiName 自己定义的接口名字
 @param parameters 接口参数
 @param progress 进度
 @param success 成功回调
 @param failed 失败回调
 @param className 当前发起请求的类名
 */
- (void)POSTRequestWith:(NSString *)apiName
             parameters:(NSDictionary *)parameters
               progress:(void(^)(NSProgress *progress))progress
                success:(void(^)(NSURLSessionDataTask *task, id response))success
                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed className:(Class)className;


- (void)POSTRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failed:(void (^)(NSURLSessionDataTask *, NSError *))failed className:(Class)className;

/**
 上传文件
 
 @param apiName 自己定义的接口名字
 @param parameters 接口参数
 @param block 拼接文件,设置文件的名字和格式
 @param progress 进度
 @param success 成功回调
 @param failed 失败回调
 @param className 当前发起请求的类名
 */
- (void)POSTRequestWith:(NSString *)apiName
             parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))block
               progress:(void(^)(NSProgress *progress))progress
                success:(void(^)(NSURLSessionDataTask *task, id response))success
                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed className:(Class)className;

/**
 取消请求
 
 @param className 取消当前请求的类名
 */
- (void)cancelAllRequestsWith:(Class)className;

/**
 取消所有网络请求
 */
- (void)cancelAllRequest;
@end
