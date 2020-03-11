//
//  ZPShopMallCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/10/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPShopMallCell.h"
#import "ZPCommodity.h"

@interface ZPShopMallCell()
@property (nonatomic,strong) UIImageView *orderImageView;
@property (nonatomic,strong) UILabel *orderNameLabel;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@end
@implementation ZPShopMallCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    _orderNameLabel = [UILabel new];
    _orderImageView = [UIImageView new];
    _tipLabel = [UILabel new];
    _priceLabel = [UILabel new];
    _originPriceLabel = [UILabel new];
    
    [self.contentView sd_addSubviews:@[_orderNameLabel,_orderImageView,_tipLabel,_priceLabel,_originPriceLabel]];
    
    _orderImageView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView, 0)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 0);
    _orderImageView.layer.masksToBounds = YES;
    _orderImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _orderNameLabel.sd_layout
    .topSpaceToView(_orderImageView, ZPHeight(15))
    .leftSpaceToView(self.contentView,ZPWidth(10))
    .rightSpaceToView(self.contentView, ZPWidth(10))
    .heightIs(ZPHeight(14));
    _orderNameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _orderNameLabel.textColor = ZPMyOrderDetailFontColor;
    _orderNameLabel.text = @"--";
    _orderNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _tipLabel.sd_layout
    .leftSpaceToView(self.contentView, ZPWidth(10))
    .widthIs(ZPWidth(45))
    .heightIs(ZPHeight(20))
    .topSpaceToView(_orderNameLabel, ZPHeight(15));
    _tipLabel.layer.cornerRadius = 5;
    _tipLabel.layer.masksToBounds = YES;
    _tipLabel.layer.borderColor = ZPMyOrderBorderColor.CGColor;
    _tipLabel.layer.borderWidth = 1;
    _tipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    _tipLabel.textColor = ZPMyOrderBorderColor;
    _tipLabel.text = @"优选价";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    
    _priceLabel.sd_layout
    .leftSpaceToView(_tipLabel, ZPWidth(7))
    .centerYEqualToView(_tipLabel)
    .heightIs(ZPHeight(18));
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:ZPWidth(100)];
    _priceLabel.font = [UIFont fontWithName:ZPPFSCLight size:ZPFontSize(17)];
    _priceLabel.textColor = ZPMyOrderBorderColor;
    _priceLabel.text = @"¥0";
    
    _originPriceLabel.sd_layout
    .bottomEqualToView(_priceLabel)
    .leftSpaceToView(_priceLabel, ZPWidth(8))
    .heightIs(ZPHeight(14));
    [_originPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    _originPriceLabel.font = [UIFont fontWithName:ZPPFSCLight size:ZPFontSize(12)];
    _originPriceLabel.textColor = RGB(204, 204, 204);
    _originPriceLabel.text = @"0";
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_originPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _originPriceLabel.attributedText = newPrice;
    
}

- (void)setModel:(ZPCommodity *)model {
    _model = model;
    _orderNameLabel.text = model.name;
    NSString *rule = [NSString stringWithFormat:@"%@",model.coverImage];
    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:rule] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.presentPrice];
    
    _originPriceLabel.text = [NSString stringWithFormat:@"%@",model.originalPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_originPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _originPriceLabel.attributedText = newPrice;
    _tipLabel.text = model.priceName;
    
}
@end
