//
//  ZPIndexCenterCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPIndexCenterCell.h"

@interface ZPIndexCenterCell()
{
    UILabel *_WCenterLabel;//微生态标题
    UIButton *_WCenterButton;//微生态
}
@end
@implementation ZPIndexCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    _WCenterLabel = [UILabel new];
    _WCenterButton = [UIButton new];
    [contentView sd_addSubviews:@[_WCenterLabel,_WCenterButton]];
    _WCenterLabel.sd_layout
    .topSpaceToView(contentView, ZPHeight(15))
    .leftSpaceToView(contentView, ZPWidth(15))
    .rightSpaceToView(contentView, ZPWidth(15))
    .autoHeightRatio(0);
    _WCenterLabel.text = @"微生态中心";
    _WCenterLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(15)];
    _WCenterLabel.textColor = RGB_74_74_74;
    
    _WCenterButton.sd_layout
    .leftSpaceToView(contentView, ZPWidth(15))
    .topSpaceToView(_WCenterLabel, ZPHeight(15))
    .bottomSpaceToView(contentView, ZPHeight(15))
    .rightSpaceToView(contentView, ZPWidth(15));
    _WCenterButton.layer.cornerRadius = 10;
    _WCenterButton.layer.masksToBounds = YES;
    [_WCenterButton addTarget:self action:@selector(didClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [_WCenterButton setBackgroundColor:[UIColor whiteColor]];
    [_WCenterButton setImage:[UIImage imageNamed:@"index_center_icon"] forState:UIControlStateNormal];
    [_WCenterButton setImage:[UIImage imageNamed:@"index_center_icon"] forState:UIControlStateHighlighted];
}

- (void)didClickEvent {
    if (self.didClickBlock) {
        self.didClickBlock();
    }
}

@end
