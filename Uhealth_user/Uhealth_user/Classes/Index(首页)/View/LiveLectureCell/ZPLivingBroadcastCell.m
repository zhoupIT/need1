//
//  ZPLivingBroadcastCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLivingBroadcastCell.h"
#import "ZPLectureModel.h"

@interface ZPLivingBroadcastCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *playView;
@end
@implementation ZPLivingBroadcastCell

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
    self.iconView = [UIImageView new];
    self.titleLabel = [UILabel new];
    self.timeLabel = [UILabel new];
    [contentView sd_addSubviews:@[self.iconView,self.titleLabel,self.timeLabel]];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    self.iconView.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 15)
    .widthIs(150)
    .heightIs(100);
    
    self.titleLabel.textColor = ZPMyOrderDetailFontColor;
    self.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:15];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.iconView, 14)
    .topEqualToView(self.iconView)
    .rightSpaceToView(contentView, 15)
    .autoHeightRatio(0);
    [self.titleLabel setMaxNumberOfLinesToShow:2];
    
    self.timeLabel.textColor = ZPMyOrderDeleteBorderColor;
    self.timeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.timeLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .leftSpaceToView(self.iconView, 14)
    .bottomEqualToView(self.iconView)
    .heightIs(13);
//    [self.timeLabel setMaxNumberOfLinesToShow:1];
    
    self.playView = [UIImageView new];
    self.playView.image = [UIImage imageNamed:@"index_list_play"];
    [self.iconView addSubview:self.playView];
    self.playView.sd_layout
    .centerXEqualToView(self.iconView)
    .centerYEqualToView(self.iconView)
    .widthIs(45)
    .heightIs(45);
    
    [self setupAutoHeightWithBottomView:self.iconView bottomMargin:15];
}

- (void)setModel:(ZPLectureModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.lectureImg] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    self.titleLabel.text = model.lectureName;
    self.timeLabel.text = model.lectureDate;
}

@end
