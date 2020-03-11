//
//  ZPAllLectureHistoryCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAllLectureHistoryCell.h"
@interface ZPAllLectureHistoryCell()
@property (nonatomic,strong) UIView *grayView2;
@property (nonatomic,strong) UILabel *historyLecturetipLabel;
@property (nonatomic,strong) UIButton *moreBtn;
@end
@implementation ZPAllLectureHistoryCell

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
    self.historyLecturetipLabel = [UILabel new];
    self.moreBtn = [UIButton new];
    self.grayView2 = [UIView new];
    [contentView sd_addSubviews:@[self.historyLecturetipLabel,self.moreBtn,self.grayView2]];
    
    self.grayView2.backgroundColor = RGB_242_242_242;
    self.grayView2.sd_layout
    .topSpaceToView(contentView, 0)
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
    self.historyLecturetipLabel.text = @"直播讲堂";
    
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
    [self setupAutoHeightWithBottomView:self.historyLecturetipLabel bottomMargin:10];
}

- (void)moreHistoryAction {
    if (self.moreHistoryLecturesBlock) {
        self.moreHistoryLecturesBlock();
    }
}
@end
