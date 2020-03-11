//
//  ZPMyOrderSubCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPOrderItemModel;
@interface ZPMyOrderSubCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@property (nonatomic,strong) ZPOrderItemModel *model;
@end
