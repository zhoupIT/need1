//
//  ZPCheckOutSubtitleIconCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutSubtitleIconCell.h"

@interface ZPCheckOutSubtitleIconCell()
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation ZPCheckOutSubtitleIconCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutSubtitleIconCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutSubtitleIconCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutSubtitleIconCell class]) owner:nil options:nil] firstObject];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsZero;
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

- (void)setLeftstr:(NSString *)leftstr {
    _leftstr = leftstr;
    self.leftLabel.text = leftstr;
}

- (void)setRightstr:(NSString *)rightstr {
    _rightstr = rightstr;
    self.rightLabel.text = rightstr;
}

@end
