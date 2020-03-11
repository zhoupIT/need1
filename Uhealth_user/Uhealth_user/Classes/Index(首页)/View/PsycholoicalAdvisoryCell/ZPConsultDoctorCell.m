//
//  ZPConsultDoctorCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPConsultDoctorCell.h"

#import "ZPConsultDoctorModel.h"

@interface ZPConsultDoctorCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *cabinNameLabel;
@property (nonatomic,strong) UILabel *consultTypeLabel;
@property (nonatomic,strong) UIButton *consultButton;

@property (nonatomic,strong) UIView *lineView;
@end
@implementation ZPConsultDoctorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    self.iconView = [UIImageView new];
    self.iconView.layer.cornerRadius = 55*0.5;
    self.iconView.layer.masksToBounds = YES;
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = RGB_74_74_74;
    self.nameLabel.font= [UIFont systemFontOfSize:15];
    self.nameLabel.text = @"--  医生";
    
    self.cabinNameLabel = [UILabel new];
    self.cabinNameLabel.textColor = RGB(153, 153, 153);
    self.cabinNameLabel.font = [UIFont systemFontOfSize:12];
    self.cabinNameLabel.text = @"--";
    
    self.consultTypeLabel = [UILabel new];
    self.consultTypeLabel.textColor = RGB_78_178_255;
    self.consultTypeLabel.font = [UIFont systemFontOfSize:12];
    self.consultTypeLabel.text = @"--";
    
    self.consultButton = [UIButton new];
    [self.consultButton setTitle:@"健康咨询" forState:UIControlStateNormal];
    [self.consultButton setTitleColor:RGB_78_178_255 forState:UIControlStateNormal];
    self.consultButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.consultButton.layer.cornerRadius = 5;
    self.consultButton.layer.masksToBounds = YES;
    self.consultButton.layer.borderColor =RGB_78_178_255.CGColor;
    self.consultButton.layer.borderWidth = 0.5;
    [self.consultButton setBackgroundColor:RGB(232, 245, 255)];
    [self.consultButton addTarget:self action:@selector(consult) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = RGB_242_242_242;
    [contentView sd_addSubviews:@[self.iconView,self.nameLabel,self.cabinNameLabel, self.consultTypeLabel,self.consultButton,self.lineView]];
    
    self.iconView.sd_layout
    .topSpaceToView(contentView, 15)
    .widthIs(55)
    .heightIs(55)
    .leftSpaceToView(contentView, 15);
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    
    self.consultButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .widthIs(80)
    .heightIs(33)
    .topSpaceToView(contentView, 24);
    
    self.nameLabel.sd_layout
    .topSpaceToView(contentView, 20)
    .heightIs(15)
    .leftSpaceToView(self.iconView, 17)
    .rightSpaceToView(self.consultButton, 5);
    
    self.cabinNameLabel.sd_layout
    .leftSpaceToView(self.iconView, 17)
    .heightIs(12)
    .rightSpaceToView(self.consultButton, 5)
    .topSpaceToView(self.nameLabel, 8);
    
    self.consultTypeLabel.sd_layout
    .topSpaceToView(self.cabinNameLabel, 8)
    .leftSpaceToView(self.iconView, 17)
    .rightSpaceToView(contentView, 15);
    self.consultTypeLabel.numberOfLines = 2;
    [self.consultTypeLabel setMaxNumberOfLinesToShow:2];
    
    self.lineView.sd_layout
    .rightSpaceToView(contentView, 0)
    .heightIs(8)
    .bottomEqualToView(contentView)
    .leftSpaceToView(contentView, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modalInfo)];
    [self.iconView addGestureRecognizer:tap];
    self.iconView.userInteractionEnabled = YES;
}

- (void)setModel:(ZPConsultDoctorModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"psyAdvisory_doctorMale_icon"]];
    if (self.consultDoctorType == ZPConsultDoctorTypeConsulting) {
        //心理咨询
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@  医生",model.name];
    }
    
    self.cabinNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.doctorTitle,model.expertiseField];
    self.consultTypeLabel.text = [NSString stringWithFormat:@"擅长:%@",model.researchDirectionSynopsis];
    
    if ([model.doctorType.name isEqualToString:@"PSYCHOLOGIST"]) {
        [self.consultButton setTitle:@"心理咨询" forState:UIControlStateNormal];
    } else {
        [self.consultButton setTitle:@"健康咨询" forState:UIControlStateNormal];
    }
    
}

- (void)modalInfo {
    if (self.modalInfoBlock) {
        self.modalInfoBlock(self.model);
    }
}

//咨询
- (void)consult {
    if (self.consultBlock) {
        self.consultBlock();
    }
}

- (void)setConsultDoctorType:(ZPConsultDoctorType *)consultDoctorType {
    _consultDoctorType = consultDoctorType;
}

@end
