//
//  ZPPsychologicalAssessmentInfoTFCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentInfoTFCell.h"

@interface ZPPsychologicalAssessmentInfoTFCell()
{
    UILabel *_titleLabel;
    UITextField *_textField;
}
@end
@implementation ZPPsychologicalAssessmentInfoTFCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    _textField = [UITextField new];
    [contentView sd_addSubviews:@[_titleLabel,_textField]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 16)
    .heightIs(13)
    .centerYEqualToView(contentView);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:65];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    _textField.sd_layout
    .rightSpaceToView(contentView, 16)
    .heightIs(13)
    .leftSpaceToView(_titleLabel, 10)
    .centerYEqualToView(contentView);
    _textField.textColor = ZPMyOrderDetailFontColor;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textAlignment = NSTextAlignmentRight;
    [_textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
    if ([titleStr isEqualToString:@"公司名称"]) {
        _textField.userInteractionEnabled = NO;
    } else {
        _textField.userInteractionEnabled = YES;
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    _textField.text = name;
}

-(void)textFieldTextChange:(UITextField *)textField{
    ZPLog(@"textField - 输入框内容改变,当前内容为: %@",textField.text);
    if (self.updateNameBlock) {
        self.updateNameBlock(textField.text);
    }
}
@end
