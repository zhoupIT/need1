//
//  ZPCheckOutTitleCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutTitleCell.h"

@interface ZPCheckOutTitleCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation ZPCheckOutTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutTitleCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutTitleCell class]) owner:nil options:nil] firstObject];
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

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
    
}
@end
