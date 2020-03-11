//
//  ZPCommodity.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPCommoditySpecificationsModel.h"
@interface ZPCommodity : NSObject
@property (nonatomic,assign) NSInteger commodityId;
/** 商品名称 */
@property (nonatomic,copy) NSString *name;
/** 商品类型，如实体商品，服务类商品，虚拟商品等等 */
@property (nonatomic,strong) ZPCommonEnumType *commoditytype;
/** 商品状态，上架，下架等等 */
@property (nonatomic,strong) ZPCommonEnumType *status;
/** 备注，用于介绍商品 */
@property (nonatomic,copy) NSString *note;
/** 原价（商品不做任何处理时的价格） */
@property (nonatomic,copy) NSString *originalPrice;
/** 成本价格 */
@property (nonatomic,copy) NSString *costPrice;
/** 当前价格 */
@property (nonatomic,copy) NSString *presentPrice;
/** 产品封面图的url，用于商品列表页，在购物车的展示 */
@property (nonatomic,copy) NSString *coverImage;
/** 价格名称(员工价 优选价) */
@property (nonatomic,copy) NSString *priceName;
/** 轮播图(商品中心轮播位置的附件) */
@property (nonatomic,strong) NSArray *commodityAttachmentsAtCenterPosition;
/** 详情图(商品详情位置的附件) */
@property (nonatomic,strong) NSArray *commodityAttachmentsAtCommodityParticularsPosition;
/** 属性组合 */
@property (nonatomic,strong) ZPCommoditySpecificationsModel *specifications;
/** 附加属性 */
@property (nonatomic,copy) NSString *extend1;
@end

