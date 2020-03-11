//
//  ZPSettlementModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2019/2/19.
//  Copyright © 2019年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPSettlementModel : NSObject
/** 配送方式 */
@property (nonatomic,copy) NSString *logisticsMode;
/** 商品合计 */
@property (nonatomic,copy) NSString *originProductAmountTotal;
/** 优惠金额 */
@property (nonatomic,copy) NSString *reducedPrice;
/** 运费 */
@property (nonatomic,copy) NSString *logisticsFee;
/** 应付 */
@property (nonatomic,copy) NSString *amountPayable;
@end

NS_ASSUME_NONNULL_END
