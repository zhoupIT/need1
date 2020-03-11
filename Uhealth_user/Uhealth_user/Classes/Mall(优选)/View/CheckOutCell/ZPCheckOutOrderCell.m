//
//  ZPCheckOutOrderCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutOrderCell.h"
#import "ZPShoppingCartCommodityModel.h"
#import "ZPCommodity.h"
#import "ZPOrderItemModel.h"
#import "ZPCommodityItemModel.h"
@interface ZPCheckOutOrderCell()
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *presentLabel;
@property (strong, nonatomic) IBOutlet UILabel *orginLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation ZPCheckOutOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutOrderCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutOrderCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/* 购物车的模型 */
- (void)setModel:(ZPShoppingCartCommodityModel *)model {
    _model = model;
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.commodity.coverImage]];
//    self.nameLabel.text = model.commodity.name;
//    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",model.commodity.presentPrice];
//    self.orginLabel.text = model.commodity.originalPrice;
//
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.orginLabel.attributedText = newPrice;
    
//    self.numLabel.text = [NSString stringWithFormat:@"x%@",model.commodityCount];
    //购物车里 判断这个商品有没有带默认规格
//    if (model.commodity.specifications && !model.commodity.specifications.hasDefaultOption) {
        //购物车需要用 小项的价格
        ZPCommodityItemModel *commodityItemModel = model.commodity.specifications.commodityItem.firstObject;
//        if (!model.commodity.specifications.hasDefaultOption) {
            NSString *connectedStr = @"";
            for (NSString *key in commodityItemModel.attached.allKeys) {
                if (connectedStr.length) {
                    connectedStr = [connectedStr stringByAppendingString:@";"];
                }
                NSString *str = [commodityItemModel.attached objectForKey:key];
                connectedStr = [connectedStr stringByAppendingString:str];
            }
            self.typeLabel.text = [NSString stringWithFormat:@"\"%@\"",connectedStr];
//        }
        self.presentLabel.text = [NSString stringWithFormat:@"￥%@",commodityItemModel.presentPrice];
        self.orginLabel.text = commodityItemModel.originalPrice;
        
        NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
        [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
        self.orginLabel.attributedText = newPrice;
    if (!commodityItemModel.img || !commodityItemModel.img.length) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.commodity.coverImage] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    } else {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:commodityItemModel.img] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    }
    
        self.nameLabel.text = model.commodity.name;
        self.numLabel.text = [NSString stringWithFormat:@"x%@",model.commodityCount];
}

- (void)setCommodityModel:(ZPCommodity *)commodityModel {
    _commodityModel = commodityModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:commodityModel.coverImage]];
    self.nameLabel.text = commodityModel.name;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",commodityModel.presentPrice];
    self.orginLabel.text = commodityModel.originalPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",@"1"];
}


- (void)setItemModel:(ZPOrderItemModel *)itemModel {
    _itemModel = itemModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:itemModel.imageUrl]];
    self.nameLabel.text = itemModel.commodityName;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",itemModel.presentUnitPrice];
    self.orginLabel.text = itemModel.costUnitPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",itemModel.number];
    self.typeLabel.text = itemModel.commoditySpecificationInfo;
}

- (void)setType:(NSString *)type {
    _type = type;
    self.iconView.image = [UIImage imageNamed:@"greenPath"];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    self.nameLabel.text = @"商品名：绿色通道";
    self.typeLabel.text = [NSString stringWithFormat:@"商品类型：%@",type];
}

- (void)setTotal:(NSString *)total {
    _total = total;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",total];
}

- (void)setOrginTotal:(NSString *)orginTotal {
    _orginTotal = orginTotal;
    self.orginLabel.text = orginTotal;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x1"];
}

/* 显示出选择的规格 */
- (void)setCommodityItemModel:(ZPCommodityItemModel *)commodityItemModel {
    _commodityItemModel = commodityItemModel;
    NSString *connectedStr = @"";
    for (NSString *key in commodityItemModel.attached.allKeys) {
        if (connectedStr.length) {
            connectedStr = [connectedStr stringByAppendingString:@";"];
        }
        NSString *str = [commodityItemModel.attached objectForKey:key];
        connectedStr = [connectedStr stringByAppendingString:str];
    }
    self.typeLabel.text = [NSString stringWithFormat:@"\"%@\"",connectedStr];
    
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",commodityItemModel.presentPrice];
    self.orginLabel.text = commodityItemModel.originalPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
}
@end
