//
//  ZPCheckOutHeaderCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPAddressModel;
@interface ZPCheckOutHeaderCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZPAddressModel *model;
@end
