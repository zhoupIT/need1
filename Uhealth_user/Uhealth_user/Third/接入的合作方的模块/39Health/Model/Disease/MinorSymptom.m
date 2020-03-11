//
//  MinorSymptom.m
//  YYK
//
//  Created by xiexianyu on 4/27/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "MinorSymptom.h"

@implementation MinorSymptom

- (instancetype)initWithInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        _name = [info valueForKey:@"Name"];
        _minorID = [info valueForKey:@"ID"];
        
        _didSelect = NO; // default unselected.
    }
    return self;
}

@end
