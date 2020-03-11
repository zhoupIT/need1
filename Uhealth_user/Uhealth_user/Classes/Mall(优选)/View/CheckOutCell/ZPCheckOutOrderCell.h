//
//  ZPCheckOutOrderCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPShoppingCartCommodityModel,ZPOrderItemModel,ZPCommodity,ZPCommodityItemModel;
@interface ZPCheckOutOrderCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZPShoppingCartCommodityModel *model;
@property (nonatomic,strong) ZPOrderItemModel *itemModel;
@property (nonatomic,strong) ZPCommodity *commodityModel;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *orginTotal;
@property (nonatomic,copy) NSString *total;
/* 选择的属性模型 */
@property (nonatomic,strong) ZPCommodityItemModel *commodityItemModel;
@end
