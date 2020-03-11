//
//  ZPRootArticleWebViewController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPRootWebViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class ZPHealthNewsModel,ZPHealthWindModel;
@interface ZPRootArticleWebViewController : ZPRootWebViewController
//文章入口枚举
@property (nonatomic,assign) ZPArticleEnterStatusType enterStatusType;
//文章类型
@property (nonatomic,assign) ZPArticleType articelType;
//如果是从banner跳转来的,会带有一个bannerAim 文章的url地址
@property (nonatomic,copy) NSString *bannerAim;
@property (nonatomic,assign) NSInteger pageIndex;
//@property (nonatomic,copy) NSString *mainBody;;
/** 文章 资讯 */
@property (nonatomic,strong) ZPHealthNewsModel *healthNewsModel;
/** 文章 风向 */
@property (nonatomic,strong) ZPHealthWindModel *healthWindModel;
@end

NS_ASSUME_NONNULL_END
