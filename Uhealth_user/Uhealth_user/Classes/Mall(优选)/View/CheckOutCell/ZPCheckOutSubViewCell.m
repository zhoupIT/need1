//
//  ZPCheckOutSubViewCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutSubViewCell.h"
#import "PPNumberButton.h"
@interface ZPCheckOutSubViewCell()
@property (nonatomic,strong) PPNumberButton *numButton;
@end
@implementation ZPCheckOutSubViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ZPCheckOutSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCheckOutSubViewCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZPCheckOutSubViewCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell setupUI];
    }
    return cell;
}

- (void)setupUI {
    self.numButton = [PPNumberButton new];
    [self.contentView addSubview:self.numButton];
    
    self.numButton.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .heightIs(25)
    .widthIs(28*2+50)
    .centerYEqualToView(self.contentView);
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
        NSLog(@"%f",number);
        if (weakSelf.updatePriceBlock) {
            weakSelf.updatePriceBlock(number);
        }
        
    };
    
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
