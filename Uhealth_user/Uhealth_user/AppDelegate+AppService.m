//
//  AppDelegate+AppService.m
//  EasyTrade
//
//  Created by Rohon on 2017/12/1.
//  Copyright © 2017年 Rohon. All rights reserved.
//

#import "AppDelegate+AppService.h"
/* model */
#import "ZPCommodity.h"
#import "ZPHealthNewsModel.h"
#import "ZPHealthWindModel.h"
#import "ZPAdvisoryChannelModel.h"
/* controller */
#import "ZPBaseTabBarViewController.h"
#import "ZPBaseNavigationController.h"
#import "ZPWelcomeController.h"
#import "ZPRootWebViewController.h"
#import "ZPOrderDetailController.h"
#import "ZPRootArticleWebViewController.h"
#import "ZPLivingBroadcastFromBannerController.h"

#import "DiseaseMatchViewController.h"
#import "ZPAdvisoryController.h"
#import "ZPMoreLecturesController.h"
#import "ZPConsultDoctorController.h"
#import "ZPAuthorityCenterController.h"
#import "ZPShopMallController.h"
#import "ZPMyStepsController.h"
#import "ZPMyOrderMainController.h"
/* 三方 */
#import "IQKeyboardManager.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import <Bugly/Bugly.h>
#import "EBBannerView.h"
@implementation AppDelegate (AppService)
#pragma mark ————— 初始化服务 —————
-(void)initService{
    //键盘处理
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //右滑返回手势
    
    //UM
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXPayKey appSecret:UMAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    [WXApi registerApp:WXPayKey];
    
    //bugly
    [Bugly startWithAppId:BuglyAppId];
    
}


#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self initRootView];
    [self.window makeKeyAndVisible];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)initRootView {
    if (![kUSER_DEFAULT boolForKey:@"FirstRun"]) {
        //如果是第一次运行就添加BOOL并赋值
        [kUSER_DEFAULT setBool:YES forKey:@"FirstRun"];
        
        //图片数据
        NSArray *images = @[@"1",@"2",@"3",@"4"];
        //初始化控制器
        ZPWelcomeController *welcomeVC =[[ZPWelcomeController alloc]initWelcomeView:images firstVC:[[ZPBaseTabBarViewController alloc]init]];
        //添加根控制器
        self.window.rootViewController = welcomeVC;
    }else{
        ZPBaseTabBarViewController *tabbar = [[ZPBaseTabBarViewController alloc] init];
        self.window.rootViewController = tabbar;
    }
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
    
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
   
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng{
    
    /* 设置友盟appkey */
    
}

#pragma mark ————— bugly 初始化 —————
-(void)initBugly{
    
    /* 设置Bugly appkey */
    
}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    
}

#pragma mark ————— 通知监听 —————
- (void)bannerDidClick:(NSNotification*)noti {
    ZPLog(@"通知:%@",noti.object);
    NSDictionary *dict = noti.object;
    if ([dict[@"messageType"] isEqualToString:@"BODY_CHECK_SYSTEM_NOTICE"]) {
//        ZPBaseTabBarViewController *tabVC = (ZPBaseTabBarViewController *)self.window.rootViewController;
//        ZPBaseNavigationController *pushClassStance = (ZPBaseNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
//        UHMyFileDetailController *_vc = [[UHMyFileDetailController alloc]init];
//        _vc.ID = dict[@"extraParam"];
//        [pushClassStance pushViewController:_vc animated:YES];
    }
    
}

- (void)monitorNotificationWithOptions:(NSDictionary *)launchOptions {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    //
    //    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    #ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey channel:@"app store" apsForProduction:NO];
    #else
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey channel:@"app store" apsForProduction:YES];
    #endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushMessageWithNoti:) name:EBBannerViewDidClickNotification object:nil];
    // 如果 launchOptions 不为空
    if (launchOptions) {
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
            //收到通知跳转
            NSDictionary * dict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            [self handlePushMessageWithDict:dict];
            if ([dict[@"messageType"] isEqualToString:@"BODY_CHECK_SYSTEM_NOTICE"]) {
                //        ZPNavigationController *_nav = (ZPNavigationController*) (self.window.rootViewController);
//                UHTabBarViewController *tabVC = (UHTabBarViewController *)self.window.rootViewController;
//                UHNavigationController *pushClassStance = (UHNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
//                UHMyFileDetailController *_vc = [[UHMyFileDetailController alloc]init];
//                _vc.ID = dict[@"extraParam"];
//                [pushClassStance pushViewController:_vc animated:YES];
            }
        }
    }
    
}

- (void)handlePushMessageWithNoti:(NSNotification *)noti {
    ZPLog(@"%@",noti.object);
    [self handlePushMessageWithDict:noti.object];
    
}

/*
 * 处理推送信息
 */
- (void)handlePushMessageWithDict:(NSDictionary *)dict {
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([dict objectForKey:@"msgAction"]) {
        NSInteger msgAction = [[dict objectForKey:@"msgAction"] integerValue];
        if (msgAction == ZPMsgActionTypeByOpenAppPage) {
            //打开APP指定页面
            ZPBaseTabBarViewController *tabVC = (ZPBaseTabBarViewController *)self.window.rootViewController;
            ZPNavigationController *pushClassStance = (ZPNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            
            NSInteger messageActionPage = [[dict objectForKey:@"messageActionPage"] integerValue];
            if (messageActionPage == ZPMsgActionOpenAppointedPageAssessmentType) {
                //心理测评
                
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageEvaluationType) {
                //生理测评
                
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageExaminationType) {
                //症状自查
                [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"selftest" parameters:nil progress:^(NSProgress *progress) {
                    
                } success:^(NSURLSessionDataTask *task, id response) {
                    if ([[response objectForKey:@"code"] integerValue]  == 200) {
                        NSBundle *bundle = [NSBundle bundleForClass:[DiseaseMatchViewController class]];
                        DiseaseMatchViewController *vc = [[DiseaseMatchViewController alloc] initWithNibName:@"DiseaseMatchViewController" bundle:bundle];
                        [pushClassStance pushViewController:vc animated:YES];
                    } else {
                        [MBProgressHUD showError:[response objectForKey:@"message"]];
                    }
                } failed:^(NSURLSessionDataTask *task, NSError *error) {
                    [MBProgressHUD showError:error.localizedDescription];
                } className:[pushClassStance class]];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageAdvisoryType) {
                //身心咨询
                ZPAdvisoryController *advisoryController = [[ZPAdvisoryController alloc] init];
                [pushClassStance pushViewController:advisoryController animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageLiveLectureType) {
                //直播讲堂
                ZPMoreLecturesController *alllectureControl = [[ZPMoreLecturesController alloc] init];
                alllectureControl.allLecture = YES;
                [pushClassStance pushViewController:alllectureControl animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageMyArchivesType) {
                //我的档案
                
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageHealthConsultationType) {
                //健康咨询
                ZPConsultDoctorController *consultDoctorController = [[ZPConsultDoctorController alloc] init];
                consultDoctorController.consultDoctorType = ZPConsultDoctorTypeHealthAdvisory;
                [pushClassStance pushViewController:consultDoctorController animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageMicroecologicalCenterType) {
                //微生态中心
                ZPAuthorityCenterController *authorityCenterControl = [[ZPAuthorityCenterController alloc] init];
                ZPAdvisoryChannelModel *model = [[ZPAdvisoryChannelModel alloc] init];;
                model.ID = @"1";
                ZPCommonEnumType *type = [[ZPCommonEnumType alloc] init];
                type.text = @"微生态中心";
                model.channelType = type;
                authorityCenterControl.channelModel = model;
                [pushClassStance pushViewController:authorityCenterControl animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageShppingMallType) {
                //优选商城
                ZPShopMallController *view2 = [[ZPShopMallController alloc] init];
                [pushClassStance pushViewController:view2 animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageNonPaymentType) {
                //待支付
                ZPMyOrderMainController *myOrderControl = [[ZPMyOrderMainController alloc] init];
                myOrderControl.index = 1;
                [pushClassStance pushViewController:myOrderControl animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageNonSendType) {
                //待发货
                ZPMyOrderMainController *myOrderControl = [[ZPMyOrderMainController alloc] init];
                myOrderControl.index = 2;
                [pushClassStance pushViewController:myOrderControl animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageNonReceieveType) {
                //待收货
                ZPMyOrderMainController *myOrderControl = [[ZPMyOrderMainController alloc] init];
                myOrderControl.index = 3;
                [pushClassStance pushViewController:myOrderControl animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageNonEvaluatedType) {
                //待评价
                ZPMyOrderMainController *myOrderControl = [[ZPMyOrderMainController alloc] init];
                myOrderControl.index = 4;
                [pushClassStance pushViewController:myOrderControl animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageWalkingType) {
                //健步走
                ZPMyStepsController *myStepsController = [[ZPMyStepsController alloc] init];
                [pushClassStance pushViewController:myStepsController animated:YES];
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageHealthSelftestType) {
                //健康自测
                //健康自测
                if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                    //               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([pushClassStance class]) object:nil];
                } else {
                    ZPRootWebViewController *testControl = [[ZPRootWebViewController alloc] init];
                    testControl.url = uhealthTestUrl;
                    testControl.titleString = @"健康自测";
                    testControl.initCloseBtn = YES;
                    [pushClassStance pushViewController:testControl animated:YES];
                }
            } else if (messageActionPage == ZPMsgActionOpenAppointedPageMyServiceType) {
                //我的服务
                
            }
        } else if (msgAction == ZPMsgActionTypeByOpenUrl) {
            //打开网页
            //            ZPNavigationController *_nav = (ZPNavigationController*) (self.window.rootViewController);
            ZPBaseTabBarViewController *tabVC = (ZPBaseTabBarViewController *)self.window.rootViewController;
            ZPNavigationController *pushClassStance = (ZPNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            
            NSInteger actionType = [[dict objectForKey:@"actionType"] integerValue];
            NSString *info = [dict objectForKey:@"info"];
            if (actionType == ZPActionTypeDirection) {
                //健康风向
                ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
                ZPHealthWindModel *windModel =  [[ZPHealthWindModel alloc] init];
                windModel.directionId = info;
                webView.url = windArticleUrl(info);
                webView.titleString = @"优医健康";
                webView.healthWindModel = windModel;
                webView.bannerAim = info;
                //设置文章类型
                webView.articelType = ZPArticleTypeWind;
                //从banner跳转来的
                webView.enterStatusType = ZPArticleEnterStatusTypeBanner;
                [pushClassStance pushViewController:webView animated:YES];
            } else if (actionType == ZPActionTypeInformation) {
                //健康资讯
                ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
                ZPHealthNewsModel *healthNewsModel = [[ZPHealthNewsModel alloc] init];
                healthNewsModel.informationId = info;;
                webView.healthNewsModel = healthNewsModel;
                webView.bannerAim = info;
                webView.url = newsArticleUrl(info);
                webView.titleString = @"健康资讯";
                //设置文章类型
                webView.articelType = ZPArticleTypeNews;
                //从banner跳转来的
                webView.enterStatusType = ZPArticleEnterStatusTypeBanner;
                [pushClassStance pushViewController:webView animated:YES];
            } else if (actionType == ZPActionTypeCommodity) {
                //商品
                ZPOrderDetailController *orderDetailControl = [[ZPOrderDetailController alloc] init];
                ZPCommodity *commodity = [[ZPCommodity alloc] init];
                commodity.commodityId = [info integerValue];
                orderDetailControl.commodity = commodity;
                orderDetailControl.enterStatusType = ZPOrderEnterStatusTypeBanner;
                [pushClassStance pushViewController:orderDetailControl animated:YES];
            } else if (actionType == ZPActionTypeLink) {
                //链接
                ZPRootWebViewController *_vc = [[ZPRootWebViewController alloc]init];
                _vc.url = info;
                [pushClassStance pushViewController:_vc animated:YES];
            } else if (actionType == ZPActionTypeLectureRoom) {
                //在线讲堂
                ZPLivingBroadcastFromBannerController *livinglectureControl = [[ZPLivingBroadcastFromBannerController alloc] init];
                livinglectureControl.ID = info;
                [pushClassStance pushViewController:livinglectureControl animated:YES];
            }
            
        } else {
            //默认打开App
        }
    }
}


+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    ZPLog(@"收到本地通知 %@",notification);
    // 可以让用户跳转到指定界面 app在前台接收到通知直接跳转界面不太好,所以要判断一下,是从后台进入前台还是本身就在前台
    if (application.applicationState == UIApplicationStateInactive) {// 进入前台时候
        ZPLog(@"跳转到指定界面");
       
        // 如果接收到不同的通知,跳转到不同的界面:
        ZPLog(@"%@", notification.userInfo); //通知的额外信息,根据设置的通知的额外信息确定
        
    } else if (application.applicationState == UIApplicationStateActive) {
       
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    NSString *alertStr = userInfo[@"aps"][@"alert"];
    if (alertStr != nil && ![alertStr isEqualToString:@""]) {
        //        [EBBannerView showWithContent:userInfo[@"aps"][@"alert"]];
       
    } else if (notification.request.content.body != nil) {
       
        
    }
    //         completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            ZPLog(@"支付宝支付结果result = %@",resultDic);
            if ([resultDic[@"result"] length]) {
                NSDictionary *returnDic = [self stringToDictionaryWithString:resultDic[@"result"]];
                ZPLog(@"解析结果 result = %@",returnDic);
                NSString *out_trade_no = returnDic[@"alipay_trade_app_pay_response"][@"out_trade_no"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAliPayResp object:out_trade_no];
            } else {
                ZPLog(@"解析结果是result = %@",resultDic[@"memo"]);
                [MBProgressHUD showError:resultDic[@"memo"]];
            }
            
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        //微信支付
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else if ([url.absoluteString containsString:@"wx"] && [url.host isEqualToString:@"oauth"]) {
        //微信登录
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return [[UMSocialManager defaultManager] handleOpenURL:url];;
    
}


- (NSDictionary *)stringToDictionaryWithString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = nil;
    
    if (!data) return nil;
    
    dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    
    return dict;
}

@end
