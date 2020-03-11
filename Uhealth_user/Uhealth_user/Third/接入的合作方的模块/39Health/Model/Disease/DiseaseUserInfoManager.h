//
//  DiseaseUserInfoManager.h
//  YYK
//
//  Created by xiexianyu on 5/15/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiseaseUserInfoManager : NSObject

@property (nonatomic, assign, setter=setFemale:) BOOL isFemale; // male or female
@property (nonatomic, strong) NSDictionary *workInfo;
@property (nonatomic, strong) NSDictionary *ageInfo;

@end
