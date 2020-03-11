//
//  ZPGreenPathHospitalCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathHospitalCell.h"
#import "ZPHospitalModel.h"
@interface ZPGreenPathHospitalCell()
{
    UILabel *_hospitalNameLable;
    UIButton *_selBtn;
}
@end
@implementation ZPGreenPathHospitalCell

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
    _hospitalNameLable = [UILabel new];
    _selBtn = [UIButton new];
    [contentView sd_addSubviews:@[_hospitalNameLable,_selBtn]];
    _selBtn.sd_layout
    .rightSpaceToView(contentView, ZPWidth(16))
    .centerYEqualToView(contentView)
    .widthIs(ZPWidth(16))
    .heightIs(ZPWidth(16));
    [_selBtn setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [_selBtn addTarget:self action:@selector(selHospitalAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _hospitalNameLable.sd_layout
    .leftSpaceToView(contentView, ZPWidth(15))
    .topSpaceToView(contentView, ZPHeight(18))
    .rightSpaceToView(_selBtn, ZPWidth(5))
    .autoHeightRatio(0);
    _hospitalNameLable.textColor = ZPMyOrderDetailFontColor;
    _hospitalNameLable.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    
    [self setupAutoHeightWithBottomView:_hospitalNameLable bottomMargin:ZPHeight(18)];
    
}

- (void)selHospitalAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.selHospitalBlock) {
        self.selHospitalBlock(btn.selected);
    }
}

- (void)setModel:(ZPHospitalModel *)model {
    _model = model;
    _hospitalNameLable.text = model.hospitalName;
    _selBtn.selected = model.isSel;
}
@end
