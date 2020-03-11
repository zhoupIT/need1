//
//  ZPCabinServiceModel.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCabinServiceModel.h"

@implementation ZPCabinServiceModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}
@end
