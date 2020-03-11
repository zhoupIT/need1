//
//  ZPChannelDoctor.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPChannelDoctorModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *channelId;
@property (nonatomic,copy) NSString *doctorName;
@property (nonatomic,copy) NSString *doctorHeadimg;
@property (nonatomic,copy) NSString *doctorTitle;
@property (nonatomic,copy) NSString *doctorIntroduction;
@property (nonatomic,copy) NSString *doctorField;
@property (nonatomic,assign) NSInteger lectureCount;
@property (nonatomic,strong) ZPCommonEnumType *lectureStatus;
@property (nonatomic,copy) NSString *doctorIntroductionBr;
//行数 来判断是简介/领域
@property (nonatomic,assign) NSInteger index;
@end
