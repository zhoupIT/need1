//
//  ZPCheckOutSubTitleCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPCheckOutModel;
@interface ZPCheckOutSubTitleCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) ZPCheckOutModel *model;
@property (nonatomic,copy) NSString *subtitleStr;
@property (nonatomic,copy) NSString *titleStr;
@end
