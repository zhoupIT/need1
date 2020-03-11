//
//  ZPCommoditySpecificationsModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPCommoditySpecificationsModel : NSObject
@property (nonatomic,copy) NSString *commodityId;
@property (nonatomic,strong) NSArray *specifications;
@property (nonatomic,strong) NSArray *commodityItem;
/** 该商品是否有默认规格 有默认规格的直接下单   */
@property (nonatomic,assign) BOOL hasDefaultOption;
@end

NS_ASSUME_NONNULL_END
