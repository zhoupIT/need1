//
//  ZPGreenPathCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathCell.h"
@interface ZPGreenPathCell()
{
    UILabel *_titleLabel;
    UIButton *_titleBtn;
}
@end
@implementation ZPGreenPathCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    _titleLabel = [UILabel new];
    _titleBtn = [UIButton new];
    [contentView sd_addSubviews:@[_titleLabel,_titleBtn]];
    
    _titleLabel.textColor = RGB_74_74_74;
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    _titleLabel.sd_layout
    .centerYEqualToView(contentView)
    .leftSpaceToView(contentView, ZPWidth(16));
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(13)];
    [_titleBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn setBackgroundColor:RGB(21, 223, 178)];
    _titleBtn.layer.cornerRadius = 5;
    _titleBtn.layer.masksToBounds = YES;
    _titleBtn.sd_layout
    .rightSpaceToView(contentView, ZPWidth(15))
    .centerYEqualToView(contentView)
    .heightIs(ZPHeight(30))
    .widthIs(ZPWidth(95));
    _titleBtn.imageView.sd_layout
    .widthIs(ZPWidth(20))
    .heightIs(ZPWidth(20));
    _titleBtn.titleLabel.sd_layout
    .leftSpaceToView(_titleBtn.imageView, 5)
    .rightSpaceToView(_titleBtn, 0);
}

- (void)setTitleBtnImgStr:(NSString *)titleBtnImgStr {
    _titleBtnImgStr = titleBtnImgStr;
    _titleLabel.text = self.titleStr;
    [_titleBtn setTitle:self.titleBtnStr forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:titleBtnImgStr] forState:UIControlStateNormal];
}

- (void)btnClickAction:(UIButton *)btn {
    if (self.btnDidClickBlock) {
        self.btnDidClickBlock(btn);
    }
}


@end
