//
//  ZPUMShare.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUMShare.h"
/* 第三方 */
#import <UShareUI/UShareUI.h>
@implementation ZPUMShare
+ (void)shareWithTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(NSString *)thumImageUrl withMainUrl:(NSString *)mainUrl withController:(nonnull UIViewController *)controller{
    WEAK_SELF(weakSelf);
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf runShareWithType:platformType WithTitle:title withDescr:descr withThumImage:thumImageUrl withMainUrl:mainUrl withController:controller];
    }];
}

+ (void)runShareWithType:(UMSocialPlatformType)platformType WithTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(NSString *)thumImageUrl withMainUrl:(NSString *)mainUrl withController:(UIViewController *)controller
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImageUrl];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",mainUrl,@"&isShow=true"];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            ZPLog(@"************Share fail with error %@*********",error);
            [MBProgressHUD showError:@"分享失败"];
        }else{
            ZPLog(@"response data is %@",data);
            [MBProgressHUD showSuccess:@"分享成功"];
        }
    }];
}
@end
