//
//  AppDelegate+AppService.h
//  EasyTrade
//
//  Created by Rohon on 2017/12/1.
//  Copyright © 2017年 Rohon. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)
//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化 UMeng
-(void)initUMeng;

//初始化 Bugly
-(void)initBugly;

//初始化用户系统
-(void)initUserManager;

//监听网络状态
- (void)monitorNetworkStatus;

//监听通知
- (void)monitorNotificationWithOptions:(NSDictionary *)launchOptions;


//单例
+ (AppDelegate *)sharedAppDelegate;


/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;


@end
