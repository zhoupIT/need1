//
//  ZPUserModel.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserModel.h"

@implementation ZPUserModel
MJCodingImplementation
/**
 如果属性是系统的关键字,那就重写方法, 将属性名换为其他key去字典中取值
 @return 字典中的key是属性名，value是从字典中取值用的key
 */
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
