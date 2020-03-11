//
//  ZPReservationCityListCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPReservationCityModel,ZPCityServicesModel;
@interface ZPReservationCityListCell : UITableViewCell
@property (nonatomic,strong) ZPReservationCityModel *model;
@property (nonatomic,strong) ZPCityServicesModel *servicesModel;
@property (nonatomic,copy) void (^didClickBlock) (UIButton *btn);
@end

NS_ASSUME_NONNULL_END
