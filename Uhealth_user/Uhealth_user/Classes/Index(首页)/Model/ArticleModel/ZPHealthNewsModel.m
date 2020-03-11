//
//  ZPHealthNewsModel.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHealthNewsModel.h"

@implementation ZPHealthNewsModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"toatalCommentsCount"]) {
        if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]]){
            oldValue = @"0";
        }
    }
    return oldValue;
}
@end
