//
//  ZPHistoryStepsController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHistoryStepsController.h"
#import "ZPHistoryStepsCell.h"
#import "ZPStepModel.h"
#import "DateTools.h"

#import "Uhealth_user-Bridging-Header.h"
#import "SymbolsValueFormatter.h"
#import "ZPNavigationController.h"
#import "VVWaterWaveView.h"
/** 引入swift文件 */
#import "Uhealth_user-Swift.h"


@interface ZPHistoryStepsController ()<ChartViewDelegate>
@property (nonatomic,strong) UIImageView *calendarIcon;
@property (nonatomic,strong) UILabel *calendarLabel;
/** 折线图 */
@property (nonatomic, strong) LineChartView *chartView;
/** 气泡上的label */
@property (nonatomic,strong) UILabel *markYLabel;

@property (nonatomic,strong) UILabel *stepNumsValueLabel;
@property (nonatomic,strong) UILabel *stepNumsLabel;

@property (nonatomic,strong) UILabel *calValueLabel;
@property (nonatomic,strong) UILabel *calLabel;
@property (nonatomic,strong) UILabel *circleTipLabel;
@property (nonatomic,strong) UILabel *circleTipValueLabel;


@property (nonatomic,strong) UIButton *circleBtn;
@property (nonatomic,strong) UIButton *calBtn;

//步数数组
@property (nonatomic,strong) NSMutableArray *data;
//时间 步数数组
@property (nonatomic,strong) NSArray *stepModelData;

@property (nonatomic,strong) ZPStepModel *model;
/** 水波纹 */
@property (nonatomic,strong) VVWaterWaveView *waterWaveView;
@end

@implementation ZPHistoryStepsController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"历史记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view sd_addSubviews:@[self.calendarIcon,self.calendarLabel]];
    self.calendarIcon.sd_layout
    .leftSpaceToView(self.view, ZPWidth(16))
    .topSpaceToView(self.view, ZPHeight(10))
    .heightIs(ZPHeight(20))
    .widthIs(ZPWidth(22));
    
    self.calendarLabel.sd_layout
    .leftSpaceToView(self.calendarIcon, ZPWidth(8))
    .centerYEqualToView(self.calendarIcon)
    .rightSpaceToView(self.view, 0)
    .autoHeightRatio(0);
    

    [self.view addSubview:self.chartView];
    self.chartView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.calendarIcon, ZPHeight(10))
    .rightSpaceToView(self.view, 0)
    .heightIs(ZPHeight(260));
    
    
    [self.view sd_addSubviews:@[self.stepNumsValueLabel,self.stepNumsLabel,self.calValueLabel,self.calLabel,self.circleBtn,self.calBtn,self.waterWaveView]];
    
    
    
    self.waterWaveView.sd_layout
    .widthIs(ZPWidth(80))
    .heightIs(ZPWidth(80))
    .centerXEqualToView(self.view)
    .topSpaceToView(self.chartView, ZPHeight(27));
    self.waterWaveView.layer.cornerRadius = ZPWidth(80)*0.5;
    self.waterWaveView.layer.borderColor = RGB_78_178_255.CGColor;
    self.waterWaveView.layer.borderWidth = 1;
    self.waterWaveView.layer.masksToBounds = YES;
    [self.waterWaveView startWave];
    
    [self.waterWaveView sd_addSubviews:@[self.circleTipLabel,self.circleTipValueLabel]];
    self.circleTipLabel.sd_layout
    .topSpaceToView(self.waterWaveView, ZPHeight(25))
    .leftSpaceToView(self.waterWaveView, 0)
    .rightSpaceToView(self.waterWaveView, 0)
    .heightIs(ZPHeight(15));
    
    self.circleTipValueLabel.sd_layout
    .topSpaceToView(self.circleTipLabel, ZPHeight(8))
    .leftSpaceToView(self.waterWaveView, 0)
    .rightSpaceToView(self.waterWaveView, 0)
    .heightIs(ZPHeight(15));
    
    
    self.stepNumsValueLabel.sd_layout
    .topSpaceToView(self.chartView, ZPHeight(52))
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.waterWaveView, 5)
    .heightIs(ZPHeight(19));
    
    self.stepNumsLabel.sd_layout
    .topSpaceToView(self.stepNumsValueLabel, ZPHeight(10))
    .heightIs(ZPHeight(15))
    .centerXEqualToView(self.stepNumsValueLabel);
    [self.stepNumsLabel setSingleLineAutoResizeWithMaxWidth:20];
    
    self.calValueLabel.sd_layout
    .topSpaceToView(self.chartView, ZPHeight(52))
    .leftSpaceToView(self.waterWaveView, 0)
    .rightSpaceToView(self.view, 5)
    .heightIs(ZPHeight(19));
    
    self.calLabel.sd_layout
    .topSpaceToView(self.calValueLabel, ZPHeight(10))
    .heightIs(ZPHeight(15))
    .centerXEqualToView(self.calValueLabel);
    [self.calLabel setSingleLineAutoResizeWithMaxWidth:20];
    
    self.circleBtn.sd_layout
    .topSpaceToView(self.waterWaveView, ZPHeight(37))
    .heightIs(ZPHeight(54))
    .widthIs(ZPWidth(260))
    .centerXEqualToView(self.view);
    self.circleBtn.imageView.sd_layout
    .widthIs(ZPWidth(60))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.circleBtn)
    .leftSpaceToView(self.circleBtn, ZPWidth(24));
    self.circleBtn.titleLabel.sd_layout
    .leftSpaceToView(self.circleBtn.imageView, ZPWidth(50))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.circleBtn)
    .rightSpaceToView(self.circleBtn, 0);
    
    
    self.calBtn.sd_layout
    .topSpaceToView(self.circleBtn, ZPHeight(14))
    .heightIs(ZPHeight(54))
    .widthIs(ZPWidth(260))
    .centerXEqualToView(self.view);
    self.calBtn.imageView.sd_layout
    .widthIs(ZPWidth(60))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.calBtn)
    .leftSpaceToView(self.calBtn, ZPWidth(24));
    self.calBtn.titleLabel.sd_layout
    .leftSpaceToView(self.calBtn.imageView, ZPWidth(50))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.calBtn)
    .rightSpaceToView(self.calBtn, 0);
    
}

- (void)initData {
    [self getNewSteps:@"" andEndDate:@""];
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
    
}

/* 刷新界面 */
- (void)refreshPage {
    [self getNewSteps:@"" andEndDate:@""];
}

/** 设置折线图的数据 */
- (void)setData
{
    //定义一个数组承接数据
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.data.count; i++) {
        //将横纵坐标以ChartDataEntry的形式保存下来，注意横坐标值一般是i的值，而不是你的数据    //里面具体的值，如何将具体数据展示在X轴上我们下面将会说到。
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[[self.data objectAtIndex:i] integerValue]];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    //请注意这里，如果你的图表以前绘制过，那么这里直接重新给data赋值就行了。
    //如果没有，那么要先定义set的属性。
    if (self.chartView.data.dataSetCount > 0) {
        LineChartData *data = (LineChartData *)self.chartView.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        set1 = (LineChartDataSet *)self.chartView.data.dataSets[0];
        set1.values = yVals;
        //通知data去更新
        [self.chartView.data notifyDataChanged];
        //通知图表去更新
        [self.chartView notifyDataSetChanged];
        
        [self.chartView animateWithXAxisDuration:1.0f];
    }else{
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc] initWithValues:yVals];
        //自定义set的各种属性
        //设置折线的样式
        set1.lineWidth = 1;
        set1.circleRadius = 5.0;
        set1.circleColors = @[[UIColor whiteColor]];
        [set1 setColor:RGB(78, 178, 255)];//折线颜色
        set1.circleHoleRadius = 2.0f;//空心的半径
        set1.circleColors = @[[UIColor whiteColor]];//空心的圈的颜色
        set1.circleHoleColor = RGB(78, 178, 255);//空心的颜色
        set1.drawCircleHoleEnabled = YES;
        set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
        set1.highlightColor = RGB(131,204,255);//点击选中拐点的十字线的颜色
        NSArray *gradientColors = @[
                                    (id)RGB(215,252,255).CGColor,
                                    (id)RGB(179,222,255).CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 1.f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];//赋值填充颜色对象
        set1.drawFilledEnabled = YES;
        CGGradientRelease(gradient);
        
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont systemFontOfSize:8.f]];//文字字体
        
        self.chartView.data = data;
        //这里可以调用一个加载动画即1s出来一个绘制点
        [self.chartView animateWithXAxisDuration:1.0f];
        
    }
}

#pragma mark - 处理步数
- (void)handleSteps:(NSInteger)steps {
    ZPStepModel *model = [[ZPStepModel alloc] init];
    if(steps >0) {
        model.stepsCount = steps;
        model.progress = floorf(steps/100);
        model.liDis = [NSString stringWithFormat:@"%0.2f", steps*0.00075015];
        model.circle = [NSString stringWithFormat:@"%0.1f", ((CGFloat)steps*0.00075015)*1000/400];
        model.calorie = round(steps*0.03620225);
        model.cocoNums = round(steps*0.03620225)/141.9;
        ZPLog(@"%@",model);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.waterWaveView.percent = model.progress/100;
            self.stepNumsValueLabel.text = [NSString stringWithFormat:@"%ld",model.stepsCount];
            self.calValueLabel.text = [NSString stringWithFormat:@"%ld",model.calorie];
            [self.circleBtn setTitle:[NSString stringWithFormat:@"≈绕操场%@圈",model.circle] forState:UIControlStateNormal];
            [self.calBtn setTitle:[NSString stringWithFormat:@"≈%ld杯可乐的热量",model.cocoNums] forState:UIControlStateNormal];
            self.circleTipValueLabel.text = [NSString stringWithFormat:@"%d%%",(int)model.progress];
        });
        
    } else {
        model.stepsCount = 0;
        model.progress = 0;
        model.liDis = [NSString stringWithFormat:@"0"];
        model.circle = [NSString stringWithFormat:@"0"];
        model.calorie = 0;
        model.cocoNums = 0;
        ZPLog(@"%@",model);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.stepNumsValueLabel.text = [NSString stringWithFormat:@"0"];
            self.calValueLabel.text = [NSString stringWithFormat:@"0"];
            [self.circleBtn setTitle:[NSString stringWithFormat:@"≈绕操场0圈"] forState:UIControlStateNormal];
            [self.calBtn setTitle:[NSString stringWithFormat:@"≈0杯可乐的热量"] forState:UIControlStateNormal];
            self.circleTipValueLabel.text = [NSString stringWithFormat:@"0%%"];
            self.waterWaveView.percent = 0;
        });
    }
    self.model = model;
}


- (void)getNewSteps:(NSString *)startDate andEndDate:(NSString *)endDate {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"customer/steps" parameters:@{@"startDate":startDate,@"endDate":endDate} progress:^(NSProgress *progress) {
        ZPLog(@"%@",progress);
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSArray *array =  [ZPStepModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            if (array.count) {
                [weakSelf.data removeAllObjects];
                for (ZPStepModel *model in array) {
                    if (model.stepsCount != nil) {
                        [weakSelf.data addObject:[NSNumber numberWithInteger:model.stepsCount]];
                    } else {
                        [weakSelf.data addObject:@"-"];
                    }
                }
                weakSelf.stepModelData = array;
                ZPStepModel *fitstM = weakSelf.stepModelData.firstObject;
                ZPStepModel *lastM = weakSelf.stepModelData.lastObject;
                NSString *firstS = [fitstM.stepsDate substringFromIndex:5];
                NSString *lastS = [lastM.stepsDate substringFromIndex:5];
                
                weakSelf.calendarLabel.text = [NSString stringWithFormat:@"%@-%@",[firstS stringByReplacingOccurrencesOfString:@"-" withString:@"."],[lastS stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
                ZPLog(@"数据获取到了:%@",weakSelf.data);
                [weakSelf setData];
            }
        } else {
            
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPHistoryStepsController class]];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        ZPLog(@"右滑");
        //
        if (self.stepModelData.count) {
            ZPStepModel *model = self.stepModelData.firstObject;
            NSString *firstdayString = model.stepsDate;
            [self getNewSteps:firstdayString andEndDate:@""];
        } else {
            [MBProgressHUD showError:@"暂无数据"];
        }
        
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        ZPLog(@"左滑");
        if (self.stepModelData.count) {
            ZPStepModel *model = self.stepModelData.lastObject;
            NSString *lastdayString = model.stepsDate;
            NSDate *lastday = [NSDate dateWithString:lastdayString formatString:@"yyyy-MM-dd"];
            if (![lastday isLaterThanOrEqualTo:[NSDate date]]) {
                [self getNewSteps:@"" andEndDate:lastdayString];
            } else {
                //最后一天 大于等于今天 就不能滑动
                [MBProgressHUD showError:@"暂无数据"];
            }
            
        } else {
            [MBProgressHUD showError:@"暂无数据"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.disableDragBack = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.disableDragBack = NO;
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
//    self.markYLabel.text = [NSString stringWithFormat:@"%.0f", entry.y];
    ZPLog(@"选择%.0f",entry.y);
    NSInteger steps = (NSInteger)entry.y;
    [self handleSteps:steps];
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    ZPLog(@"取消选择");
    [self handleSteps:0];
}

- (UILabel *)stepNumsLabel {
    if (!_stepNumsLabel) {
        _stepNumsLabel = [UILabel new];
        _stepNumsLabel.textColor = ZPMyOrderDetailValueFontColor;
        _stepNumsLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
        _stepNumsLabel.text = @"步";
    }
    return _stepNumsLabel;
}

- (UILabel *)stepNumsValueLabel {
    if (!_stepNumsValueLabel) {
        _stepNumsValueLabel = [UILabel new];
        _stepNumsValueLabel.textColor = ZPMyOrderDetailValueFontColor;
        _stepNumsValueLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)];
        _stepNumsValueLabel.text = @"0";
        _stepNumsValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stepNumsValueLabel;
}

- (UILabel *)calLabel {
    if (!_calLabel) {
        _calLabel = [UILabel new];
        _calLabel.textColor = RGB(255,180,0);
        _calLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
        _calLabel.text = @"卡";
    }
    return _calLabel;
}

- (UILabel *)calValueLabel {
    if (!_calValueLabel) {
        _calValueLabel = [UILabel new];
        _calValueLabel.textColor = RGB(255,180,0);
        _calValueLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)];
        _calValueLabel.text = @"0";
        _calValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _calValueLabel;
}

- (UIButton *)circleBtn {
    if (!_circleBtn) {
        _circleBtn = [UIButton new];
        _circleBtn.layer.borderColor = RGB(77, 199, 4).CGColor;
        _circleBtn.layer.borderWidth = 1;
        _circleBtn.layer.cornerRadius = 4;
        _circleBtn.layer.masksToBounds = YES;
        [_circleBtn setImage:[UIImage imageNamed:@"step_footground_icon"] forState:UIControlStateNormal];
        [_circleBtn setTitle:@"≈绕操场0圈" forState:UIControlStateNormal];
        [_circleBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _circleBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    }
    return _circleBtn;
}

- (UIButton *)calBtn {
    if (!_calBtn) {
        _calBtn = [UIButton new];
        _calBtn.layer.borderColor = RGB(255,180,0).CGColor;
        _calBtn.layer.borderWidth = 1;
        _calBtn.layer.cornerRadius = 4;
        _calBtn.layer.masksToBounds = YES;
        [_calBtn setImage:[UIImage imageNamed:@"step_heat_icon"] forState:UIControlStateNormal];
        [_calBtn setTitle:@"≈0杯可乐的热量" forState:UIControlStateNormal];
        [_calBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _calBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    }
    return _calBtn;
}

- (UIImageView *)calendarIcon {
    if (!_calendarIcon) {
        _calendarIcon = [UIImageView new];
        _calendarIcon.image = [UIImage imageNamed:@"stepHistory_cal_icon"];
    }
    return _calendarIcon;
}

- (UILabel *)calendarLabel {
    if (!_calendarLabel) {
        _calendarLabel = [UILabel new];
        _calendarLabel.textColor = ZPMyOrderDetailValueFontColor;
        _calendarLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(16)];
    }
    return _calendarLabel;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray arrayWithArray:@[@"-",@"-",@"-",@"-",@"-",@"-",@"-"]];
    }
    return _data;
}

- (NSArray *)stepModelData {
    if (!_stepModelData) {
        _stepModelData = [NSArray array];
    }
    return _stepModelData;
}

- (UILabel *)circleTipLabel {
    if (!_circleTipLabel) {
        _circleTipLabel = [UILabel new];
        _circleTipLabel.textColor = ZPMyOrderDetailValueFontColor;
        _circleTipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
        _circleTipLabel.textAlignment= NSTextAlignmentCenter;
        _circleTipLabel.text = @"达成目标";
    }
    return _circleTipLabel;
}

- (UILabel *)circleTipValueLabel {
    if (!_circleTipValueLabel) {
        _circleTipValueLabel = [UILabel new];
        _circleTipValueLabel.textColor = ZPMyOrderDetailValueFontColor;
        _circleTipValueLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(16)];
        _circleTipValueLabel.textAlignment= NSTextAlignmentCenter;
        _circleTipValueLabel.text = @"0%";
    }
    return _circleTipValueLabel;
}

- (LineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[LineChartView alloc] init];
        _chartView.delegate = self;
        
        _chartView.chartDescription.enabled = NO;
        
        _chartView.leftAxis.enabled = NO;
        _chartView.leftAxis.drawGridLinesEnabled = NO;
        _chartView.rightAxis.enabled = NO;
        _chartView.leftAxis.axisMinimum = 0;
        
        _chartView.xAxis.enabled = YES;
        _chartView.xAxis.drawAxisLineEnabled = YES;
        _chartView.xAxis.drawGridLinesEnabled = NO;
        // 设置 X 轴的显示位置，默认是显示在上面的
        _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
        _chartView.xAxis.valueFormatter = [[SymbolsValueFormatter alloc] init];
        _chartView.xAxis.labelTextColor =RGB(78, 178, 255);
//        _chartView.xAxis.axisMinimum = -0.4;
        
        
        _chartView.drawGridBackgroundEnabled = NO;
        _chartView.drawBordersEnabled = NO;
        _chartView.dragEnabled = NO;
        _chartView.noDataText = @"暂无数据";
        [_chartView setScaleEnabled:NO];
        _chartView.pinchZoomEnabled = NO;
        
        _chartView.legend.enabled = NO;
        _chartView.userInteractionEnabled = YES;
       UISwipeGestureRecognizer *rightrecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [rightrecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [_chartView addGestureRecognizer:rightrecognizer];
        
        
        UISwipeGestureRecognizer *leftrecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [leftrecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [_chartView addGestureRecognizer:leftrecognizer];
        
        
//        // 显示气泡效果
//        ChartMarkerView *markerY = [[ChartMarkerView alloc]init];
//        // 把这个注释掉就会跟着动了
//        //    markerY.offset = CGPointMake(-999, -8);
//        markerY.chartView = _chartView;
//        _chartView.marker = markerY;
//        [markerY addSubview:self.markYLabel];
        
        
 
//        self.markYLabel.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
       
        BalloonMarker *marker = [[BalloonMarker alloc]
                                 initWithColor: [UIColor whiteColor]
                                 font: [UIFont fontWithName:@"PingFangSC-Medium" size:12]
                                 textColor: RGB(153,153,153)
                                 insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
     
        marker.chartView = _chartView;
        marker.minimumSize = CGSizeMake(80.f, 40.f);
        _chartView.marker = marker;
    }
    return _chartView;
}

- (UILabel *)markYLabel {
    if (!_markYLabel) {
        _markYLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, -24, 40, 24)];;
        _markYLabel.backgroundColor = [UIColor whiteColor];
        _markYLabel.textColor = RGB(153,153,153);
        _markYLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _markYLabel.textAlignment = NSTextAlignmentCenter;
        _markYLabel.layer.borderColor = RGB(214, 214, 214).CGColor;
        _markYLabel.layer.borderWidth = 1;
        _markYLabel.layer.cornerRadius = 5;
        _markYLabel.layer.masksToBounds = YES;
    }
    return _markYLabel;
}

- (VVWaterWaveView *)waterWaveView {
    if (!_waterWaveView) {
        _waterWaveView = [VVWaterWaveView new];
        //百分比
        _waterWaveView.percent = 0;
        //振幅
        _waterWaveView.amplitude = 1;
        _waterWaveView.waveLayerColorArray = @[RGBA(126,199,255, 0.28),RGBA(99,205,255, 0.24)];
    }
    return _waterWaveView;
}
@end
