//
//  ZPCheckOutScoreCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutScoreCell.h"

@implementation ZPCheckOutScoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutScoreCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutScoreCell class]) owner:nil options:nil] firstObject];
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
- (IBAction)selectScoreDiscount:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
