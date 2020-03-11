//
//  ZPCheckOutSubTitleCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutSubTitleCell.h"
#import "ZPCheckOutModel.h"
@interface ZPCheckOutSubTitleCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@end
@implementation ZPCheckOutSubTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutSubTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutSubTitleCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutSubTitleCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ZPCheckOutModel *)model {
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.details;
}

- (void)setSubtitleStr:(NSString *)subtitle {
    self.subTitleLabel.text = subtitle;
}

- (void)setTitleStr:(NSString *)titleStr {
    self.titleLabel.text = titleStr;
}
@end
