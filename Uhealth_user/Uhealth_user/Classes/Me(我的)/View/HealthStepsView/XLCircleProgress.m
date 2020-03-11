//
//  CircleView.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircleProgress.h"
#import "XLCircle.h"

@implementation XLCircleProgress
{
    XLCircle* _circle;
    UILabel *_percentLabel;
    UILabel *_todayLabel;
    UIImageView *_stepIcon;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


-(void)initUI
{
    float lineWidth = 0.1*self.bounds.size.width;
    _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _percentLabel.textColor = [UIColor whiteColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.font = [UIFont boldSystemFontOfSize:50];
    _percentLabel.text = @"0%";
    [self addSubview:_percentLabel];
    
    _todayLabel = [UILabel new];
    [self addSubview:_todayLabel];
    _todayLabel.sd_layout
    .bottomSpaceToView(self, ZPHeight(46))
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(ZPHeight(16));
    _todayLabel.textColor = [UIColor whiteColor];
    _todayLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(16)];
    _todayLabel.textAlignment = NSTextAlignmentCenter;
    _todayLabel.text = @"今日步数";
    
    _stepIcon = [UIImageView new];
    [self addSubview:_stepIcon];
    _stepIcon.sd_layout
    .topSpaceToView(self, ZPHeight(33))
    .centerXEqualToView(self)
    .widthIs(ZPHeight(69*0.5))
    .heightIs(ZPHeight(71*0.5));
    _stepIcon.image = [UIImage imageNamed:@"step_step_icon"];
    
    _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:lineWidth];
    [self addSubview:_circle];
}

#pragma mark -
#pragma mark Setter方法
-(void)setProgress:(float)progress
{
    _progress = progress;
    _circle.progress = progress;
//    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
}

- (void)setSteps:(double)steps {
    _steps = steps;
    NSInteger s = (NSInteger)steps;
    _percentLabel.text = [NSString stringWithFormat:@"%ld",s];
}
@end
