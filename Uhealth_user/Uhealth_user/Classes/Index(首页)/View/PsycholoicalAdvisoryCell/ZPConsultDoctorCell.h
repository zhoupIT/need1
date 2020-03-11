//
//  ZPConsultDoctorCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPConsultDoctorModel;
@interface ZPConsultDoctorCell : UITableViewCell
@property (nonatomic,strong) ZPConsultDoctorModel *model;
/* 咨询回调 */
@property (nonatomic,copy) void (^consultBlock) (void);
/* 弹出个人信息的回调 */
@property (nonatomic,copy) void (^modalInfoBlock) (ZPConsultDoctorModel *model);
/* 0心理咨询 1健康咨询 */
@property (nonatomic,assign) ZPConsultDoctorType *consultDoctorType;
@end

NS_ASSUME_NONNULL_END
