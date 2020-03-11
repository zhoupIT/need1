//
//  ZPPsySelectTypeCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsySelectTypeCell.h"
#import "TYAttributedLabel.h"
#import "TExamTextField.h"
#import "RegexKitLite.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface ZPPsySelectTypeCell()<TYAttributedLabelDelegate>
{
    UIButton *_selBtn;
    UILabel *_titleLabel;
}
@property (nonatomic,strong) TYAttributedLabel *label;
@property (nonatomic,strong) TYTextContainer *textContainer;
@property (nonatomic,strong) NSAttributedString *attString;
@property (nonatomic,weak) TPKeyboardAvoidingScrollView *scrollView;
@end

#define kExamTextFieldWidth 50
#define kExamTextFieldHeight 20
#define kTextFieldTag 1000
@implementation ZPPsySelectTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    UIView *contentView = self.contentView;
    _selBtn = [UIButton new];
    _titleLabel = [UILabel new];
    [contentView sd_addSubviews:@[_selBtn,_titleLabel]];
    _selBtn.sd_layout
    .leftSpaceToView(contentView, 0)
    .heightIs(13)
    .widthIs(13)
    .topSpaceToView(contentView, 10);
    [_selBtn setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
    [_selBtn addTarget:self action:@selector(selEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel.sd_layout
    .leftSpaceToView(_selBtn, 13)
    .rightSpaceToView(contentView, 16)
    .heightIs(13)
    .centerYEqualToView(_selBtn);
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResult) name:kNotificationDrinkResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResult) name:kNotificationSmokeResult object:nil];
}

- (void)selEvent:(UIButton *)btn {
    if (self.updateSelBlock) {
        self.updateSelBlock(btn);
    }
}

- (void)setIsSel:(BOOL)isSel {
    _isSel = isSel;
    _selBtn.selected = isSel;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
    if ([self.cellTitleStr isEqualToString:@"您吸烟吗?"]) {
        if (![titleStr isEqualToString:@"不吸烟"]) {
            [self createTextContainer:@"每天平均吸[@]根，共吸了[@]年"];
            [self addScrollView];
        } else {
            [self setupAutoHeightWithBottomView:_titleLabel bottomMargin:18];
        }
    } else {
        if (![titleStr isEqualToString:@"不喝酒"]) {
            [self createTextContainer:@"啤酒每天喝[@]瓶\n白酒每天喝[@]两\n红酒每天喝[@]杯\n洋酒每天喝[@]两"];
            [self addScrollView];
        } else {
            [self setupAutoHeightWithBottomView:_titleLabel bottomMargin:18];
        }
    }
    
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
                
                if (_selBtn.isSelected) {
                    titleStr = _titleLabel.text;
                    if (textField.text.length == 0) {
                        [array addObject:@0];
                    } else {
                        [array addObject:textField.text];
                    }
                    
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
