//
//  ZPArticleCommentModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPArticleCommentModel : NSObject
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *articleId;
@property (nonatomic,copy) NSString *articleType;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *commentContent;
@property (nonatomic,copy) NSString *commentTime;
@property (nonatomic,copy) NSString *customerPortrait;
@property (nonatomic,copy) NSString *customerName;
@property (nonatomic,copy) NSString *likeCounts;
@property (nonatomic,strong) ZPCommonEnumType *articleCommentLikeState;
//新增的评论需要将背景设置为灰色
@property (nonatomic,assign) BOOL isNewComment;
@end

NS_ASSUME_NONNULL_END
