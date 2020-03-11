//
//  MajorSymptom.h
//  YYK
//
//  Created by xiexianyu on 4/28/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MajorSymptom : NSObject

// body part name
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *param;
// for check state
@property (nonatomic, assign) BOOL didSelect;
// result list of fetch request
@property (nonatomic, strong) NSArray *results;

- (instancetype)initWithInfo:(NSDictionary*)info;

@end
