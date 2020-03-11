//
//  ZPUMShare.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPUMShare : NSObject
/** 调用UM分享 标题 描述 缩略图 文章详情地址 */
+ (void)shareWithTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(NSString *)thumImageUrl withMainUrl:(NSString *)mainUrl withController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
