//
//  ZPCheckOutHeaderCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutHeaderCell.h"
#import "ZPAddressModel.h"

@interface ZPCheckOutHeaderCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UILabel *locLabel;
@end
@implementation ZPCheckOutHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutHeaderCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutHeaderCell class]) owner:nil options:nil] firstObject];
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

- (void)setModel:(ZPAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.receiver;
    self.phoneLabel.text = model.phone;
    self.locLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.provinceName,model.cityName,model.countryName,model.address];
}

@end
