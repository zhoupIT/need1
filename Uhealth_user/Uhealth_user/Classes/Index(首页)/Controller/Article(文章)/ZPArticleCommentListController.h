//
//  ZPArticleCommentListController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPHealthNewsModel,ZPHealthWindModel;
@interface ZPArticleCommentListController : ZPRootViewController
@property (nonatomic,strong) ZPHealthWindModel *healthWindModel;
@property (nonatomic,strong) ZPHealthNewsModel *healthNewsModel;
/* 文章类型:资讯、风向 */
@property (nonatomic,assign) ZPArticleType articleType;
/* 文章打开来源 banner 通知 正常 */
@property (nonatomic,assign) ZPArticleEnterStatusType enterStatusType;
/* 文章的ID */
@property (nonatomic,copy) NSString *bannerAim;
@end

NS_ASSUME_NONNULL_END
