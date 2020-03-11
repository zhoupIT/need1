//
//  ZPHistoryStepsCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHistoryStepsCell.h"
#import "iOS-Echarts.h"
#import "PYEchartsView.h"
#import "PYZoomEchartsView.h"
@interface ZPHistoryStepsCell()
{
    UILabel *_label;
    
}
@property (nonatomic, strong) PYZoomEchartsView *kEchartView;
@end
@implementation ZPHistoryStepsCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = RGB(246,251,255);
    self.kEchartView = [PYZoomEchartsView new];
    [self.contentView addSubview:self.kEchartView];
    self.kEchartView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
    [self.kEchartView setOption:[self standardLineOption]];
    [self.kEchartView loadEcharts];
}

- (PYOption *)standardLineOption {
    /*
     return [PYOption initPYOptionWithBlock:^(PYOption *option) {
     option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
     title.showEqual(NO);
     }])
     .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
     tooltip.triggerEqual(PYTooltipTriggerAxis);
     tooltip.axisPointerEqual([PYAxisPointer initPYAxisPointerWithBlock:^(PYAxisPointer *axisPoint) {
     axisPoint.typeEqual(PYAxisPointerTypeNone);
     }]);
     }])
     .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
     grid.xEqual(@10).x2Equal(@10);
     grid.borderWidthEqual(@0);
     }])
     .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
     axis.typeEqual(PYAxisTypeCategory)
     .boundaryGapEqual(@YES)
     .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
     axisLine.showEqual(NO);
     axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
     lineStyle.colorEqual([PYColor colorWithHexString:@"#DC143C"]);
     }]);
     }])
     .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
     axisTick.showEqual(YES);
     axisTick.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
     lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
     }]);
     axisTick.onGapEqual(YES);
     }])
     .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
     axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
     textStyle.colorEqual([PYColor colorWithHexString:@"#4eb2ff"]);
     }]);
     }])
     .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
     splitLine.showEqual(NO);
     splitLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
     lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
     }]);
     splitLine.onGapEqual(YES);
     }])
     .addDataArr(@[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"]);
     }])
     .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
     axis.typeEqual(PYAxisTypeValue)
     .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
     axisTick.showEqual(NO);
     }])
     .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
     axisLine.showEqual(NO);
     }])
     .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
     splitLine.showEqual(NO);
     }])
     .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
     axisLabel.formatterEqual(@"{value}");
     axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
     textStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
     }]);
     }]);
     
     }])
     .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
     series.stackEqual(@"步数")
     .symbolEqual(PYSymbolEmptyCircle)
     .typeEqual(PYSeriesTypeLine)
     .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
     itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
     itemStyleProp.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
     itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
     lineStyle.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
     
     }]);
     }]);
     }])
     .dataEqual(@[@100,@432,@5436,@3125,@64,@534,@534]);
     
     }]);
     }];
     */
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
            tooltip.axisPointerEqual([PYAxisPointer initPYAxisPointerWithBlock:^(PYAxisPointer *axisPoint) {
                axisPoint.typeEqual(PYAxisPointerTypeLine);
                axisPoint.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                    lineStyle.widthEqual(@1);
                    lineStyle.typeEqual(PYLineStyleTypeSolid);
                }]);
            }]);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50);
            grid.borderWidthEqual(@0);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"步数"]);
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@NO)
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(YES);
                axisTick.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                //                axisLabel.formatterEqual(@"(function (params) {params = params.replace(/-/g,\"/\");var date = new Date(params);return (date.getMonth()+1) + '-' + date.getDate();})");
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                }]);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(NO);
            }])
            .addDataArr(@[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(YES);
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value}");
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                }]);
            }]);
            
        }])
        .addSeries([PYSeries initPYSeriesWithBlock:^(PYSeries *series) {
            series.nameEqual(@"体重")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
                    itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                        lineStyle.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
                        
                    }]);
                }]);
            }])
            .dataEqual(@[@100,@432,@5436,@3125,@64,@534,@534]);
        }]);
    }];
}
@end
