//
//  ZPConsultDoctorController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPConsultDoctorController : ZPRootViewController
/* 0心理咨询 1健康咨询 */
@property (nonatomic,assign) ZPConsultDoctorType *consultDoctorType;
@end

NS_ASSUME_NONNULL_END
