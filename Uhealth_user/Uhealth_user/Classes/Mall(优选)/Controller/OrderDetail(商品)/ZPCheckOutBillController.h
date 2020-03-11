//
//  ZPCheckOutBillController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPCommodityItemModel.h"
#import "ZPSettlementModel.h"
@interface ZPCheckOutBillController : ZPRootViewController
@property (nonatomic,strong) NSArray *orderArray;
/*  1.从购物车 2.从商品详情 进入确认订单页面 */
@property (nonatomic,assign) ZPCheckOutBillType enterBillType;
/** 从购物车进入后传递的模型(包含价格 配送方式) */
@property (nonatomic,strong) ZPSettlementModel *cartSettlementModel;
/** 从立即购买进入后传递的模型(包含价格 配送方式) */
@property (nonatomic,strong) ZPSettlementModel *settlementModel;
@property (nonatomic,copy) void (^emptyCartBlock) (void);
/* 该商品是否有默认规格 有默认规格的直接下单 使用商品属性  没有默认规格的得选规格 */
@property (nonatomic,assign) BOOL hasDefaultOption;
/* 商品属性 */
@property (nonatomic,strong) ZPCommodityItemModel *commodityItemModel;

@end
