//
//  ZPAdviceController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAdviceController.h"
#import "ZPButton.h"
#import "ZPUserModel.h"
@interface ZPAdviceController ()
@property (nonatomic,strong) UILabel *adLabel;
@property (nonatomic,strong) ZPTextView *textView;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UITextField *numField;
@property (nonatomic,strong) ZPButton *submmitBtn;
@end

@implementation ZPAdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//提交
- (void)submit {
    if (!self.textView.text.length) {
        [MBProgressHUD showError:@"建议不能为空"];
        return;
    }
    if (!self.numField.text.length) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.numField.text]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    [MBProgressHUD showMessage:@"提交中..."];
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"appComment/save" parameters:@{@"content":self.textView.text,@"phoneNumber":self.numField.text} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPAdviceController class]];
    
}

- (void)initAll {
    self.title = @"评价建议";
    self.view.backgroundColor = RGB(242, 242, 242);
    
    self.adLabel = [UILabel new];
    self.textView = [ZPTextView new];
    self.numLabel = [UILabel new];
    self.numField = [UITextField new];
    self.submmitBtn = [ZPButton new];
    [self.view sd_addSubviews:@[self.adLabel,self.textView,self.numLabel,self.numField,self.submmitBtn]];
    
    self.adLabel.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 17)
    .heightIs(50)
    .rightEqualToView(self.view);
    self.adLabel.textAlignment = NSTextAlignmentLeft;
    self.adLabel.textColor = RGB(74, 74, 74);
    self.adLabel.text = @"您的建议";
    self.adLabel.font = [UIFont systemFontOfSize:14];
    
    self.textView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.adLabel, 0)
    .heightIs(173);
    self.textView.placeholder = @"只针对本产品进行反馈，如果咨询健康问题或者对商品有问题请使用首页“问问他”或请找客服帮忙。";
    [self.textView setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [self.textView setPlaceholderColor:RGB(170, 170, 170)];
    [self.textView setFont:[UIFont systemFontOfSize:14]];
    
    self.numLabel.sd_layout
    .leftSpaceToView(self.view, 17)
    .rightEqualToView(self.view)
    .topSpaceToView(self.textView, 0)
    .heightIs(50);
    self.numLabel.textAlignment = NSTextAlignmentLeft;
    self.numLabel.textColor = RGB(74, 74, 74);
    self.numLabel.text = @"请留下手机号，方便我们联系您";
    self.numLabel.font = [UIFont systemFontOfSize:14];
    
    self.numField.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.numLabel, 0);
    self.numField.textColor = RGB(74, 74, 74);
    self.numField.font = [UIFont systemFontOfSize:14];
    self.numField.backgroundColor = [UIColor whiteColor];
    self.numField.keyboardType = UIKeyboardTypeNumberPad;
    self.numField.leftViewMode = UITextFieldViewModeAlways;
    self.numField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 0)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.numField.text = model.phone;
    }
    
    self.submmitBtn.sd_layout
    .topSpaceToView(self.numField, 50)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(49);
    [self.submmitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submmitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.submmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submmitBtn.layer.masksToBounds = YES;
    self.submmitBtn.layer.cornerRadius = 8;
    [self.submmitBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
    [self.submmitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}



@end
