//
//  ZPMedicalCityServiceModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPMedicalCityServiceModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *medicalCityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *medicalServiceId;
@property (nonatomic,copy) NSString *serviceTypeName;
@property (nonatomic,strong) ZPImg *serviceTypeInformationImg;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,strong) ZPCommonEnumType *serviceStatus;
@property (nonatomic,assign) BOOL isSel;//是否被选中
@property (nonatomic,assign) BOOL isExpand;//是否被展开
@end

NS_ASSUME_NONNULL_END
