//
//  MinorSymptom.h
//  YYK
//
//  Created by xiexianyu on 4/27/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinorSymptom : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *minorID;
// for check state
@property (nonatomic, assign) BOOL didSelect;

- (instancetype)initWithInfo:(NSDictionary*)info;

@end
