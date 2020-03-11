//
//  ZPPsychologicalAssessmentInfoSelCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentInfoSelCell.h"
@interface ZPPsychologicalAssessmentInfoSelCell()
{
    UILabel *_titleLabel;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
}
@end
@implementation ZPPsychologicalAssessmentInfoSelCell

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
    _leftBtn = [UIButton new];
    _rightBtn = [UIButton new];
    [contentView sd_addSubviews:@[_titleLabel,_leftBtn,_rightBtn]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 16)
    .heightIs(13)
    .centerYEqualToView(contentView);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:65];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    _rightBtn.sd_layout
    .rightSpaceToView(contentView, 16)
    .heightIs(23)
    .widthIs(50)
    .centerYEqualToView(contentView);
    _rightBtn.layer.borderWidth = 0.5;
    _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
    _rightBtn.layer.cornerRadius = 5;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.tag = 10002;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitle:@"女" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_rightBtn addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
   
    _leftBtn.sd_layout
    .rightSpaceToView(_rightBtn, 10)
    .heightIs(23)
    .widthIs(50)
    .centerYEqualToView(contentView);
    _leftBtn.layer.borderWidth = 0.5;
    _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
    _leftBtn.layer.cornerRadius = 5;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.tag = 10001;
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftBtn setTitle:@"男" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_leftBtn addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectEvent:(UIButton *)btn {
    _leftBtn.selected = NO;
    _rightBtn.selected = NO;
    _leftBtn.backgroundColor = [UIColor whiteColor];
    _rightBtn.backgroundColor = [UIColor whiteColor];
    _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
    _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
    btn.selected = !btn.selected;
    
    btn.backgroundColor = btn.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    btn.layer.borderColor = btn.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    if (self.selBlock) {
        self.selBlock(btn);
    }
    if (self.selGenderBlock) {
        self.selGenderBlock(btn);
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [_leftBtn setTitle:titleArray.firstObject forState:UIControlStateNormal];
    [_rightBtn setTitle:titleArray.lastObject forState:UIControlStateNormal];
}

- (void)setModel:(ZPPsyModel *)model {
    _model = model;
    if (model.genderType == 0) {
        _leftBtn.selected = YES;
        _leftBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        _leftBtn.layer.borderColor =[UIColor whiteColor].CGColor;
        _rightBtn.selected = NO;
    }else if (model.genderType == 1) {
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        _rightBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        _rightBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    }else {
        _leftBtn.selected = NO;
        _rightBtn.selected = NO;
    }
}

- (void)setPsyModel:(ZPPsyAssessmentModel *)psyModel {
    _psyModel = psyModel;
    if ([psyModel.gender isEqualToString:@"m"]) {
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        
        _leftBtn.selected = YES;
        _leftBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        _leftBtn.layer.borderColor =[UIColor whiteColor].CGColor;
        _rightBtn.selected = NO;
    }else if ([psyModel.gender isEqualToString:@"f"]) {
        
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        _rightBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        _rightBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    }else {
        _leftBtn.selected = NO;
        _rightBtn.selected = NO;
    }
}

- (void)setRetireModel:(ZPPsyAssessmentModel *)retireModel {
    _retireModel = retireModel;
    if (retireModel.isExpandRetire) {
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        
        _leftBtn.selected = YES;
        _leftBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        _leftBtn.layer.borderColor =[UIColor whiteColor].CGColor;
        _rightBtn.selected = NO;
    } else {
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
        
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        _rightBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        _rightBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    }
}
@end
