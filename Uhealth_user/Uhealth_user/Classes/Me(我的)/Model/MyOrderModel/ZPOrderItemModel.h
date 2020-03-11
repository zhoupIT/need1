//
//  ZPOrderItemModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPOrderItemModel : NSObject
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *commodityId;
@property (nonatomic,copy) NSString *number;
@property (nonatomic,copy) NSString *commodityStatus;
@property (nonatomic,copy) NSString *commodityName;
@property (nonatomic,copy) NSString *commoditySpecificationInfo;
@property (nonatomic,copy) NSString *costUnitPrice;
@property (nonatomic,copy) NSString *presentUnitPrice;
@property (nonatomic,copy) NSString *subtotal;
@property (nonatomic,copy) NSString *imageUrl;
@end
