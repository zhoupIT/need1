//
//  ZPArticleCommentListCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPArticleCommentModel;
@interface ZPArticleCommentListCell : UITableViewCell
@property (nonatomic,strong) ZPArticleCommentModel *model;
/* 点赞回调 */
@property (nonatomic,copy) void (^likeBlock) (UIButton *btn);
@end

NS_ASSUME_NONNULL_END
