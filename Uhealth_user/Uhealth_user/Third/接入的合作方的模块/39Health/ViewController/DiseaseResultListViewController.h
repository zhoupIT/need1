//
//  DiseaseResultListViewController.h
//  YYK
//
//  Created by xiexianyu on 4/27/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISBaseListViewController.h"

@interface DiseaseResultListViewController : QISBaseListViewController

@property (nonatomic, strong) NSDictionary *majorInfo;
@property (nonatomic, strong) NSDictionary *ageInfo;
@property (nonatomic, strong) NSDictionary *workInfo;
@property (nonatomic, assign) BOOL isFemale;
@property (nonatomic, copy) NSString *symptomAllIDText;

@end
