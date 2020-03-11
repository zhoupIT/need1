//
//  ZPOrderModel.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPOrderModel.h"

@implementation ZPOrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"needInvoice":@"needInvoice.text"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"orderItems" : @"ZPOrderItemModel"
             };
}
@end
