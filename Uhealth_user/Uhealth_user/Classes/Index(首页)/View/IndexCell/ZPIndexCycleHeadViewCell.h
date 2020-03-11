//
//  ZPIndexCycleHeadViewCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPIndexCycleHeadViewCell : UITableViewCell
/** 首页轮播图的数据 */
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy) void (^bannerImgClickBlock) (NSInteger index);
@end

NS_ASSUME_NONNULL_END
