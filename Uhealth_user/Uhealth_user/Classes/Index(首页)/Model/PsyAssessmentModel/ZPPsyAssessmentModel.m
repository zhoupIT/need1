//
//  ZPPsyAssessmentModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsyAssessmentModel.h"

@implementation ZPPsyAssessmentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"companyCode"] && (oldValue == nil || [oldValue isKindOfClass:[NSNull class]]))
        oldValue = @"";
    return oldValue;
}
@end
