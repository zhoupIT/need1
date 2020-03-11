//
//  ZPCityServicesModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPCityServicesModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *medicalCityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *medicalServiceId;
@property (nonatomic,copy) NSString *serviceTypeName;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *serviceStatus;
@property (nonatomic,assign) BOOL isSel;
@end

NS_ASSUME_NONNULL_END
