//
//  ZPGreenPathHospitalController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPHospitalModel;
@interface ZPGreenPathHospitalController : ZPRootViewController
@property (nonatomic,copy) NSString *cityServiceId;
@property (nonatomic,copy) void (^selHospitalBlock) (ZPHospitalModel *model);
//已经选择的model
//医院模型
@property (nonatomic,strong) ZPHospitalModel *hospitalModelSel;
@end

NS_ASSUME_NONNULL_END
