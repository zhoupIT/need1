//
//  ZPPatientListCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPatientListModel;
@interface ZPPatientListCell : UITableViewCell
@property (nonatomic,strong) ZPPatientListModel *model;
@property (nonatomic,copy) void (^selctActionBlock) (UIButton *btn);

@property (nonatomic,copy) void (^editBlock) (UIButton *btn);
@end
