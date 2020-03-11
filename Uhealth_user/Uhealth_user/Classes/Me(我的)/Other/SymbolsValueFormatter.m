//
//  SymbolsValueFormatter.m
//  ChartsDemo-iOS
//
//  Created by Biao Geng on 2018/11/22.
//  Copyright © 2018年 dcg. All rights reserved.
//

#import "SymbolsValueFormatter.h"

@implementation SymbolsValueFormatter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;}
-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSString *s = @"";
    NSInteger i = (NSInteger)value;
    switch (i) {
        case 0:
            s = @"周一";
            break;
        case 1:
            s = @"周二";
            break;
        case 2:
            s = @"周三";
            break;
        case 3:
            s = @"周四";
            break;
        case 4:
            s = @"周五";
            break;
        case 5:
            s = @"周六";
            break;
        case 6:
            s = @"周日";
            break;
        default:
            break;
    }
    return s;
}//IChartAxisValueFormatter的代理方法
@end
