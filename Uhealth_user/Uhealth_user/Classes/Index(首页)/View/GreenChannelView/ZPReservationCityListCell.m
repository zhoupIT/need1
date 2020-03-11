//
//  ZPReservationCityListCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPReservationCityListCell.h"
#import "ZPReservationCityModel.h"
#import "ZPCityServicesModel.h"
@interface ZPReservationCityListCell()
{
    UILabel *_cityNameLabel;
    UIButton *_isSelButton;
}
@end
@implementation ZPReservationCityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *contentView = self.contentView;
    _cityNameLabel = [UILabel new];
    _isSelButton = [UIButton new];
    [contentView sd_addSubviews:@[_cityNameLabel,_isSelButton]];
    
    [_isSelButton setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [_isSelButton setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [_isSelButton addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    _isSelButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .widthIs(22)
    .heightIs(22)
    .centerYEqualToView(contentView);
    
    _cityNameLabel.textColor = RGB_74_74_74;
    _cityNameLabel.font = [UIFont systemFontOfSize:14];
    _cityNameLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .rightSpaceToView(_isSelButton, 5)
    .heightIs(14);
}

- (void)didSelect:(UIButton *)btn {
    if (self.didClickBlock) {
        self.didClickBlock(btn);
    }
}

- (void)setModel:(ZPReservationCityModel *)model {
    _model = model;
    _cityNameLabel.text = model.name;
    _isSelButton.selected = model.isSel;
}

- (void)setServicesModel:(ZPCityServicesModel *)servicesModel {
    _servicesModel = servicesModel;
    _cityNameLabel.text = servicesModel.serviceTypeName;
    _isSelButton.selected = servicesModel.isSel;
}
@end
