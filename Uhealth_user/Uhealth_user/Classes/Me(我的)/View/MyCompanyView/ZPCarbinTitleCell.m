//
//  ZPCarbinTitleCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCarbinTitleCell.h"

@interface ZPCarbinTitleCell()
{
    UIImageView *_iconImg;
    UILabel *_titleLabel;
}
@end
@implementation ZPCarbinTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *contentView = self.contentView;
    _iconImg = [UIImageView new];
    _titleLabel = [UILabel new];
    [contentView sd_addSubviews:@[_iconImg,_titleLabel]];
    _iconImg.sd_layout
    .leftSpaceToView(contentView,16)
    .centerYEqualToView(contentView)
    .heightIs(ZPHeight(20))
    .widthIs(ZPWidth(20));
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconImg, 8)
    .rightSpaceToView(contentView, 16)
    .heightIs(ZPHeight(16))
    .centerYEqualToView(contentView);
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    _iconImg.image = [UIImage imageNamed:dict[@"icon"]];
    _titleLabel.text = dict[@"title"];
}
@end
