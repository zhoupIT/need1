//
//  DiseaseSymptomViewControll.h
//  YYK
//
//  Created by xiexianyu on 5/18/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISBaseViewController.h"

@interface DiseaseSymptomViewControll : QISBaseViewController

@property (nonatomic, assign) BOOL isFemale; // male or female
// age, work
@property (nonatomic, strong) NSDictionary *ageInfo;
@property (nonatomic, strong) NSDictionary *workInfo;


- (void)fetchMinorSymptomListWithMajorInfo:(NSDictionary*)majorInfo;

@end
