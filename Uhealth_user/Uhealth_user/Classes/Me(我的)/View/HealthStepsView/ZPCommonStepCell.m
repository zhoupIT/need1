//
//  ZPCommonStepCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCommonStepCell.h"
#import "ZPStepModel.h"
@interface ZPCommonStepCell()
{
    UILabel *_leftValueLabel;
    UILabel *_leftLabel;
    UIImageView *_rightIcon;
    UILabel *_rightLabel;
}
@end
@implementation ZPCommonStepCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    _leftValueLabel = [UILabel new];
    _leftLabel = [UILabel new];
    _rightIcon = [UIImageView new];
    _rightLabel = [UILabel new];
    [contentView sd_addSubviews:@[_leftValueLabel,_leftLabel,_rightIcon,_rightLabel]];
    
    _rightIcon.sd_layout
    .rightSpaceToView(contentView, ZPWidth(15))
    .topSpaceToView(contentView, ZPHeight(15))
    .widthIs(ZPWidth(60))
    .heightIs(ZPHeight(40));
    
    _rightLabel.sd_layout
    .topSpaceToView(_rightIcon, ZPHeight(10))
    .rightSpaceToView(contentView, ZPWidth(15))
    .autoHeightRatio(0);
    _rightLabel.textAlignment = NSTextAlignmentRight;
    [_rightLabel setSingleLineAutoResizeWithMaxWidth:150];
    _rightLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _rightLabel.textColor = ZPMyOrderDetailFontColor;
    
    _leftValueLabel.sd_layout
    .leftSpaceToView(contentView, ZPWidth(18))
    .rightSpaceToView(_rightIcon, ZPWidth(10))
    .centerYEqualToView(_rightIcon)
    .heightIs(ZPHeight(19));
    _leftValueLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    _leftValueLabel.textColor = RGB(77, 182, 255);
    _leftValueLabel.text = @"步";
    
    _leftLabel.sd_layout
    .leftSpaceToView(contentView, ZPWidth(16))
    .centerYEqualToView(_rightLabel)
    .heightIs(ZPHeight(13));
    [_leftLabel setSingleLineAutoResizeWithMaxWidth:100];
    _leftLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _leftLabel.textColor = ZPMyOrderDetailFontColor;
    
    [self setupAutoHeightWithBottomView:_leftLabel bottomMargin:ZPHeight(15)];
}

- (void)setIndexPath:(NSInteger)indexPath {
    _indexPath = indexPath;
}

- (void)setModel:(ZPStepModel *)model {
    _model = model;
    if (self.indexPath == 0) {
        _leftValueLabel.text = @"10000步";
        _leftValueLabel.textColor = RGB(77, 182, 255);
        NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:_leftValueLabel.text];
        
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)] range:NSMakeRange(0, _leftValueLabel.text.length-1)];
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)] range:NSMakeRange(_leftValueLabel.text.length-1, 1)];
        
        _leftValueLabel.attributedText = fontAttributeNameStr;
    
        _rightLabel.text = [NSString stringWithFormat:@"目标完成%d%%",(int)model.progress];
    } else if (self.indexPath == 1) {
        if (!model.liDis || [model.liDis isKindOfClass:[NSNull class]]) {
            model.liDis = @"0";
        }
        if (!model.circle || [model.circle isKindOfClass:[NSNull class]]) {
            model.circle = @"0";
        }
        _leftValueLabel.text = [NSString stringWithFormat:@"%@公里",model.liDis];
        NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:_leftValueLabel.text];
        
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)] range:NSMakeRange(0, _leftValueLabel.text.length-2)];
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)] range:NSMakeRange(_leftValueLabel.text.length-2, 2)];
        
        _leftValueLabel.attributedText = fontAttributeNameStr;
        _leftValueLabel.textColor = RGB(77, 199, 4);
        _rightLabel.text = [NSString stringWithFormat:@"≈绕操场%@圈",model.circle];
    }else {
        _leftValueLabel.text = [NSString stringWithFormat:@"%ld卡",model.calorie];
        NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:_leftValueLabel.text];
        
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)] range:NSMakeRange(0, _leftValueLabel.text.length-1)];
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)] range:NSMakeRange(_leftValueLabel.text.length-1, 1)];
        
        _leftValueLabel.attributedText = fontAttributeNameStr;
        _leftValueLabel.textColor = RGB(255, 180, 0);
        _rightLabel.text = [NSString stringWithFormat:@"≈%ld罐可乐的热量",model.cocoNums];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _leftLabel.text = title;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    _rightIcon.image = [UIImage imageNamed:iconName];
}
@end
