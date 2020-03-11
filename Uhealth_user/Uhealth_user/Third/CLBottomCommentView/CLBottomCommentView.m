//
//  CLBottomCommentView.m
//  CLBottomCommentView
//
//  Created by YuanRong on 16/1/19.
//  Copyright © 2016年 FelixMLians. All rights reserved.
//

#import "CLBottomCommentView.h"

@interface CLBottomCommentView()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLayout;

@end
@implementation CLBottomCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [[NSBundle mainBundle] loadNibNamed:@"CLBottomCommentView" owner:self options:nil];
        [self.contentView setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:self.contentView];
        [self configure];
    }
   
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self addSubview:self.clTextView];
    
    if (textField.text.length > 4) {
        NSMutableString *string = [[NSMutableString alloc] initWithString:textField.text];
        self.clTextView.commentTextView.text = [string substringFromIndex:4];
    }
    
    [self.clTextView.commentTextView becomeFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self.clTextView];
    return NO;
}

#pragma mark - Event Response

- (IBAction)commentAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomViewDidComment:)]) {
        [self.delegate bottomViewDidComment:sender];
    }
}

- (IBAction)shareAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomViewDidShare)]) {
        [self.delegate bottomViewDidShare];
    }
}

#pragma mark - Public Method

- (void)showTextView {
    [self.editTextField becomeFirstResponder];
}

- (void)clearComment {
    self.editTextField.text = @"";
    self.clTextView.commentTextView.text = @"";
    [self.clTextView.sendButton setTitleColor:kColorTextTime forState:UIControlStateNormal];
}

#pragma mark - Private Method
- (void)configure {
    self.editView.layer.cornerRadius = 17.5;
    self.editView.clipsToBounds = YES;
//    self.editView.layer.borderColor = kColorLineCellSeperator.CGColor;
//    self.editView.layer.borderWidth = 0.5;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5)];
    lineView.backgroundColor = kColorLineBarSeperator;
//    [self.contentView addSubview:lineView];
    self.layer.shadowColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.09f].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 3;
    
    self.editTextField.delegate = self;
}

- (void)hiddenCommentAndShareView {
    [self.shareButton removeFromSuperview];;
    [self.commentButton removeFromSuperview];
    [self removeConstraint:self.rightLayout];
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:self.editView //子试图
                                       attribute:NSLayoutAttributeTrailing //子试图的约束属性
                                       relatedBy:NSLayoutRelationEqual //属性间的关系
                                       toItem:self//相对于父试图
                                       attribute:NSLayoutAttributeTrailing//父试图的约束属性
                                       multiplier:1
                                       constant:-15.0];// 固定距离
    
    myConstraint.active = YES;
}

#pragma mark - Accessor
- (CLTextView *)clTextView  {
    if (!_clTextView) {
        _clTextView = [[CLTextView alloc] initWithFrame:CGRectMake(0, 0, cl_ScreenWidth, cl_ScreenHeight)];
        _clTextView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _clTextView;
}


@end
