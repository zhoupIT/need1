//
//  ZPLivingBroadcastTopCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLivingBroadcastTopCell.h"
#import "ZPLectureModel.h"
#import "ZPLivingBroadcastImgCell.h"
#import "ZPlectureIntroductionImg.h"
#import "XBTimerManager.h"
@interface ZPLivingBroadcastTopCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UIImageView *coverPlayImg;
@property (nonatomic,strong) UIView *backPlayView;

@property (nonatomic,strong) UILabel *covertipLabel;
@property (nonatomic,strong) UIView *lwhiteLine;
@property (nonatomic,strong) UIView *rwhiteLine;
@property (nonatomic,strong) UIImageView *coverImg;

@property (nonatomic,strong) UIView *coverTimeView;
@property (nonatomic,strong) UILabel *coverdayLabel;
@property (nonatomic,strong) UILabel *TcoverdayLabel;
@property (nonatomic,strong) UILabel *coverhourLabel;
@property (nonatomic,strong) UILabel *TcoverhourLabel;
@property (nonatomic,strong) UILabel *covertimeLabel;
@property (nonatomic,strong) UILabel *TcovertimeLabel;
@property (nonatomic,strong) UILabel *coversecondLabel;
@property (nonatomic,strong) UILabel *TcoversecondLabel;

@property (nonatomic,strong) UILabel *lectureName;
@property (nonatomic,strong) UILabel *lectureTime;

@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *lectureIntroductiontipLabel;

@property (nonatomic,strong) UILabel *lectureSpeakerLabel;
@property (nonatomic,strong) UILabel *lectureDoctorIntroductionLabel;
@property (nonatomic,strong) UILabel *lectureIntroductionLabel;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) UIView *grayView2;

@property (nonatomic,strong) UILabel *historyLecturetipLabel;

@property (nonatomic,strong) UIButton *moreBtn;
@end
@implementation ZPLivingBroadcastTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    self.iconView = [UIImageView new];
    self.lectureName = [UILabel new];
    self.lectureTime = [UILabel new];
    self.lectureIntroductiontipLabel = [UILabel new];
    self.lectureSpeakerLabel = [UILabel new];
    self.lectureDoctorIntroductionLabel = [UILabel new];
    self.lectureIntroductionLabel = [UILabel new];
    self.historyLecturetipLabel = [UILabel new];
    self.grayView = [UIView new];
    self.grayView2 = [UIView new];
    self.lineView = [UIView new];
    self.moreBtn = [UIButton new];
    [contentView sd_addSubviews:@[self.iconView,self.lectureName,self.lectureTime,self.lectureIntroductiontipLabel,self.lectureSpeakerLabel,self.lectureDoctorIntroductionLabel,self.lectureIntroductionLabel,self.historyLecturetipLabel,self.grayView,self.grayView2,self.lineView,self.moreBtn]];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    self.iconView.userInteractionEnabled=  YES;
    self.iconView.sd_layout
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0)
    .heightIs(ZPHeight(230));
   
    
    self.lectureName.textColor = ZPMyOrderDetailFontColor;
    self.lectureName.font = [UIFont fontWithName:ZPPFSCMedium size:17];
    self.lectureName.sd_layout
    .topSpaceToView(self.iconView, 15)
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    
    self.lectureTime.textColor = ZPMyOrderDeleteBorderColor;
    self.lectureTime.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.lectureTime.sd_layout
    .topSpaceToView(self.lectureName, 10)
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    self.lectureTime.text = @"时间:";
    
    self.grayView.backgroundColor = RGB_242_242_242;
    self.grayView.sd_layout
    .topSpaceToView(self.lectureTime, 15)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(8);
    
    self.lectureIntroductiontipLabel.textColor = ZPMyOrderDetailFontColor;
    self.lectureIntroductiontipLabel.font = [UIFont fontWithName:ZPPFSCMedium size:16];
    self.lectureIntroductiontipLabel.sd_layout
    .topSpaceToView(self.grayView, 8)
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    self.lectureIntroductiontipLabel.text = @"直播简介";
    
    self.lineView.backgroundColor = RGB_242_242_242;
    self.lineView.sd_layout
    .topSpaceToView(self.lectureIntroductiontipLabel, 11)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    
    self.lectureSpeakerLabel.textColor = ZPMyOrderDetailValueFontColor;
    self.lectureSpeakerLabel.font = [UIFont fontWithName:ZPPFSCMedium size:16];
    self.lectureSpeakerLabel.sd_layout
    .topSpaceToView(self.lineView, 15)
    .rightSpaceToView(contentView, 15)
    .leftSpaceToView(contentView, 15)
    .autoHeightRatio(0);
     self.lectureIntroductionLabel.text = @"主讲人: ";
    
    self.lectureDoctorIntroductionLabel.textColor = ZPMyOrderDetailFontColor;
    self.lectureDoctorIntroductionLabel.font = [UIFont fontWithName:ZPPFSCRegular size:15];
    self.lectureDoctorIntroductionLabel.sd_layout
    .topSpaceToView(self.lectureSpeakerLabel, 15)
    .rightSpaceToView(contentView, 15)
    .leftSpaceToView(contentView, 15)
    .autoHeightRatio(0);
     self.lectureIntroductionLabel.text = @"讲师简介: ";
    
    
    self.lectureIntroductionLabel.textColor = ZPMyOrderDetailFontColor;
    self.lectureIntroductionLabel.font = [UIFont fontWithName:ZPPFSCRegular size:15];
    self.lectureIntroductionLabel.sd_layout
    .topSpaceToView(self.lectureDoctorIntroductionLabel, 15)
    .rightSpaceToView(contentView, 15)
    .leftSpaceToView(contentView, 15)
    .autoHeightRatio(0);
    self.lectureIntroductionLabel.text = @"直播概述: ";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZPLivingBroadcastImgCell class] forCellReuseIdentifier:NSStringFromClass([ZPLivingBroadcastImgCell class])];
    [contentView addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.lectureIntroductionLabel, 15)
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10);
    
    self.grayView2.backgroundColor = RGB_242_242_242;
    self.grayView2.sd_layout
    .topSpaceToView(self.tableView, 15)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(10);

    self.historyLecturetipLabel.textColor = ZPMyOrderDetailFontColor;
    self.historyLecturetipLabel.font = [UIFont fontWithName:ZPPFSCMedium size:16];
    self.historyLecturetipLabel.sd_layout
    .topSpaceToView(self.grayView2, 10)
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    self.historyLecturetipLabel.text = @"TA的其它直播";
    
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:@"arrow_more_icon"] forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCLight size:12];
    [self.moreBtn addTarget:self action:@selector(moreHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:7];
    self.moreBtn.sd_layout
    .centerYEqualToView(self.historyLecturetipLabel)
    .widthIs(35)
    .rightSpaceToView(contentView, 15)
    .heightIs(30);
    
    self.backPlayView = [UIView new];
    self.coverPlayImg = [UIImageView new];
    [self.iconView addSubview:self.coverPlayImg];
    self.coverPlayImg.sd_layout
    .centerXEqualToView(self.iconView)
    .centerYEqualToView(self.iconView)
    .heightIs(ZPHeight(60))
    .widthIs(ZPWidth(60));
    self.coverPlayImg.image = [UIImage imageNamed:@"index_headImg_play"];
    self.coverPlayImg.userInteractionEnabled=  YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterLectureAction)];
    [self.coverPlayImg addGestureRecognizer:tap];
    self.coverPlayImg.hidden = YES;
    
   
    [self.iconView addSubview:self.backPlayView];
    self.backPlayView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.backPlayView.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.covertipLabel = [UILabel new];
    self.coverImg = [UIImageView new];
    self.coverdayLabel = [UILabel new];
    self.coverhourLabel = [UILabel new];
    self.coversecondLabel = [UILabel new];
    self.covertimeLabel = [UILabel new];
    self.coverTimeView = [UIView new];
    
    self.lwhiteLine = [UIView new];
    self.rwhiteLine = [UIView new];
    self.TcoverdayLabel = [UILabel new];
    self.TcoverhourLabel = [UILabel new];
    self.TcovertimeLabel = [UILabel new];
    self.TcoversecondLabel = [UILabel new];
    [self.backPlayView sd_addSubviews:@[self.covertipLabel,self.coverImg,self.coverTimeView,self.lwhiteLine,self.rwhiteLine]];

    self.covertipLabel.sd_layout
    .topSpaceToView(self.backPlayView, ZPHeight(62))
    .centerXEqualToView(self.backPlayView)
    .widthIs(82)
    .heightIs(16);
    self.covertipLabel.textColor = [UIColor whiteColor];
    self.covertipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:16];
    self.covertipLabel.text = @"距开始还有";
    
    self.lwhiteLine.sd_layout
    .widthIs(40)
    .heightIs(1)
    .centerYEqualToView(self.covertipLabel)
    .rightSpaceToView(self.covertipLabel, 20);
    self.lwhiteLine.backgroundColor = [UIColor whiteColor];
    
    self.rwhiteLine.sd_layout
    .widthIs(40)
    .heightIs(1)
    .centerYEqualToView(self.covertipLabel)
    .leftSpaceToView(self.covertipLabel, 20);
    self.rwhiteLine.backgroundColor = [UIColor whiteColor];
    
    
    self.coverImg.sd_layout
    .topSpaceToView(self.covertipLabel, ZPHeight(18))
    .centerXEqualToView(self.covertipLabel)
    .widthIs(24)
    .heightIs(22);
    self.coverImg.image = [UIImage imageNamed:@"lecture_timeout_icon"];
    
    self.coverTimeView.sd_layout
    .topSpaceToView(self.coverImg, ZPHeight(20))
    .centerXEqualToView(self.backPlayView)
    .widthIs(210)
    .heightIs(35);
    
    self.TcoverdayLabel = [UILabel new];
    
    self.TcoverhourLabel = [UILabel new];
    self.TcovertimeLabel = [UILabel new];
    
     [self.coverTimeView sd_addSubviews:@[self.coverdayLabel,self.coverhourLabel,self.coversecondLabel,self.covertimeLabel,self.TcoverdayLabel,self.TcoverhourLabel,self.TcovertimeLabel]];
    self.coverdayLabel.sd_layout
    .topSpaceToView(self.coverTimeView, 0)
    .leftSpaceToView(self.coverTimeView, 0)
    .bottomSpaceToView(self.coverTimeView, 0)
    .widthIs(45);
    self.coverdayLabel.layer.cornerRadius = 8;
    self.coverdayLabel.layer.masksToBounds = YES;
    self.coverdayLabel.backgroundColor = RGBA(0, 0, 0,0.53);
    self.coverdayLabel.textAlignment = NSTextAlignmentCenter;
    self.coverdayLabel.textColor = [UIColor whiteColor];
    
    self.coverhourLabel.sd_layout
    .topSpaceToView(self.coverTimeView, 0)
    .leftSpaceToView(self.coverdayLabel, 10)
    .bottomSpaceToView(self.coverTimeView, 0)
    .widthIs(45);
    self.coverhourLabel.layer.cornerRadius = 8;
    self.coverhourLabel.layer.masksToBounds = YES;
    self.coverhourLabel.backgroundColor = RGBA(0, 0, 0,0.53);
    self.coverhourLabel.textAlignment = NSTextAlignmentCenter;
    self.coverhourLabel.textColor = [UIColor whiteColor];
    
    self.covertimeLabel.sd_layout
    .topSpaceToView(self.coverTimeView, 0)
    .leftSpaceToView(self.coverhourLabel, 10)
    .bottomSpaceToView(self.coverTimeView, 0)
    .widthIs(45);
    self.covertimeLabel.layer.cornerRadius = 8;
    self.covertimeLabel.layer.masksToBounds = YES;
    self.covertimeLabel.backgroundColor = RGBA(0, 0, 0,0.53);
    self.covertimeLabel.textAlignment = NSTextAlignmentCenter;
    self.covertimeLabel.textColor = [UIColor whiteColor];
    
    self.coversecondLabel.sd_layout
    .topSpaceToView(self.coverTimeView, 0)
    .leftSpaceToView(self.covertimeLabel, 10)
    .bottomSpaceToView(self.coverTimeView, 0)
    .widthIs(45);
    self.coversecondLabel.layer.cornerRadius = 8;
    self.coversecondLabel.layer.masksToBounds = YES;
    self.coversecondLabel.backgroundColor = RGBA(0, 0, 0,0.53);
    self.coversecondLabel.textAlignment = NSTextAlignmentCenter;
    self.coversecondLabel.textColor = [UIColor whiteColor];
    
    self.TcoverdayLabel.sd_layout
    .leftSpaceToView(self.coverdayLabel, 4)
    .widthIs(3)
    .heightIs(10)
    .centerYEqualToView(self.coverTimeView);
    self.TcoverdayLabel.textAlignment = NSTextAlignmentCenter;
    self.TcoverdayLabel.textColor = [UIColor whiteColor];
    self.TcoverdayLabel.text = @":";
    
    self.TcoverhourLabel.sd_layout
    .leftSpaceToView(self.coverhourLabel, 4)
    .widthIs(3)
    .heightIs(10)
    .centerYEqualToView(self.coverTimeView);
    self.TcoverhourLabel.textAlignment = NSTextAlignmentCenter;
    self.TcoverhourLabel.textColor = [UIColor whiteColor];
    self.TcoverhourLabel.text = @":";
    
    self.TcovertimeLabel.sd_layout
    .leftSpaceToView(self.covertimeLabel, 4)
    .widthIs(3)
    .heightIs(10)
    .centerYEqualToView(self.coverTimeView);
    self.TcovertimeLabel.textAlignment = NSTextAlignmentCenter;
    self.TcovertimeLabel.textColor = [UIColor whiteColor];
    self.TcovertimeLabel.text = @":";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timout:) name:KNotificationTimeOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeend) name:KNotificationTimeEnd object:nil];
}

- (void)timout:(NSNotification *)notification {
    ZPLog(@"触发了");
    NSInteger  timeout = [[notification object] integerValue];
    NSString *str_day = [NSString stringWithFormat:@"%02ld",timeout/60/60/24];
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",timeout/60/60%24];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",timeout/60%60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",timeout%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@天:%@时:%@分:%@秒",str_day,str_hour,str_minute,str_second];
        
        
    dispatch_async(dispatch_get_main_queue(), ^{
        //修改倒计时标签及显示内容
        
        self.coverdayLabel.text = [NSString stringWithFormat:@"%@天",str_day];
        self.coverhourLabel.text = [NSString stringWithFormat:@"%@时",str_hour];
        self.covertimeLabel.text = [NSString stringWithFormat:@"%@分",str_minute];
        self.coversecondLabel.text = [NSString stringWithFormat:@"%@秒",str_second];
        ZPLog(@"当前讲座您还需要等待的时间%@",format_time);
        
    });
}

- (void)timeend {
    self.backPlayView.hidden = YES;
    self.coverPlayImg.hidden = NO;
}

- (void)setModel:(ZPLectureModel *)model {
    _model = model;
    if (model.timeout >0) {
        self.backPlayView.hidden = NO;
        self.coverPlayImg.hidden = YES;
        [[XBTimerManager sharedXBTimerManager] startGcdTimer:model.timeout];
    } else{
        self.backPlayView.hidden = YES;
        self.coverPlayImg.hidden = NO;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.lectureImg] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    self.lectureName.text = model.lectureName;
    self.lectureTime.text = [NSString stringWithFormat:@"时间:%@",model.lectureDate];
    self.lectureIntroductiontipLabel.text = @"直播简介";
    self.lectureSpeakerLabel.text = [NSString stringWithFormat:@"主讲人: %@",model.lectureSpeaker];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"讲师简介: %@",model.lectureDoctorIntroduction]];
    [attriString addAttributes:@{NSForegroundColorAttributeName:ZPMyOrderDetailFontColor} range:NSMakeRange(0, 5)];
    [attriString addAttributes:@{NSForegroundColorAttributeName:RGB(136, 136, 136)} range:NSMakeRange(5, attriString.length-5)];
    [self.lectureDoctorIntroductionLabel setAttributedText:attriString];
    
    
    NSMutableAttributedString *attriStringlectureIntroduction = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"直播概述: %@",model.lectureIntroduction]];
    [attriStringlectureIntroduction addAttributes:@{NSForegroundColorAttributeName:ZPMyOrderDetailFontColor} range:NSMakeRange(0, 5)];
    [attriStringlectureIntroduction addAttributes:@{NSForegroundColorAttributeName:RGB(136, 136, 136)} range:NSMakeRange(5, attriStringlectureIntroduction.length-5)];
    [self.lectureIntroductionLabel setAttributedText:attriStringlectureIntroduction];
    
    if (model.lectureIntroductionImg.count) {
        CGFloat height = 0;
        CGFloat w = (kSCREEN_WIDTH-20);
        for (ZPlectureIntroductionImg *img in model.lectureIntroductionImg) {
            if ( w <= img.width) {
                height += ((w / img.width) * img.height+5);
            } else {
                height += img.height;
            }
        }
        self.tableView.sd_layout.heightIs(height);
        self.data = [NSMutableArray arrayWithArray:model.lectureIntroductionImg];
        [self.tableView reloadData];
    } else {
        self.tableView.sd_layout.heightIs(0);
    }
    if (model.isBannerEnter) {
        self.grayView2.hidden = YES;
        self.historyLecturetipLabel.hidden = YES;
        self.moreBtn.hidden = YES;
         [self setupAutoHeightWithBottomView:self.tableView bottomMargin:15];
    } else {
        self.grayView2.hidden = NO;
        self.historyLecturetipLabel.hidden = NO;
        self.moreBtn.hidden = NO;
        [self setupAutoHeightWithBottomView:self.historyLecturetipLabel bottomMargin:10];
    }
}

- (void)moreHistoryAction {
    if (self.moreHistoryLecturesBlock) {
        self.moreHistoryLecturesBlock();
    }
}

- (void)enterLectureAction {
    if (self.enterLectureBlock) {
        self.enterLectureBlock();
    }
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPLivingBroadcastImgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPLivingBroadcastImgCell class])];
    cell.model = self.data[indexPath.row];
    return cell;
}

#pragma mark - -tableView的代理方法
/**
 *  返回行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = self.data[indexPath.row];
//    return [self.tableView cellHeightForIndexPath:indexPath model:dict keyPath:@"dict" cellClass:[ZPLivingBroadcastImgCell class] contentViewWidth:SCREEN_WIDTH];
    ZPlectureIntroductionImg *img = self.data[indexPath.row];
    CGFloat w = (kSCREEN_WIDTH-20);
    CGFloat height = 0;
    if ( w <= img.width) {
        height = ((w / img.width) * img.height+5);
    } else{
         height = img.height;
    }
    return height;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end
