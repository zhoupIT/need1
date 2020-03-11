//
//  ZPHealthNewsMoreImagesCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHealthNewsMoreImagesCell.h"
#import "ZPHealthNewsModel.h"
@interface ZPHealthNewsMoreImagesCell()
{
    UILabel *_titleLabel;
    UIButton *_tagButton;
    UIImageView *_iconView0;
    UIImageView *_iconView1;
    UIImageView *_iconView2;
    
    UILabel *_pageViewLabel;
    UIImageView *_pageViewImageView;
}
@end
@implementation ZPHealthNewsMoreImagesCell



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
    
    _pageViewLabel = [UILabel new];
    [contentView addSubview:_pageViewLabel];
    _pageViewLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 17)
    .heightIs(12);
    [_pageViewLabel setSingleLineAutoResizeWithMaxWidth:100];
    _pageViewLabel.textColor = ZPMyOrderDeleteBorderColor;
    _pageViewLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    
    _pageViewImageView = [UIImageView new];
    [contentView addSubview:_pageViewImageView];
    _pageViewImageView.sd_layout
    .centerYEqualToView(_pageViewLabel)
    .rightSpaceToView(_pageViewLabel, 5)
    .heightIs(20)
    .widthIs(20);
    _pageViewImageView.image = [UIImage imageNamed:@"healthNews_eye_icon"];
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    
    _tagButton = [UIButton new];
    _tagButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:_tagButton];
    
    
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(_pageViewImageView, 10)
    .heightIs(15)
    .topSpaceToView(contentView, 15);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
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

    
    _tagButton.sd_layout
    .topSpaceToView(_iconView0, 13)
    .leftSpaceToView(contentView, 15)
    .heightIs(13)
    .widthIs(47);
    
   
    
    [self setupAutoHeightWithBottomViewsArray:@[_tagButton,_titleLabel] bottomMargin:10];
}

- (void)setModel:(ZPHealthNewsModel *)model {
    _model = model;
    _pageViewLabel.text = model.pageviews;
    _titleLabel.text = model.title;
    
    [_iconView0 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[0]] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    [_iconView1 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[1]] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    [_iconView2 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[2]] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    
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
}
@end
