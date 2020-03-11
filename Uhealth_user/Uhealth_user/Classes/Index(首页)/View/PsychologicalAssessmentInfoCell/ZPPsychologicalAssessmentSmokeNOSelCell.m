//
//  ZPPsychologicalAssessmentSmokeNOSelCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentSmokeNOSelCell.h"

@interface ZPPsychologicalAssessmentSmokeNOSelCell()
{
    UILabel *_titleLabel;
    UIButton *_arrowBtn;
    UILabel *_resultLabel;
    UIButton *_selBtn;
}
@end

@implementation ZPPsychologicalAssessmentSmokeNOSelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 16)
    .heightIs(13)
    .topSpaceToView(contentView, 18);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:65];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"";
    
    _selBtn = [UIButton new];
    [contentView addSubview:_selBtn];
    _selBtn.sd_layout
    .leftSpaceToView(contentView, 20)
    .heightIs(13)
    .widthIs(13)
    .topSpaceToView(_titleLabel, 15);
    [_selBtn setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateNormal];
    _selBtn.hidden = YES;
    
    _resultLabel = [UILabel new];
    [contentView addSubview:_resultLabel];
    _resultLabel.sd_layout
    .leftSpaceToView(_selBtn, 13)
    .heightIs(13)
    .centerYEqualToView(_selBtn)
    .rightSpaceToView(contentView, 16);
    _resultLabel.textColor = ZPMyOrderDetailFontColor;
    _resultLabel.font = [UIFont systemFontOfSize:14];
    _resultLabel.text = @"xxxxx";
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)setResultStr:(NSString *)resultStr {
    _resultStr = resultStr;
    _resultLabel.text = resultStr;
    if (resultStr.length) {
        _selBtn.hidden = NO;
    } else {
        _selBtn.hidden = YES;
    }
}
@end
