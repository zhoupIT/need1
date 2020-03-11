//
//  ZPCommoditySpecificationsModel.m
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCommoditySpecificationsModel.h"

@implementation ZPCommoditySpecificationsModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"specifications" : @"ZPSpecificationsModel",
             @"commodityItem":@"ZPCommodityItemModel"
             };
}
@end
