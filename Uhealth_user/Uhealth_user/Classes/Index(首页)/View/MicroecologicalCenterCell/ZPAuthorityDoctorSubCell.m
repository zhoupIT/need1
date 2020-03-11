//
//  ZPAuthorityDoctorSubCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAuthorityDoctorSubCell.h"
#import "ZPChannelDoctorModel.h"

@interface ZPAuthorityDoctorSubCell()
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *contentLabel;
@end
@implementation ZPAuthorityDoctorSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *contentView = self.contentView;
    self.subTitleLabel = [UILabel new];
    self.lineView = [UIView new];
    self.contentLabel = [UILabel new];
    [contentView sd_addSubviews:@[self.subTitleLabel,self.lineView,self.contentLabel]];
    
    self.subTitleLabel.textColor = RGB(74, 74, 74);
    self.subTitleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.subTitleLabel.sd_layout
    .leftSpaceToView(contentView, 14)
    .rightSpaceToView(contentView, 14)
    .topSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    
    self.lineView.backgroundColor =RGB_242_242_242;
    self.lineView.sd_layout
    .topSpaceToView(self.subTitleLabel, 10)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    
    self.contentLabel.textColor = RGB(153, 153, 153);
    self.contentLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.contentLabel.sd_layout
    .topSpaceToView(self.lineView, 15)
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.contentLabel] bottomMargin:15];

}

- (void)setModel:(ZPChannelDoctorModel *)model {
    _model = model;
    if (model.index == 1) {
        self.subTitleLabel.text = @"医生简介";
        self.contentLabel.text = model.doctorIntroductionBr;
    } else {
        self.subTitleLabel.text = @"擅长领域";
        self.contentLabel.text = model.doctorField;
    }
}

@end
