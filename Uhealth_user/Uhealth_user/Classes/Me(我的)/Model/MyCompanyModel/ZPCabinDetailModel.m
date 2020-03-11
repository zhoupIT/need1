//
//  ZPCabinDetailModel.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCabinDetailModel.h"

@implementation ZPCabinDetailModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"nurseList" : @"ZPNurseModel",
             @"innerImgList":@"ZPInnerImgModel",
             @"cabinServiceList":@"ZPCabinServiceModel"
             };
}
@end
