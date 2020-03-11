//
//  ZPOrderModel.h
//  ZPealth 订单模型
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPOrderModel : NSObject
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *serialNumber;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *commodityCount;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *recipientsName;
@property (nonatomic,copy) NSString *recipientsTelephone;
@property (nonatomic,strong) ZPCommonEnumType *orderStatus;
@property (nonatomic,strong) ZPCommonEnumType *orderType;
@property (nonatomic,strong) ZPCommonEnumType *payMethod;
@property (nonatomic,copy) NSString *outTradeNo;
@property (nonatomic,copy) NSString *payTime;
@property (nonatomic,copy) NSString *reducedId;
//优惠的价格
@property (nonatomic,copy) NSString *reducedPrice;
//商品原来总价
@property (nonatomic,copy) NSString *originProductAmountTotal;
//订单实际总价
@property (nonatomic,copy) NSString *actualProductAmountTotal;
//运费，暂时没有相关计算标准，暂时统一为0
@property (nonatomic,copy) NSString *logisticsFee;
//订单总价（（实际应付，商品总价加上运费））
@property (nonatomic,copy) NSString *orderAmountTotal;
@property (nonatomic,copy) NSString *point;
@property (nonatomic,copy) NSString *needInvoice;
@property (nonatomic,copy) NSString *invoiceNo;
@property (nonatomic,copy) NSString *orderlogisticsId;
@property (nonatomic,copy) NSString *deliveryTime;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,strong) NSArray *orderItems;
@property (nonatomic,copy) NSString *createDate;
@end
