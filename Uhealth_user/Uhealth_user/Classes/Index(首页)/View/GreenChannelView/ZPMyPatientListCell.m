//
//  ZPMyPatientListCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyPatientListCell.h"
#import "ZPPatientListModel.h"


@interface ZPMyPatientListCell()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *typeTextLabel;

@property (nonatomic,strong) UIButton *editButton;

@property (nonatomic,strong) UIView *grayLineView;
@end
@implementation ZPMyPatientListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    
    
    self.nameLabel = [UILabel new];
    self.phoneLabel = [UILabel new];
    self.typeLabel = [UILabel new];
    self.typeTextLabel = [UILabel new];
    
    self.editButton = [UIButton new];
    self.grayLineView = [UIView new];
    [contentView sd_addSubviews:@[self.nameLabel,self.phoneLabel,self.typeTextLabel,self.typeLabel,self.editButton,self.grayLineView]];
    
    self.phoneLabel.sd_layout
    .leftSpaceToView(contentView, 101)
    .heightIs(14)
    .topSpaceToView(contentView, 14)
    .rightSpaceToView(contentView, 15);
    self.phoneLabel.font  = [UIFont systemFontOfSize:14];
    self.phoneLabel.textColor = ZPMyOrderDetailFontColor;
    
    self.nameLabel.sd_layout
    .topSpaceToView(contentView, 14)
    .heightIs(13)
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(self.phoneLabel, 5);
    self.nameLabel.textColor = ZPMyOrderDetailFontColor;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    self.typeTextLabel.sd_layout
    .leftEqualToView(self.phoneLabel)
    .topSpaceToView(self.nameLabel, 16)
    .heightIs(13)
    .rightSpaceToView(contentView, 15);
    self.typeTextLabel.textColor = RGB(153, 153, 153);
    self.typeTextLabel.font = [UIFont systemFontOfSize:13];
    
    self.typeLabel.sd_layout
    .topSpaceToView(self.nameLabel, 16)
    .leftEqualToView(self.nameLabel)
    .heightIs(13)
    .rightSpaceToView(self.typeTextLabel, 5);
    self.typeLabel.textColor = RGB(153, 153, 153);
    self.typeLabel.font = [UIFont systemFontOfSize:13];
    
    self.editButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(20)
    .widthIs(20)
    .topSpaceToView(contentView, 14);
    [self.editButton setImage:[UIImage imageNamed:@"common_edit_icon"] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.grayLineView.sd_layout
    .leftSpaceToView(contentView, 0)
    .rightEqualToView(contentView)
    .heightIs(1)
    .topSpaceToView(self.typeLabel, 15);
    self.grayLineView.backgroundColor = RGB_242_242_242;
    
    
    [self setupAutoHeightWithBottomView:self.grayLineView bottomMargin:0];
}

- (void)setModel:(ZPPatientListModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.telephone;
    self.typeLabel.text = model.idCardType.text;
    self.typeTextLabel.text = model.idCardNo;
}

- (void)selectAction:(UIButton *)btn {
    if (self.selctActionBlock) {
        self.selctActionBlock(btn);
    }
}


- (void)editEvent:(UIButton *)btn {
    if (self.editBlock) {
        self.editBlock(btn);
    }
}

@end
