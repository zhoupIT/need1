//
//  ZPPayCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPayCell.h"
#import "ZPPayModel.h"
@interface ZPPayCell()
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UIButton *_selBtn;
}
@end
@implementation ZPPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAll];
    }
    return self;
}

- (void)initAll {
    UIView *contentView = self.contentView;
    _iconView = [UIImageView new];
    _titleLabel = [UILabel new];
    _selBtn = [UIButton new];
    
    [contentView sd_addSubviews:@[_iconView,_titleLabel,_selBtn]];
    _iconView.sd_layout
    .widthIs(27)
    .heightIs(27)
    .leftSpaceToView(contentView, 16)
    .centerYEqualToView(contentView);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconView, 15)
    .centerYEqualToView(contentView)
    .heightIs(14);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    
    _selBtn.sd_layout
    .rightSpaceToView(contentView, 15)
    .widthIs(16)
    .heightIs(16)
    .centerYEqualToView(contentView);
    [_selBtn setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [_selBtn addTarget:self action:@selector(selAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ZPPayModel *)model {
    _model = model;
    _iconView.image = [UIImage imageNamed:model.imageName];
    _titleLabel.text = model.title;
    _selBtn.selected = model.isSel;
}

- (void)selAction:(UIButton *)btn {
    if (self.selBlock) {
        self.selBlock(btn);
    }
}

@end
