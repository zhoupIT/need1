//
//  ZPMyShoppingCarCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyShoppingCarCell.h"
#import "UIView+ZPView.h"
#import "PPNumberButton.h"
#import "ZPShoppingCartCommodityModel.h"
#import "ZPCommodity.h"
#import "ZPCommodityItemModel.h"
@interface ZPMyShoppingCarCell()
@property (nonatomic,strong) UIButton *isSelButton;
@property (nonatomic,strong) UIImageView *orderImageView;
@property (nonatomic,strong) UILabel *orderNameLabel;
@property (nonatomic,strong) UIView *eventView;
@property (nonatomic,strong) UILabel *serviceTypeLabel;
@property (nonatomic,strong) UILabel *nPriceLabel;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UIButton *reduceButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UITextField *numtextfield;
@property (nonatomic,strong) PPNumberButton *numButton;

@end
@implementation ZPMyShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    _isSelButton = [UIButton new];
    _orderImageView = [UIImageView new];
    _orderNameLabel = [UILabel new];
    _eventView = [UIView new];
    _serviceTypeLabel = [UILabel new];
    _nPriceLabel = [UILabel new];
    _oldPriceLabel = [UILabel new];
    _reduceButton = [UIButton new];
    _addButton = [UIButton new];
    _numtextfield = [UITextField new];
    _numButton = [PPNumberButton new];
    
    [contentView sd_addSubviews:@[_isSelButton,_orderImageView,_orderNameLabel,_eventView,_serviceTypeLabel,_nPriceLabel,_oldPriceLabel,_reduceButton,_addButton,_numtextfield,_numButton]];
    
    _isSelButton.sd_layout
    .leftSpaceToView(contentView, 15)
    .widthIs(20)
    .heightIs(20)
    .centerYEqualToView(contentView);
    [_isSelButton setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [_isSelButton setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [_isSelButton addTarget:self action:@selector(selOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _orderImageView.sd_layout
    .leftSpaceToView(_isSelButton, 8)
    .widthIs(ZPWidth(94))
    .heightIs(94)
    .centerYEqualToView(contentView);
    _orderImageView.layer.cornerRadius = 5;
    _orderImageView.layer.masksToBounds = YES;
    _orderImageView.image = [UIImage imageNamed:@"common_placeholder_icon"];
    _orderImageView.contentMode = UIViewContentModeScaleAspectFill;
    _orderImageView.clipsToBounds = YES;
    
    _orderNameLabel.sd_layout
    .leftSpaceToView(_orderImageView, 10)
    .rightSpaceToView(contentView, 15)
    .heightIs(14)
    .topEqualToView(_orderImageView);
    _orderNameLabel.font = [UIFont systemFontOfSize:14];
    _orderNameLabel.textColor = ZPMyOrderDetailFontColor;
    _orderNameLabel.text = @"头部理疗套餐";
    
    _eventView.sd_layout
    .leftSpaceToView(_orderImageView, 10)
    .rightSpaceToView(contentView, 15)
    .heightIs(18)
    .topSpaceToView(_orderNameLabel, 10);
    
    
    _serviceTypeLabel.sd_layout
    .topSpaceToView(_eventView, 10)
    .leftSpaceToView(_orderImageView, 10)
    .heightIs(12)
    .rightSpaceToView(contentView, 15);
    _serviceTypeLabel.font = [UIFont systemFontOfSize:12];
    _serviceTypeLabel.textColor = ZPMyOrderDeleteBorderColor;
    _serviceTypeLabel.text = @"服务类型 单次";
    
    _nPriceLabel.sd_layout
    .leftSpaceToView(_orderImageView, 10)
    .heightIs(15)
    .topSpaceToView(_serviceTypeLabel, 10);
    [_nPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    _nPriceLabel.textColor = ZPMyOrderBorderColor;
    _nPriceLabel.font = ZPFont(15);
    _nPriceLabel.text = @"¥88";
    
    _oldPriceLabel.sd_layout
    .leftSpaceToView(_nPriceLabel, 10)
    .bottomEqualToView(_nPriceLabel)
    .heightIs(13);
    [_oldPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    _oldPriceLabel.font = ZPFont(13);
    _oldPriceLabel.text = @"0";
    _oldPriceLabel.textColor = RGB(153, 153, 153);
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_oldPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _oldPriceLabel.attributedText = newPrice;
    
    
    _numButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(25)
    .widthIs(ZPWidth(96))
    .bottomSpaceToView(contentView, 12);
    // 开启抖动动画
    _numButton.shakeAnimation = NO;
    // 设置最小值
    _numButton.minValue = 1;
    // 设置输入框中的字体大小
    _numButton.inputFieldFont = 13;
    _numButton.increaseTitle = @"＋";
    _numButton.decreaseTitle = @"－";
    _numButton.currentNumber = 1;
     _numButton.borderColor = RGB(204, 204, 204);
    _numButton.longPressSpaceTime = CGFLOAT_MAX;
    __weak typeof(self) weakSelf = self;
    _numButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus){
        NSLog(@"%f %d",number,increaseStatus);
        if (weakSelf.refreshPriceBlock) {
            weakSelf.refreshPriceBlock(number);
        }
        
    };
}

- (void)selOrder:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.refreshViewBlock) {
        self.refreshViewBlock(btn.selected);
    }
}

- (void)addEvent {
    NSInteger num = [_numtextfield.text integerValue];
    num++;
    _numtextfield.text = [NSString stringWithFormat:@"%ld",num];
    if (self.refreshPriceBlock) {
        self.refreshPriceBlock(num);
    }
}

- (void)reduceEvent {
    NSInteger num = [_numtextfield.text integerValue];
    num--;
    if (num < 0) {
        return;
    }
    _numtextfield.text = [NSString stringWithFormat:@"%ld",num];
    if (self.refreshPriceBlock) {
        self.refreshPriceBlock(num);
    }
}


- (void)setModel:(ZPShoppingCartCommodityModel *)model {
    _model = model;
    /* 设置购物车里的属性显示 */
    ZPCommoditySpecificationsModel *specifications = model.commodity.specifications;
    ZPCommodityItemModel *commodityItemModel = specifications.commodityItem.firstObject;
//    if (!specifications.hasDefaultOption) {
        NSString *connectedStr = @"";
        for (NSString *key in commodityItemModel.attached.allKeys) {
            if (connectedStr.length) {
                connectedStr = [connectedStr stringByAppendingString:@";"];
            }
            NSString *str = [commodityItemModel.attached objectForKey:key];
            connectedStr = [connectedStr stringByAppendingString:str];
        }
        self.serviceTypeLabel.text = [NSString stringWithFormat:@"\"%@\"",connectedStr];
//    }
    _numButton.currentNumber = [model.commodityCount floatValue];
    _oldPriceLabel.text = commodityItemModel.originalPrice;
    _nPriceLabel.text = [NSString stringWithFormat:@"￥%@",commodityItemModel.presentPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_oldPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _oldPriceLabel.attributedText = newPrice;
    _orderNameLabel.text = model.commodity.name;
    //如果小项没图的话,就展示coverImg
    if (!commodityItemModel.img || !commodityItemModel.img.length) {
        [_orderImageView sd_setImageWithURL:[NSURL URLWithString:model.commodity.coverImage] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    } else {
        [_orderImageView sd_setImageWithURL:[NSURL URLWithString:commodityItemModel.img] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    }
    
    
    _isSelButton.selected = model.isSel;
}
@end
