//
//  ZPGreenPathReservationSerTitleCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathReservationSerTitleCell.h"

@interface ZPGreenPathReservationSerTitleCell()
{
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}
@end
@implementation ZPGreenPathReservationSerTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    _titleLabel = [UILabel new];
    _subTitleLabel = [UILabel new];
    [contentView sd_addSubviews:@[_titleLabel,_subTitleLabel]];
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, ZPWidth(16))
    .topSpaceToView(contentView, ZPHeight(15))
    .rightSpaceToView(contentView, ZPWidth(16))
    .autoHeightRatio(0);
    _titleLabel.textColor = RGB_74_74_74;
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _titleLabel.text = @"全过程就医咨询";
    
    _subTitleLabel.sd_layout
    .leftSpaceToView(contentView, ZPWidth(16))
    .rightSpaceToView(contentView, ZPWidth(16))
    .topSpaceToView(_titleLabel, ZPHeight(12))
    .autoHeightRatio(0);
    _subTitleLabel.textColor = RGB_170_170_170;
    _subTitleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(13)];
    _subTitleLabel.text = @"日常医学咨询、诊前就医指导、慢性病管理咨询、预防及日常保健咨询、康复跟踪指导等。";
    
    [self setupAutoHeightWithBottomView:_subTitleLabel bottomMargin:ZPHeight(16)];
}

@end
