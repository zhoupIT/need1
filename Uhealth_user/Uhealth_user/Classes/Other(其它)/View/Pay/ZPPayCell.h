//
//  ZPPayCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPayModel;
@interface ZPPayCell : UITableViewCell
@property (nonatomic,copy) void (^selBlock) (UIButton *btn);
@property (nonatomic,strong) ZPPayModel *model;
@end
