//
//  ZPRetireSelCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRetireSelCell.h"
#import "TYAttributedLabel.h"
#import "TExamTextField.h"
#import "RegexKitLite.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface ZPRetireSelCell()<TYAttributedLabelDelegate>
{
  
    UILabel *_titleLabel;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
}

@property (nonatomic,strong) TYAttributedLabel *label;
@property (nonatomic,strong) TYTextContainer *textContainer;
@property (nonatomic,strong) NSAttributedString *attString;
@end
@implementation ZPRetireSelCell
#define kExamTextFieldWidth 50
#define kExamTextFieldHeight 20
#define kTextFieldTag 1000
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
   
    _titleLabel = [UILabel new];
    _leftBtn = [UIButton new];
    _rightBtn = [UIButton new];
    [contentView sd_addSubviews:@[_titleLabel,_leftBtn,_rightBtn]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 16)
    .heightIs(13)
    .topSpaceToView(contentView, 10);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:65];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    _rightBtn.sd_layout
    .rightSpaceToView(contentView, 16)
    .heightIs(23)
    .widthIs(50)
    .topSpaceToView(contentView, 10);
    _rightBtn.layer.borderWidth = 0.5;
    _rightBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
    _rightBtn.layer.cornerRadius = 5;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.tag = 10002;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitle:@"否" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_rightBtn addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftBtn.sd_layout
    .rightSpaceToView(_rightBtn, 10)
    .heightIs(23)
    .widthIs(50)
    .topSpaceToView(contentView, 10);
    _leftBtn.layer.borderWidth = 0.5;
    _leftBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
    _leftBtn.layer.cornerRadius = 5;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.tag = 10001;
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftBtn setTitle:@"是" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_leftBtn addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self createTextContainer:@"请问退休年龄是[@]岁"];
    [self addScrollView];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResult) name:kNotificationSmokeResult object:nil];
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
}

- (void)setPsyModel:(ZPPsyAssessmentModel *)psyModel {
    _psyModel = psyModel;
    if (psyModel.isExpandRetire) {
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

- (void)setModel:(ZPPsyModel *)model {
    _model = model;
    if (model.isExpandRetire) {
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

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;    
}



- (void)createTextContainer:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    _textContainer = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
}

- (void)addScrollView
{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:label];
    _label = label;
    label.delegate = self;
    
    label.textContainer = _textContainer;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftEqualToView(_titleLabel)
    .rightSpaceToView(self.contentView, 0)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(_titleLabel, 10);
    
    ZPLog(@"%@ %f",_textContainer.text,[label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height);
}



// 解析填空
- (NSArray *)parseTextFieldsWithString:(NSString *)string
{
    NSMutableArray *textFieldArray = [NSMutableArray array];
    [string enumerateStringsMatchedByRegex:@"\\[@\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 0) {
            TExamTextField *textField = [[TExamTextField alloc]initWithFrame:CGRectMake(0, 0, kExamTextFieldWidth, kExamTextFieldHeight)];
            textField.textColor = ZPMyOrderDetailFontColor;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = [UIFont systemFontOfSize:13];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            TYViewStorage *viewStorage = [[TYViewStorage alloc]init];
            viewStorage.range = capturedRanges[0];
            viewStorage.view = textField;
            viewStorage.tag = kTextFieldTag + textFieldArray.count;;
            
            [textFieldArray addObject:viewStorage];
        }
    }];
    
    return textFieldArray.count > 0 ?[textFieldArray copy] : nil;
}

// 遍历出 textfiled
- (void)enumerateTextFieldStorageUseBlock:(void(^)(TYViewStorage *viewStorage))block
{
    for (TYTextStorage *textStorage in _textContainer.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                if (block) {
                    block(viewStorage);
                }
            }
        }
    }
}

- (void)getResult {
    NSMutableArray *array = [NSMutableArray array];
    NSString *titleStr = @"";
    for (TYTextStorage *textStorage in _textContainer.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                titleStr = _titleLabel.text;
                    if (textField.text.length == 0) {
                        [array addObject:@0];
                    } else {
                        [array addObject:textField.text];
                    }
            }
        }
    }
    NSDictionary *dict = @{@"titleName":titleStr,@"dataArray":array};
    if (titleStr.length) {
    //发通知传数据给主页面
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendResult object:dict];
    }
}

@end
