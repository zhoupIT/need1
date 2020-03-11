//
//  ZPHealthNewsOneImageCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHealthNewsOneImageCell.h"
#import "ZPHealthNewsModel.h"
#import "SDWeiXinPhotoContainerView.h"
@interface ZPHealthNewsOneImageCell()
{
    UILabel *_titleLabel;
    UIButton *_tagButton;
    UIImageView *_iconView;
    UIImageView *_pageViewImageView;
    UILabel *_pageViewLabel;
}
@end
@implementation ZPHealthNewsOneImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    
    UIView *contentView = self.contentView;
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    
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
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_titleLabel setMaxNumberOfLinesToShow:2];
    
    
    _tagButton = [UIButton new];
    _tagButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:_tagButton];
    _tagButton.sd_layout
    .bottomEqualToView(_iconView)
    .leftSpaceToView(contentView, 15)
    .heightIs(13)
    .widthIs(47);
    
    _pageViewLabel = [UILabel new];
    [contentView addSubview:_pageViewLabel];
    _pageViewLabel.sd_layout
    .centerYEqualToView(_tagButton)
    .rightSpaceToView(_iconView, 15)
    .heightIs(10);
    [_pageViewLabel setSingleLineAutoResizeWithMaxWidth:100];
    _pageViewLabel.textColor = ZPMyOrderDeleteBorderColor;
    _pageViewLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    
    _pageViewImageView = [UIImageView new];
    [contentView addSubview:_pageViewImageView];
    _pageViewImageView.sd_layout
    .centerYEqualToView(_tagButton)
    .rightSpaceToView(_pageViewLabel, 5)
    .heightIs(20)
    .widthIs(20);
    _pageViewImageView.image = [UIImage imageNamed:@"healthNews_eye_icon"];
    
    [self setupAutoHeightWithBottomViewsArray:@[_tagButton,_titleLabel] bottomMargin:10];
}

- (void)setModel:(ZPHealthNewsModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.titleImgList.firstObject] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    
    switch (model.label.code) {
        case 1:
        {
            [_tagButton setTitle:@"儿童" forState:UIControlStateNormal];
            [_tagButton setTitleColor:RGB(255,165,165) forState:UIControlStateNormal];
            [_tagButton setImage:[UIImage imageNamed:@"healthNews_child"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_tagButton setTitle:@"孕妇" forState:UIControlStateNormal];
            [_tagButton setTitleColor:RGB(254,183,73) forState:UIControlStateNormal];
            [_tagButton setImage:[UIImage imageNamed:@"healthNews_pregnant"] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [_tagButton setTitle:@"老人" forState:UIControlStateNormal];
            [_tagButton setTitleColor:RGB(189,157,255) forState:UIControlStateNormal];
            [_tagButton setImage:[UIImage imageNamed:@"healthNews_older"] forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [_tagButton setTitle:@"女性" forState:UIControlStateNormal];
            [_tagButton setTitleColor:RGB(252,111,180) forState:UIControlStateNormal];
            [_tagButton setImage:[UIImage imageNamed:@"healthNews_female"] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [_tagButton setTitle:@"心理" forState:UIControlStateNormal];
            [_tagButton setTitleColor:RGB(129,232,57) forState:UIControlStateNormal];
            [_tagButton setImage:[UIImage imageNamed:@"healthNews_protect"] forState:UIControlStateNormal];
        }
            break;
        case 6:
        {
            [_tagButton setTitle:@"综合" forState:UIControlStateNormal];
            [_tagButton setTitleColor:RGB(90,174,255) forState:UIControlStateNormal];
            [_tagButton setImage:[UIImage imageNamed:@"healthNews_all"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    _pageViewLabel.text = model.pageviews;
}

@end
