//
//  ZPHealthWindCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHealthWindCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "ZPHealthWindModel.h"
@interface ZPHealthWindCell()
{
    //标题
    UILabel *_titleLabel;
    //图片1
    UIImageView *_iconView0;
    //图片2
    UIImageView *_iconView1;
    //图片3
    UIImageView *_iconView2;
    //浏览量
    UILabel *_pageViewLabel;
    //分割线
    UIView *_sepLine;
}
@end
@implementation ZPHealthWindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    
    _sepLine = [UIView new];
    [contentView addSubview:_sepLine];
    _sepLine.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    _sepLine.backgroundColor  = RGB_242_242_242;
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .heightIs(15)
    .topSpaceToView(contentView, 15);
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    _titleLabel.textColor = RGB_74_74_74;
    
    _iconView0 = [UIImageView new];
    _iconView1 = [UIImageView new];
    _iconView2 = [UIImageView new];
    [contentView sd_addSubviews:@[_iconView0,_iconView1,_iconView2]];
    _iconView0.sd_layout
    .leftSpaceToView(contentView,15)
    .heightIs(ZPHeight(76))
    .widthIs((kSCREEN_WIDTH-40)/3)
    .topSpaceToView(_titleLabel, 10);
    _iconView0.contentMode = UIViewContentModeScaleAspectFill;
    _iconView0.clipsToBounds = YES;
    
    _iconView1.sd_layout
    .leftSpaceToView(_iconView0,5)
    .heightIs(ZPHeight(76))
    .widthRatioToView(_iconView0, 1)
    .topSpaceToView(_titleLabel, 10);
    _iconView1.contentMode = UIViewContentModeScaleAspectFill;
    _iconView1.clipsToBounds = YES;
    
    _iconView2.sd_layout
    .leftSpaceToView(_iconView1,5)
    .heightIs(ZPHeight(76))
    .widthRatioToView(_iconView0, 1)
    .topSpaceToView(_titleLabel, 10);
    _iconView2.contentMode = UIViewContentModeScaleAspectFill;
    _iconView2.clipsToBounds = YES;
    
    _pageViewLabel = [UILabel new];
    [contentView addSubview:_pageViewLabel];
    _pageViewLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_iconView0, 10)
    .heightIs(12)
    .leftSpaceToView(contentView, 15);
    _pageViewLabel.textColor = RGB_170_170_170;
    _pageViewLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    
    [self setupAutoHeightWithBottomViewsArray:@[_pageViewLabel,_iconView0,_titleLabel] bottomMargin:10];
}

- (void)setModel:(ZPHealthWindModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
    NSDate *resDate = [formatter dateFromString:model.createDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    _pageViewLabel.text = [fmt stringFromDate:resDate];
    [_iconView0 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[0]] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    [_iconView1 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[1]] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    [_iconView2 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[2]] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
}

@end
