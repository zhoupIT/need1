//
//  HealthKitManage.h
//  healthkit
//
//  Created by Biao Geng on 2018/9/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIDevice.h>

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

NS_ASSUME_NONNULL_BEGIN

@interface HealthKitManage : NSObject
@property (nonatomic,strong) HKHealthStore *healthStore;
+(id)shareInstance;
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;
- (void)getStepCountWithDateString:(NSString *)dateString complete:(void(^)(double value, NSError *error))completion;
- (void)getDistance:(void(^)(double value, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
