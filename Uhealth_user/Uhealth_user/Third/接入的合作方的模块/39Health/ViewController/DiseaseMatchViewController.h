//
//  DiseaseMatchViewController.h
//  YYK
//
//  Created by xiexianyu on 4/22/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseSymptomViewControll.h"

@interface DiseaseMatchViewController : DiseaseSymptomViewControll

// not show body UI, only list.
@property (nonatomic, assign) BOOL isListOnly;
@property (nonatomic, copy) NSString *bodyName; // selected body name

@end
