//
//  MajorSymptom.m
//  YYK
//
//  Created by xiexianyu on 4/28/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "MajorSymptom.h"

@implementation MajorSymptom

- (instancetype)initWithInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        _name = [info valueForKey:@"name"];
        _param = [info valueForKey:@"param"];
        
        _didSelect = NO; // default unselected.
        _results = nil;
    }
    return self;
}

@end
