//
//  ZPCheckOutRemarkCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutRemarkCell.h"

@implementation ZPCheckOutRemarkCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutRemarkCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutRemarkCell class]) owner:nil options:nil] firstObject];
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

@end
