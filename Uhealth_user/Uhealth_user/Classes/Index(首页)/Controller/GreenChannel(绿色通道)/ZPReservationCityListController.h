//
//  ZPReservationCityListController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ZPReservationCityModel,ZPCityServicesModel;
@interface ZPReservationCityListController : ZPRootViewController
@property (nonatomic,copy) void (^selectedCityBlock) (ZPReservationCityModel *model);
@property (nonatomic,copy) void (^selectedServiceBlock) (ZPCityServicesModel *model);
/* 判断当前是选择城市还是选择服务 */
@property (nonatomic,assign) ZPGreenChannelSelEnterStatusType type;

@property (nonatomic,copy) NSString *ID;


/* 已经选择的model */
//城市模型
@property (nonatomic,strong) ZPReservationCityModel *cityModelSel;
//服务模型
@property (nonatomic,strong) ZPCityServicesModel *serviceModelSel;
@end

NS_ASSUME_NONNULL_END
