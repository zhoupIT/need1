//
//  ZPAuthorityCenterCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAuthorityCenterCell.h"
#import "ZPChannelDoctorModel.h"
@interface ZPAuthorityCenterCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *postLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIImageView *tipIconView;
@property (nonatomic,strong) UILabel *tipLabel;
@end
@implementation ZPAuthorityCenterCell

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
    self.nameLabel = [UILabel new];
    self.postLabel = [UILabel new];
    self.descLabel = [UILabel new];
    self.tipIconView = [UIImageView new];
    self.tipLabel = [UILabel new];
    [contentView sd_addSubviews:@[self.iconView,self.nameLabel,self.postLabel,self.descLabel,self.tipIconView]];
    
    self.iconView.sd_cornerRadius = @25;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 15)
    .widthIs(50)
    .heightIs(50);

    self.nameLabel.textColor = ZPMyOrderDetailFontColor;
    self.nameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:15];
    self.nameLabel.sd_layout
    .leftSpaceToView(self.iconView, 10)
    .topEqualToView(self.iconView)
    .heightIs(15);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.postLabel.textColor = RGB(153, 153, 153);
    self.postLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.postLabel.sd_layout
    .topSpaceToView(self.nameLabel, 10)
    .leftSpaceToView(self.iconView, 10)
    .rightSpaceToView(contentView, 15)
    .autoHeightRatio(0);
    
    self.descLabel.textColor = ZPMyOrderDetailValueFontColor;
    self.descLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.descLabel.sd_layout
    .topSpaceToView(self.postLabel, 10)
    .leftSpaceToView(self.iconView, 10)
    .rightSpaceToView(contentView, 15)
    .autoHeightRatio(0);
    [self.descLabel setMaxNumberOfLinesToShow:2];
    
    self.tipIconView.sd_layout
    .centerYEqualToView(self.nameLabel)
    .heightIs(21)
    .leftSpaceToView(self.nameLabel, 10);
    self.tipIconView.image = [UIImage imageNamed:@"lecture_tip_icon"];
    [self.tipIconView addSubview:self.tipLabel];
    self.tipLabel.sd_layout
    .leftSpaceToView(self.tipIconView, 14)
    .heightIs(12)
    .centerYEqualToView(self.tipIconView);
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    
    [self setupAutoHeightWithBottomViewsArray:@[self.iconView,self.descLabel] bottomMargin:15];
}

- (void)setModel:(ZPChannelDoctorModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.doctorHeadimg] placeholderImage:[UIImage imageNamed:@"placeholder_cart"]];
    self.nameLabel.text = model.doctorName;
    self.postLabel.text = model.doctorTitle;
    self.descLabel.text = model.doctorIntroduction;
    
    if (model.lectureStatus) {
        CGRect rect = [model.lectureStatus.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:ZPPFSCRegular size:12]}
                                                             context:nil];
        
        self.tipLabel.sd_layout.widthIs(rect.size.width);
        self.tipIconView.sd_layout.widthIs(rect.size.width+21);
        self.tipLabel.text = model.lectureStatus.text;
        self.backgroundColor = RGB(246, 252, 255);
    } else {
        self.tipIconView.sd_layout.widthIs(0);
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
