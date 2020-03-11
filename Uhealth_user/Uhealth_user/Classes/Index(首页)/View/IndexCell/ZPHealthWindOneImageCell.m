//
//  ZPHealthWindOneImageCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHealthWindOneImageCell.h"
#import "SDWeiXinPhotoContainerView.h"

#import "ZPHealthWindModel.h"
@interface ZPHealthWindOneImageCell()
{
    //标题
    UILabel *_titleLabel;
    //图片
    UIImageView *_iconView;
    //分割线
    UIView *_sepLine;
    //浏览量
    UILabel *_pageViewLabel;
    
}
@end
@implementation ZPHealthWindOneImageCell
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
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = RGB_74_74_74;
    
    
    _iconView = [UIImageView new];
    [contentView sd_addSubviews:@[_iconView]];
    _iconView.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(ZPHeight(76))
    .widthIs(ZPWidth(116))
    .topSpaceToView(self.contentView, 15);
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
    
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(_iconView, 10)
    .autoHeightRatio(0)
    .topSpaceToView(contentView, 15);
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    [_titleLabel setMaxNumberOfLinesToShow:2];
    
    
    _pageViewLabel = [UILabel new];
    [contentView addSubview:_pageViewLabel];
    _pageViewLabel.sd_layout
    .bottomEqualToView(_iconView)
    .leftSpaceToView(contentView, 15)
    .heightIs(11)
    .rightSpaceToView(_iconView, 5);
    _pageViewLabel.textColor = RGB_170_170_170;
    _pageViewLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    
    _sepLine = [UIView new];
    [contentView addSubview:_sepLine];
    _sepLine.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    _sepLine.backgroundColor  = RGB_242_242_242;
    
    [self setupAutoHeightWithBottomViewsArray:@[_iconView,_titleLabel] bottomMargin:10];
}




- (void)setModel:(ZPHealthWindModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.titleImgList.firstObject] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
    NSDate *resDate = [formatter dateFromString:model.createDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    _pageViewLabel.text = [fmt stringFromDate:resDate];
}


@end
