//
//  DiseaseMinorListViewController.h
//  YYK
//
//  Created by xiexianyu on 4/24/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISBaseListViewController.h"

@interface DiseaseMinorListViewController : QISBaseListViewController

@property (nonatomic, strong) NSDictionary *majorInfo;
@property (nonatomic, strong) NSDictionary *ageInfo;
@property (nonatomic, strong) NSDictionary *workInfo;
@property (nonatomic, assign) BOOL isFemale;

@end
