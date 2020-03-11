//
//  ZPCommentView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCommentView.h"
#import "TggStarEvaluationView.h"

@interface ZPCommentView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) TggStarEvaluationView *tggStarEvaluationView;
@property (nonatomic,strong) ZPTextView *textView;
@property (nonatomic,strong) UIButton *commitButton;

@property (nonatomic,assign)  NSInteger count;
@end
@implementation ZPCommentView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
        
    }
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"发表评价";
    _titleLabel.textColor = RGB(74, 74, 74);
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    __weak typeof(self) weakSelf = self;
    //点赞
    _tggStarEvaluationView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        weakSelf.count = count;
    }];
    [self addSubview:_tggStarEvaluationView];
    
    // 评价内容
    _textView = [[ZPTextView alloc] init];
    _textView.placeholder = @"请写下您的评价";
    _textView.layer.borderColor = ZPMyOrderDeleteBorderColor.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.backgroundColor = RGB(244, 244, 244);
    [self addSubview:_textView];
    
    
    //提交按钮
    _commitButton = [UIButton new];
    _commitButton.layer.borderWidth = 1;
    _commitButton.layer.borderColor = ZPMyOrderBorderColor.CGColor;
    _commitButton.layer.cornerRadius = 33*0.5;
    _commitButton.layer.masksToBounds = YES;
    [_commitButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [_commitButton setTitleColor:ZPMyOrderBorderColor forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_commitButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commitButton];
    
    
    // 关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"infor_colse_image"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    // 标题
    self.titleLabel.sd_layout
    .topSpaceToView(self , 30.0f)
    .centerXEqualToView(self)
    .widthIs(200.0f)
    .heightIs(15.0f);
    
    //点赞
    self.tggStarEvaluationView.sd_layout
    .topSpaceToView(self.titleLabel , 20.0f)
    .centerXEqualToView(self)
    .widthIs(228.0f)
    .heightIs(49.0f);
    
    // 评价内容
    self.textView.sd_layout
    .topSpaceToView(self.tggStarEvaluationView , 24.0f)
    .centerXEqualToView(self)
    .widthIs(250.0f)
    .heightIs(115.0f);
    
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , 10.0f)
    .rightSpaceToView(self , 20.0f)
    .widthIs(23.0f)
    .heightIs(23.0f);
    
    self.commitButton.sd_layout
    .topSpaceToView(self.textView, 31)
    .centerXEqualToView(self)
    .widthIs(250.0f)
    .heightIs(33.0f);
    
    [self setupAutoHeightWithBottomView:self.commitButton bottomMargin:29.0f];
}

#pragma mark - 关闭按钮点击事件

- (void)closeButtonAction:(UIButton *)sender{
    if (self.closeBlock) self.closeBlock();
}


- (void)comment {
    if (self.updateBlock) {
        
        self.updateBlock(self.count,self.textView.text);
    }
}
@end
