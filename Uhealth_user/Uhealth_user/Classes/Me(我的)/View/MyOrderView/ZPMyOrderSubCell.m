//
//  ZPMyOrderSubCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyOrderSubCell.h"
#import "ZPOrderItemModel.h"

@interface ZPMyOrderSubCell()
@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *presentPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *commoditySpecificationInfo;

@end
@implementation ZPMyOrderSubCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView {
    ZPMyOrderSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPMyOrderSubCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPMyOrderSubCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = RGB(249, 249, 249);
        [cell setupUI];
    }
    return cell;
}

- (void)setupUI {
    self.orderImageView.layer.cornerRadius = 5;
    self.orderImageView.layer.masksToBounds = YES;
}

- (void)setModel:(ZPOrderItemModel *)model {
    _model = model;
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.nameLabel.text = model.commodityName;
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.presentUnitPrice];
    self.originPriceLabel.text = model.costUnitPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.originPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.originPriceLabel.attributedText = newPrice;
    
    self.countLabel.text = [NSString stringWithFormat:@"x%@",model.number];
    
    self.commoditySpecificationInfo.text = model.commoditySpecificationInfo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
