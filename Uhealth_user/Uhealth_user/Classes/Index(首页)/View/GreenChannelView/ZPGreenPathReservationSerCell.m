//
//  ZPGreenPathReservationSerCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathReservationSerCell.h"
#import "ZPMedicalCityServiceModel.h"
@interface ZPGreenPathReservationSerCell()
{
    //标题
    UILabel *_titleLabel;
    //选择按钮
    UIButton *_selBtn;
    //图片介绍
    UIImageView *_infoIconView;
}
@end
@implementation ZPGreenPathReservationSerCell

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
    _titleLabel = [UILabel new];
    _selBtn = [UIButton new];
    _infoIconView = [UIImageView new];
    [contentView sd_addSubviews:@[_titleLabel,_selBtn,_infoIconView]];
    _selBtn.sd_layout
    .rightSpaceToView(contentView, ZPWidth(16))
    .topSpaceToView(contentView, ZPHeight(13))
    .heightIs(ZPWidth(16))
    .widthIs(ZPWidth(16));
    [_selBtn setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [_selBtn addTarget:self action:@selector(selServiceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel.sd_layout
    .topSpaceToView(contentView, ZPHeight(16))
    .leftSpaceToView(contentView, ZPWidth(17))
    .rightSpaceToView(_selBtn, ZPWidth(5))
    .autoHeightRatio(0);
    _titleLabel.textColor = RGB_74_74_74;
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    
    _infoIconView.sd_layout
    .topSpaceToView(_titleLabel, ZPHeight(18))
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0);
    
}

- (void)setModel:(ZPMedicalCityServiceModel *)model {
    _model = model;
    _titleLabel.text = model.serviceTypeName;
    
    [_infoIconView sd_setImageWithURL:[NSURL URLWithString:model.serviceTypeInformationImg.url] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    if (model.isExpand) {
        if (model.serviceTypeInformationImg != nil && ![model.serviceTypeInformationImg isKindOfClass:[NSNull class]]) {
            CGFloat w = kSCREEN_WIDTH;
            CGFloat height = 0;
            if ( w <= model.serviceTypeInformationImg.width) {
                height = (w / model.serviceTypeInformationImg.width) * model.serviceTypeInformationImg.height;
            } else{
                height = model.serviceTypeInformationImg.height;
            }
            _infoIconView.sd_layout.heightIs(height);
        } else {
            _infoIconView.sd_layout.heightIs(0);
        }
    } else {
        _infoIconView.sd_layout.heightIs(0);
    }
    _selBtn.selected = model.isSel;
    [self setupAutoHeightWithBottomViewsArray:@[_infoIconView] bottomMargin:0];
}

- (void)selServiceAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.selServiceBlock) {
        self.selServiceBlock(btn.selected);
    }
}

@end
