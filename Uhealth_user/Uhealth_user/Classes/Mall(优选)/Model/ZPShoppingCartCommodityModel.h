//
//  ZPCarCommodity.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZPCommodity;
@interface ZPShoppingCartCommodityModel : NSObject
/** 商品 */
@property (nonatomic,strong) ZPCommodity *commodity;
/** 购物车id */
@property (nonatomic,copy) NSString *itemId;
/** 客户id */
@property (nonatomic,copy) NSString *customerId;
/** 商品数量 */
@property (nonatomic,copy) NSString *commodityCount;
/** 规格的编号(用户加入购物车的该商品规格，只会有一项) */
@property (nonatomic,copy) NSString *commoditySpecificationNo;
/** 前端用来标识 模型是否被选中的状态 */
@property (nonatomic,assign) BOOL isSel;
@end
