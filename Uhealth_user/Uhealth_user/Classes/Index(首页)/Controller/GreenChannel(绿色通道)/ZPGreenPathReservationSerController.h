//
//  ZPGreenPathReservationSerController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ZPMedicalCityServiceModel;
@interface ZPGreenPathReservationSerController : ZPRootViewController
/* 城市id */
@property (nonatomic,copy) NSString *cityID;
/* 选择回调 */
@property (nonatomic,copy) void (^selectedServiceBlock) (ZPMedicalCityServiceModel *model);
/* 选中的城市服务 */
@property (nonatomic,strong) ZPMedicalCityServiceModel *serviceModelSel;
@end

NS_ASSUME_NONNULL_END
