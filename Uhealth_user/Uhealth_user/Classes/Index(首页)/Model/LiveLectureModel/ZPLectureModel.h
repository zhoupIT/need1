//
//  ZPLectureModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPLectureModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *doctorId;
@property (nonatomic,copy) NSString *lectureName;
@property (nonatomic,copy) NSString *lectureImg;
@property (nonatomic,copy) NSString *lectureDate;
@property (nonatomic,copy) NSString *roomid;
@property (nonatomic,strong) ZPCommonEnumType *lectureStatus;
@property (nonatomic,strong) NSString *lectureSpeaker;
@property (nonatomic,copy) NSString *lectureDoctorIntroduction;
@property (nonatomic,copy) NSString *lectureIntroduction;
@property (nonatomic,strong) NSArray *lectureIntroductionImg;
@property (nonatomic,assign) NSInteger timeout;
//是否预约
@property (nonatomic,assign) BOOL hasSubscribed;
//是否从banner进来
@property (nonatomic,assign) BOOL isBannerEnter;
@end
