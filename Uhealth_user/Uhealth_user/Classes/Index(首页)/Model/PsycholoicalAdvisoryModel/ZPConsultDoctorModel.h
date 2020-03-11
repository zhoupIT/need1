//
//  ZPConsultDoctorModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPConsultDoctorModel : NSObject
@property (nonatomic,copy) NSString *doctorId;
/**
 * 医生类型。心理医生or生理医生
 */

@property (nonatomic,strong) ZPCommonEnumType *doctorType;
/**
 * 医生职称
 */

@property (nonatomic,copy) NSString *doctorTitle;
/**
 * 医生姓名
 */

@property (nonatomic,copy) NSString *name;
/**
 * 性别
 */

@property (nonatomic,strong) ZPCommonEnumType *gender;
/**
 * 医生头像
 */

@property (nonatomic,copy) NSString *headPortrait;
/**
 * 医生简介
 */

@property (nonatomic,copy) NSString *introduction;
/**
 * 医生图文通话唯一标识
 */

@property (nonatomic,copy) NSString *accId;
/**
 * 专业知识领域。内科or外科or全科
 */

@property (nonatomic,copy) NSString *expertiseField;
/**
 * 简单的擅长领域的介绍
 */

@property (nonatomic,copy) NSString *researchDirectionSynopsis;
/**
 * 擅长方向，研究方向
 */

@property (nonatomic,copy) NSString *researchDirection;

@property (nonatomic,strong) NSArray *researchDirectionControlArray;
@end

NS_ASSUME_NONNULL_END
