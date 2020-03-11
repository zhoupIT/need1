//
//  ZPGreenPathReservationSerCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPMedicalCityServiceModel;
@interface ZPGreenPathReservationSerCell : UITableViewCell
@property (nonatomic,strong) ZPMedicalCityServiceModel *model;
//选中服务
@property (nonatomic,copy) void (^selServiceBlock) (BOOL sel);
@end

NS_ASSUME_NONNULL_END
