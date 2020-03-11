//
//  ZPPatientListCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPatientListCell.h"
#import "ZPPatientListModel.h"


@interface ZPPatientListCell()
@property (nonatomic,strong) UIButton *selBtn;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *typeTextLabel;

@property (nonatomic,strong) UIButton *detailDataButton;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *grayLineView;
@end
@implementation ZPPatientListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    self.selBtn = [UIButton new];
    self.nameLabel = [UILabel new];
    self.phoneLabel = [UILabel new];
    self.typeLabel = [UILabel new];
    self.typeTextLabel = [UILabel new];
    self.detailDataButton = [UIButton new];
    self.editButton = [UIButton new];
    self.deleteButton = [UIButton new];
    self.lineView = [UIView new];
    self.grayLineView = [UIView new];
    [contentView sd_addSubviews:@[self.selBtn,self.nameLabel,self.phoneLabel,self.typeTextLabel,self.typeLabel,self.detailDataButton,self.editButton,self.deleteButton,self.lineView,self.grayLineView]];
    
    self.selBtn.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 14)
    .heightIs(20)
    .widthIs(20);
    [self.selBtn setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [self.selBtn setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [self.selBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneLabel.sd_layout
    .leftSpaceToView(self.selBtn, 101)
    .heightIs(14)
    .centerYEqualToView(self.selBtn)
    .rightSpaceToView(contentView, 15);
    self.phoneLabel.font  = [UIFont systemFontOfSize:14];
    self.phoneLabel.textColor = ZPMyOrderDetailFontColor;
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.selBtn)
    .heightIs(13)
    .leftSpaceToView(self.selBtn, 11)
    .rightSpaceToView(self.phoneLabel, 5);
    self.nameLabel.textColor = ZPMyOrderDetailFontColor;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    self.typeTextLabel.sd_layout
    .leftEqualToView(self.phoneLabel)
    .topSpaceToView(self.selBtn, 16)
    .heightIs(13)
    .rightSpaceToView(contentView, 15);
    self.typeTextLabel.textColor = RGB(153, 153, 153);
    self.typeTextLabel.font = [UIFont systemFontOfSize:13];
    
    self.typeLabel.sd_layout
    .topSpaceToView(self.selBtn, 16)
    .leftEqualToView(self.nameLabel)
    .heightIs(13)
    .rightSpaceToView(self.typeTextLabel, 5);
    self.typeLabel.textColor = RGB(153, 153, 153);
    self.typeLabel.font = [UIFont systemFontOfSize:13];
    
    self.editButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(18)
    .widthIs(18)
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
    self.selBtn.selected = model.isSel;
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
