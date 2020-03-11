//
//  ZPPrice.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPPriceModel : NSObject
@property (nonatomic,copy) NSString *totalPay;
@property (nonatomic,copy) NSString *discountMoney;
@property (nonatomic,copy) NSString *finalPay;
@end

NS_ASSUME_NONNULL_END
