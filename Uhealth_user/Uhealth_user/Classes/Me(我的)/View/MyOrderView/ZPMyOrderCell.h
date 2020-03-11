//
//  ZPMyOrderCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPOrderModel;
@interface ZPMyOrderCell : UITableViewCell
@property (nonatomic,strong) ZPOrderModel *model;
@property (nonatomic,copy) void (^payActionBlock) (UIButton *btn);
@property (nonatomic,copy) void (^deleteActionBlock) (UIButton *btn);
@property (nonatomic,copy) void (^didSelectBlock) (void);
@end
