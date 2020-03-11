//
//  ZPMyPatientListCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPPatientListModel;
@interface ZPMyPatientListCell : UITableViewCell
@property (nonatomic,strong) ZPPatientListModel *model;
@property (nonatomic,copy) void (^selctActionBlock) (UIButton *btn);

@property (nonatomic,copy) void (^editBlock) (UIButton *btn);
@end

NS_ASSUME_NONNULL_END
