//
//  ZPCommodityItemModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPCommodityItemModel : NSObject
/** 属性 */
@property (nonatomic,strong) NSDictionary *attached;
/** 此属性的id */
@property (nonatomic,copy) NSString *number;
/** 商品预览 */
@property (nonatomic,copy) NSString *img;
/** 库存 */
@property (nonatomic,copy) NSString *stock;
/** 价格 */
@property (nonatomic,copy) NSString *price;
/** 原价 */
@property (nonatomic,copy) NSString *originalPrice;
/** 现价 */
@property (nonatomic,copy) NSString *presentPrice;
@end

NS_ASSUME_NONNULL_END
