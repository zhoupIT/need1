//
//  ZPNurseSubCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPNurseSubCell.h"
#import "ZPNurseModel.h"
@interface ZPNurseSubCell()
@property (nonatomic,strong) UIImageView *nurseImg;
@property (nonatomic,strong) UILabel *nurseNameLabel;
@property (nonatomic,strong) UILabel *nurseIntroductionLabel;
@end
@implementation ZPNurseSubCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *contentView = self.contentView;
    contentView.layer.cornerRadius = 10;
    contentView.layer.shadowColor = RGBA(44, 144, 206,0.57).CGColor;
    contentView.layer.shadowOpacity = 1.0f;
    contentView.layer.shadowOffset = CGSizeMake(0,0);
    contentView.layer.shadowRadius = 5;
    UIView *back = [UIView new];
    UILabel *tipLabel = [UILabel new];
    UIButton *contactbtn = [UIButton new];
    self.nurseImg = [[UIImageView alloc] init];
    self.nurseNameLabel = [UILabel new];
    self.nurseIntroductionLabel = [UILabel new];
    [contentView sd_addSubviews:@[back,tipLabel,contactbtn,self.nurseImg,self.nurseNameLabel,self.nurseIntroductionLabel]];
    
    back.sd_layout
    .leftSpaceToView(contentView, 10)
    .widthIs(ZPWidth(3))
    .heightIs(ZPHeight(17))
    .topSpaceToView(contentView, ZPHeight(17));
    back.backgroundColor = ZPMyOrderDetailValueFontColor;
    
    contactbtn.sd_layout
    .rightSpaceToView(contentView, 10)
    .widthIs(ZPWidth(91))
    .heightIs(ZPHeight(29))
    .centerYEqualToView(back);
    contactbtn.layer.cornerRadius = 5;
    contactbtn.layer.masksToBounds = YES;
    [contactbtn setBackgroundColor:RGB(90, 199, 255)];
    [contactbtn setTitle:@"立即咨询" forState:UIControlStateNormal];
    [contactbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contactbtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    [contactbtn setImage:[UIImage imageNamed:@"me_cabinphone_icon"] forState:UIControlStateNormal];
    [contactbtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:9];
    contactbtn.imageView.sd_layout
    .widthIs(ZPWidth(17))
    .heightIs(ZPWidth(17))
    .centerYEqualToView(contactbtn);
    [contactbtn addTarget:self action:@selector(contactEvent) forControlEvents:UIControlEventTouchUpInside];
    
    tipLabel.sd_layout
    .leftSpaceToView(back, 11)
    .rightSpaceToView(contactbtn, 5)
    .heightIs(ZPHeight(15))
    .centerYEqualToView(back);
    tipLabel.text = @"小屋护士简介";
    tipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    tipLabel.textColor = ZPMyOrderDetailFontColor;
    
    self.nurseImg.sd_layout
    .leftSpaceToView(contentView, ZPWidth(21))
    .topSpaceToView(tipLabel, ZPHeight(19))
    .widthIs(ZPHeight(80))
    .heightIs(ZPHeight(80));
    self.nurseImg.contentMode = UIViewContentModeScaleAspectFill;
    self.nurseImg.layer.masksToBounds = YES;
    self.nurseImg.layer.cornerRadius = ZPHeight(40);
    
    self.nurseNameLabel.sd_layout
    .leftSpaceToView(self.nurseImg, ZPWidth(22))
    .topSpaceToView(tipLabel, ZPHeight(20))
    .rightSpaceToView(contentView, ZPWidth(20))
    .autoHeightRatio(0);
    self.nurseNameLabel.textColor = ZPMyOrderDetailFontColor;
    self.nurseNameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    
    self.nurseIntroductionLabel.sd_layout
    .leftSpaceToView(self.nurseImg, ZPWidth(22))
    .topSpaceToView(self.nurseNameLabel, ZPHeight(13))
    .rightSpaceToView(contentView, ZPWidth(20))
    .autoHeightRatio(0);
    [self.nurseIntroductionLabel setMaxNumberOfLinesToShow:3];
    self.nurseIntroductionLabel.textColor = ZPMyOrderDetailValueFontColor;
    self.nurseIntroductionLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(13)];
}

- (void)setModel:(ZPNurseModel *)model {
    _model = model;
    self.nurseNameLabel.text = model.nurseName;
    self.nurseIntroductionLabel.text = [NSString stringWithFormat:@"咨询项目:%@",model.nurseIntroduction];
    [self.nurseImg sd_setImageWithURL:[NSURL URLWithString:model.nurseImg] placeholderImage:[UIImage imageNamed:@"placeholder_cart"]];
}

- (void)contactEvent {
    if (self.contactNurseBlock) {
        self.contactNurseBlock(self.model);
    }
}
@end
