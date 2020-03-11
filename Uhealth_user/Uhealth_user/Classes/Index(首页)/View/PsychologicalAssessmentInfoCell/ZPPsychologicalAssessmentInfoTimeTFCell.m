//
//  ZPPsychologicalAssessmentInfoTimeTFCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentInfoTimeTFCell.h"
#import "ZPUserModel.h"
@interface ZPPsychologicalAssessmentInfoTimeTFCell()
{
    UILabel *_titleLabel;
    UITextField *_textField;
}
@property (nonatomic,strong) UIDatePicker *datePicker;
@end
@implementation ZPPsychologicalAssessmentInfoTimeTFCell
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
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setMaximumDate:[NSDate date]];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _textField.inputView = _datePicker;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
//        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *resDate = [formatter dateFromString:model.birthday];
//        // 设置当前显示时间
//        [_datePicker setDate:resDate animated:YES];
//        
//    }
    
}

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (_textField.isFirstResponder)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        _textField.text = [formatter stringFromDate:sender.date];
        if (self.updateTime) {
            self.updateTime(_textField.text);
        }
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)setTime:(NSString *)time {
    _time = time;
    _textField.text = time;
}
@end
