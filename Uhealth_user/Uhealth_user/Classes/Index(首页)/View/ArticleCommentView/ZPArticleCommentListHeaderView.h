//
//  ZPArticleCommentListHeaderView.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPHealthWindModel,ZPHealthNewsModel;
@interface ZPArticleCommentListHeaderView : UIView
@property (nonatomic,strong) ZPHealthWindModel *model;
@property (nonatomic,strong) ZPHealthNewsModel *healthNewsModel;
/* 更新高度的回调 */
@property (nonatomic , copy ) void (^updateHeightBlock)(ZPArticleCommentListHeaderView *view);
@property (nonatomic,copy) void (^popBlock) (UIButton *btn);
@end

NS_ASSUME_NONNULL_END
