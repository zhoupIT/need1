//
//  ZPReservationCheckOutController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZPReservationCityModel.h"
#import "ZPCityServicesModel.h"
#import "ZPPatientListModel.h"
#import "ZPHospitalModel.h"
#import "ZPMedicalCityServiceModel.h"
@interface ZPReservationCheckOutController : UIViewController


//就医城市 模型
@property (nonatomic,strong) ZPReservationCityModel *cityModel;
//服务类型 模型
@property (nonatomic,strong) ZPMedicalCityServiceModel *serviceModel;
//就医人 模型
@property (nonatomic,strong) ZPPatientListModel *patientModel;
//医院 模型
@property (nonatomic,strong) ZPHospitalModel *hospitalModel;

@property (nonatomic,copy) NSString *phoneValue;

@property (nonatomic,copy) NSString *noti;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *type;
//合计
@property (nonatomic,copy) NSString *originProductAmountTotal;
//优惠金额
@property (nonatomic,copy) NSString *reducedPrice;
//实付款
@property (nonatomic,copy) NSString *orderAmountTotal;
//运费
@property (nonatomic,copy) NSString *logisticsFee;
@end
