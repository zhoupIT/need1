//
//  ZPOrderDetailTopCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPOrderDetailTopCell.h"
#import "ZPCommodity.h"
@interface ZPOrderDetailTopCell()
//@property (strong, nonatomic) IBOutlet UILabel *preferpriceButton;
//@property (strong, nonatomic) IBOutlet UILabel *namelabel;
//@property (strong, nonatomic) IBOutlet UILabel *presentPricelabel;
//
//@property (strong, nonatomic) IBOutlet UILabel *originalPricelabel;
/** 商品名称 */
@property (nonatomic,strong) UILabel *namelabel;
/** 价格类型 */
@property (nonatomic,strong) UILabel *preferpriceButton;
/** 现价 */
@property (nonatomic,strong) UILabel *presentPricelabel;
/** 原价 */
@property (nonatomic,strong) UILabel *originalPricelabel;
/** 邮寄方式 */
@property (nonatomic,strong) UILabel *mailingMethodLabel;
/** 发货地 */
@property (nonatomic,strong) UILabel *dispatchLabel;

@end

@implementation ZPOrderDetailTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    
    UIView *contentView = self.contentView;
    
    self.namelabel = [UILabel new];
    self.preferpriceButton = [UILabel new];
    self.originalPricelabel = [UILabel new];
    self.presentPricelabel = [UILabel new];
    self.mailingMethodLabel = [UILabel new];
    self.dispatchLabel = [UILabel new];
    [self.contentView sd_addSubviews:@[self.namelabel,self.preferpriceButton,self.originalPricelabel,self.presentPricelabel,self.mailingMethodLabel,self.dispatchLabel]];
    self.namelabel.sd_layout
    .topSpaceToView(contentView, ZPHeight(15))
    .leftSpaceToView(contentView, ZPWidth(15))
    .rightSpaceToView(contentView, ZPWidth(15))
    .autoHeightRatio(0);
    self.namelabel.textColor = RGB_74_74_74;
    self.namelabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    
    self.preferpriceButton.sd_layout
    .topSpaceToView(self.namelabel, ZPHeight(15))
    .widthIs(ZPWidth(50))
    .heightIs(ZPHeight(22))
    .leftSpaceToView(contentView, ZPWidth(15));
    self.preferpriceButton.layer.cornerRadius = 5;
    self.preferpriceButton.layer.masksToBounds = YES;
    self.preferpriceButton.layer.borderColor = ZPMyOrderBorderColor.CGColor;
    self.preferpriceButton.layer.borderWidth = 1;
    self.preferpriceButton.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    self.preferpriceButton.textColor = ZPMyOrderBorderColor;
    self.preferpriceButton.text = @"优选价";
    self.preferpriceButton.textAlignment = NSTextAlignmentCenter;
    
    self.presentPricelabel.sd_layout
    .leftSpaceToView(self.preferpriceButton, ZPWidth(7))
    .centerYEqualToView(self.preferpriceButton)
    .heightIs(ZPHeight(18));
    [self.presentPricelabel setSingleLineAutoResizeWithMaxWidth:ZPWidth(100)];
    self.presentPricelabel.font = [UIFont fontWithName:ZPPFSCLight size:ZPFontSize(17)];
    self.presentPricelabel.textColor = ZPMyOrderBorderColor;
    self.presentPricelabel.text = @"¥0";
    
    self.originalPricelabel.sd_layout
    .bottomEqualToView(self.presentPricelabel)
    .leftSpaceToView(self.presentPricelabel, ZPWidth(8))
    .heightIs(ZPHeight(14));
    [self.originalPricelabel setSingleLineAutoResizeWithMaxWidth:100];
    self.originalPricelabel.font = [UIFont fontWithName:ZPPFSCLight size:ZPFontSize(12)];
    self.originalPricelabel.textColor = RGB(204, 204, 204);
    self.originalPricelabel.text = @"0";
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.originalPricelabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.originalPricelabel.attributedText = newPrice;
    
    self.mailingMethodLabel.sd_layout
    .topSpaceToView(self.preferpriceButton, ZPHeight(10))
    .leftEqualToView(self.preferpriceButton)
    .widthIs((kSCREEN_WIDTH-ZPHeight(10)*2)*0.5)
    .autoHeightRatio(0);
    self.mailingMethodLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    self.mailingMethodLabel.textColor = RGB(204, 204, 204);
   
    self.dispatchLabel.sd_layout
    .rightSpaceToView(contentView, ZPWidth(15))
    .topSpaceToView(self.preferpriceButton, ZPHeight(10))
    .widthIs((kSCREEN_WIDTH-ZPHeight(10)*2)*0.5)
    .autoHeightRatio(0);
    self.dispatchLabel.text = @"上海";
    self.dispatchLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    self.dispatchLabel.textAlignment = NSTextAlignmentRight;
    self.dispatchLabel.textColor = RGB(204, 204, 204);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.mailingMethodLabel,self.dispatchLabel] bottomMargin:ZPHeight(12)];
}

- (void)setModel:(ZPCommodity *)model {
    _model = model;
    self.namelabel.text = model.name;
    self.presentPricelabel.text = [NSString stringWithFormat:@"￥%@",model.presentPrice];
    self.originalPricelabel.text = [NSString stringWithFormat:@"%@",model.originalPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.originalPricelabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.originalPricelabel.attributedText = newPrice;
    self.preferpriceButton.text = model.priceName;
    self.mailingMethodLabel.text = model.extend1;
}

@end
