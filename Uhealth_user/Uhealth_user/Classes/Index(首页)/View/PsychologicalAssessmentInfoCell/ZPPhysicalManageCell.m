//
//  ZPPhysicalManageCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/7/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPhysicalManageCell.h"

@interface ZPPhysicalManageCell()
{
    UIImageView *_iconView;
    UILabel *_tipLabel1;
    UILabel *_tipLabel2;
    UIButton *_startButton;
}
@end
@implementation ZPPhysicalManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *contentView = self.contentView;
    
    _iconView = [UIImageView new];
    _tipLabel1 = [UILabel new];
    _tipLabel2 = [UILabel new];
    _startButton = [UIButton new];
    [contentView sd_addSubviews:@[_iconView,_tipLabel1,_tipLabel2,_startButton]];
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 0)
    .heightIs(ZPHeight(135))
    .autoWidthRatio(1);
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
    
    _tipLabel1.sd_layout
    .topSpaceToView(contentView, ZPHeight(36))
    .rightSpaceToView(contentView, 16)
    .heightIs(14)
    .widthIs(120);
    _tipLabel1.textAlignment = NSTextAlignmentCenter;
    _tipLabel1.font = [UIFont fontWithName:ZPPFSCMedium size:14];
    _tipLabel1.textColor = ZPMyOrderDetailFontColor;
    _tipLabel1.textAlignment = NSTextAlignmentCenter;
    
    _tipLabel2.sd_layout
    .topSpaceToView(_tipLabel1, 10)
    .centerXEqualToView(_tipLabel1)
    .heightIs(14)
    .widthIs(120);
    _tipLabel2.font = [UIFont fontWithName:ZPPFSCMedium size:14];
    _tipLabel2.textColor = ZPMyOrderDetailFontColor;
    _tipLabel2.textAlignment = NSTextAlignmentCenter;
    
    _startButton.sd_layout
    .topSpaceToView(_tipLabel2, 15)
    .heightIs(14)
    .widthIs(70)
    .rightSpaceToView(contentView, 37);
    [_startButton setTitleColor:ZPMyOrderDetailValueFontColor forState:UIControlStateNormal];
    _startButton.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    [_startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startAction:(UIButton *)btn {
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    _iconView.image = [UIImage imageNamed:dict[@"iconName"]];
    _tipLabel1.text = dict[@"tip1Name"];
    _tipLabel2.text = dict[@"tip2Name"];
    [_startButton setTitle:dict[@"buttonName"] forState:UIControlStateNormal];
}
@end
