//
//  ZPMacroDefine.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#ifndef ZPMacroDefine_h
#define ZPMacroDefine_h

#pragma mark - ——————— 服务器地址 ————————
//#define ZPBaseUrl @"http://121.43.168.51" //外
#define ZPBaseUrl @"https://app.uhealth-online.com.cn" //正式
//#define ZPBaseUrl @"http://192.168.8.12:8000" //许
//#define ZPBaseUrl @"http://192.168.8.10:8100" //韩
//#define ZPBaseUrl @"http://192.168.8.18:8000" //孙
//#define ZPBaseUrl @"http://192.168.8.20" //测试服务器

#pragma mark - ——————— 三方服务的key ————————
/* 极光appkey */
#define JpushAppKey @"020619a320d62b12d31d7038"
/* 微信appkey */
#define WXPayKey @"wx89bfbe26609a6b54"
/* UM key */
#define UMKey @"5acc5464f29d9865be000246"
#define UMAppSecret @"55816a116999881f02c4a94fea7cccb6"
/* bugly  */
#define BuglyAppId @"61943ea09a"

/* 用户的信息的保存地址 */
#define ZPUserInfoPATH [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/user.data"]]

#pragma mark - ——————— 系统相关 ————————
/* 获取屏幕 宽度、高度 */
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/* 获取安全高度 */
#define kSafeAreaTopHeight (kSCREEN_HEIGHT == 812.0 ? 88 : 64)
#define kSafeAreaBottomHeight (kSCREEN_HEIGHT == 812.0 ? 34 : 0)

/* 机型 */
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (([[UIScreen mainScreen] bounds].size.height == 667) ? YES : NO)
#define IS_IPhone6P (([[UIScreen mainScreen] bounds].size.height == 736) ? YES : NO)
#define IS_IPhoneX (([[UIScreen mainScreen] bounds].size.height == 812) ? YES : NO)

/* 适配高度 宽度 */
#define ZPWidthScale (kSCREEN_WIDTH / 375)
#define ZPHeightScale ((IS_IPhoneX ? 667 : kSCREEN_HEIGHT) / 667)
#define ZPHeight(H) ((H) * ZPHeightScale)
#define ZPWidth(W) ((W) * ZPWidthScale)

/* 字体 */
#define ZPPFSCRegular @"PingFangSC-Regular"
#define ZPPFSCMedium @"PingFangSC-Medium"
#define ZPPFSCLight @"PingFangSC-Light"

/* 字体大小 */
#define ZPFont(x) [UIFont systemFontOfSize:(x) * ZPHeightScale]
#define ZPFontSize(x) (x) * ZPHeightScale

/* 获取RGB颜色 */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

/* NSUserDefaults实例化 */
#define kUSER_DEFAULT [NSUserDefaults standardUserDefaults]

/* weakSelf strongSelf reference */
#define WEAK_SELF(weakSelf) __weak __typeof(&*self) weakSelf = self;
#define STRONG_SELF(strongSelf) __strong __typeof(&*weakSelf) strongSelf = weakSelf;

/* 计算当前文本的高度 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MULTILINE_TEXTSIZE(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MULTILINE_TEXTSIZE(text,font,maxSize) [text length] > 0 ? [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping] : CGSizeZero;
#endif

/* 版本号 */
#define PRODUCT_VERSION     [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

/* 400客服号码 */
#define hotLineNumber @"400-656-0320"

/* 优医家APP Apple商店链接 */
#define AppStoreUrl @"https://itunes.apple.com/cn/app/id1442776970?mt=8"

/* 长图Url地址 */
#define urlLongImage(ID) [NSString stringWithFormat:@"%@/ios/html/index.html?type=HUTDETAIL&imgUrl=%@",ZPBaseUrl,ID]

/* 绿通长图介绍 */
#define greenIntroduceImage [NSString stringWithFormat:@"%@/ios/html/index.html?img=INTRODUCE",ZPBaseUrl]

/* 绿通服务细则 */
#define greenRuleImage [NSString stringWithFormat:@"%@/ios/html/index.html?img=rule",ZPBaseUrl]

/* 资讯Url地址 */
#define newsArticleUrl(ID) [NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,ID]

/* 风向Url地址 */
#define windArticleUrl(ID) [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,ID]

/* 商品详情Url地址 */
#define orderDetailUrl(ID) [NSString stringWithFormat:@"%@/ios/html/index.html?id=%ld&type=RODUCTDETAIL",ZPBaseUrl,ID]

/* 小屋Url地址 */
#define cabinUrl(urlString) [NSString stringWithFormat:@"%@/ios/html/index.html?type=HUTDETAIL&imgUrl=%@",ZPBaseUrl,urlString]

/* 健康自测 */
#define uhealthTestUrl @"https://wapyyk.39.net/page/html5/quest/questlist_uhealth.jsp"

#pragma mark - NotificationName
#define kNotificationSmokeSel @"kNotificationSmokeSel"
#define kNotificationDrinkSel @"kNotificationDrinkSel"
#define kNotificationSmokeResult @"kNotificationSmokeResult"
#define kNotificationDrinkResult @"kNotificationDrinkResult"

#define kNotificationSendResult @"kNotificationSendResult"
#define KNotificationTimeOut @"KNotificationTimeOut"
#define KNotificationTimeEnd @"KNotificationTimeEnd"

#define kNotificationNeedSignIn @"kNotificationNeedSignIn"
#define kNotificationWXResp @"kNotificationWXResp"
#define kNotificationAliPayResp @"kNotificationAliPayResp"
#define kNotificationLoginSuccess @"kNotificationLoginSuccess"
#define kNotificationLogoutSuccess @"kNotificationLogoutSuccess"
#define kNotificationWXLoginSuccess @"kNotificationWXLoginSuccess"

#endif /* ZPMacroDefine_h */
