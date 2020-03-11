//
//  ZPOrderCommentsCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPOrderCommentsCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "ZPCommentsModel.h"
@interface ZPOrderCommentsCell()
{
    UIImageView *_avaImageView;
    UILabel *_customerNameLabel;
    UILabel *_timeLabel;
    UILabel *_descLabel;
    UILabel *_contentLabel;
    UILabel *_evaluationStarLabel;
    UIImageView *_evaluationStarImageView;//评价
    SDWeiXinPhotoContainerView *_photoContainerView;
}
@end
@implementation ZPOrderCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    
    _avaImageView = [UIImageView new];
    [contentView addSubview:_avaImageView];
    _avaImageView.layer.cornerRadius = 22;
    _avaImageView.layer.masksToBounds = YES;
    
    _customerNameLabel = [UILabel new];
    [contentView addSubview:_customerNameLabel];
    _customerNameLabel.textColor = ZPMyOrderDetailFontColor;
    _customerNameLabel.font = [UIFont systemFontOfSize:13];
    
    _evaluationStarLabel = [UILabel new];
    [contentView addSubview:_evaluationStarLabel];
    _evaluationStarLabel.font = [UIFont systemFontOfSize:12];
    _evaluationStarLabel.textColor = ZPMyOrderDeleteBorderColor;
    
    _evaluationStarImageView = [UIImageView new];
    [contentView addSubview:_evaluationStarImageView];
    

    _timeLabel = [UILabel new];
    [contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor =ZPMyOrderDeleteBorderColor;
    
    _contentLabel = [UILabel new];
    [contentView addSubview:_contentLabel];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = ZPMyOrderDetailFontColor;
    
    _photoContainerView = [SDWeiXinPhotoContainerView new];
    [contentView addSubview:_photoContainerView];
    
    
    _avaImageView.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 10)
    .heightIs(44)
    .widthIs(44);
    
    _customerNameLabel.sd_layout
    .topEqualToView(_avaImageView)
    .leftSpaceToView(_avaImageView, 10)
    .rightSpaceToView(contentView, 15)
    .heightIs(13);
    
    _evaluationStarLabel.sd_layout
    .leftEqualToView(_customerNameLabel)
    .topSpaceToView(_customerNameLabel, 10)
    .heightIs(12);
    [_evaluationStarLabel setSingleLineAutoResizeWithMaxWidth:30];
    
    _evaluationStarImageView.sd_layout
    .leftSpaceToView(_evaluationStarLabel, 8)
    .heightIs(22)
    .centerYEqualToView(_evaluationStarLabel)
    .widthIs(100);
    
    
    _timeLabel.sd_layout.topSpaceToView(_avaImageView, 10)
    .leftSpaceToView(contentView, 15)
    .heightIs(12);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _contentLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_timeLabel, 10)
    .autoHeightRatio(0);
    
    _photoContainerView.sd_layout
    .leftSpaceToView(contentView,15);
    

    
    [self setupAutoHeightWithBottomViewsArray:@[_photoContainerView] bottomMargin:10];
}

- (void)setModel:(ZPCommentsModel *)model {
    _model = model;
    [_avaImageView sd_setImageWithURL:[NSURL URLWithString:model.avaUrl]];
    _customerNameLabel.text = model.name;
    _evaluationStarLabel.text = @"评价";
    _timeLabel.text = model.time;
    _contentLabel.text = model.content;
    _evaluationStarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"prefer_star%d",model.starNum]];
   
    _photoContainerView.picPathStringsArray = model.urlArray;
    _photoContainerView.sd_layout.topSpaceToView(@[_contentLabel],model.urlArray.count?10:0);
}

@end
