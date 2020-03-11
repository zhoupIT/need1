//
//  ZPChangePwdController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPChangePwdController.h"
#import "ZPButton.h"
@interface ZPChangePwdController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *adLabel;
@property (nonatomic,strong) UITextField *oldPwdField;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UITextField *PwdField;
@property (nonatomic,strong) ZPButton *submmitBtn;
@end

@implementation ZPChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = @"修改密码";
}

- (void)changePwd {
    if (!self.oldPwdField.text.length) {
        [MBProgressHUD showError:@"旧密码不能为空!"];
        return;
    }
    if (!self.PwdField.text.length) {
        [MBProgressHUD showError:@"新密码不能为空!"];
        return;
    }
    if (self.PwdField.text.length < 6 || self.PwdField.text.length >16) {
        [MBProgressHUD showError:@"密码请输入6到16位字母或数字"];
        return;
    }
    [MBProgressHUD showMessage:@"修改中..."];
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"password/reset" parameters:@{@"oldPassword":self.oldPwdField.text,@"newPassword":self.PwdField.text} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPChangePwdController class]];
}

- (void)setupUI {
    
    self.view.backgroundColor = RGB_242_242_242;
    
    self.adLabel = [UILabel new];
    self.oldPwdField = [UITextField new];
    self.numLabel = [UILabel new];
    self.PwdField = [UITextField new];
    self.submmitBtn = [ZPButton new];
    [self.view sd_addSubviews:@[self.adLabel,self.oldPwdField,self.numLabel,self.PwdField,self.submmitBtn]];
    
    self.adLabel.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 17)
    .heightIs(50)
    .rightEqualToView(self.view);
    self.adLabel.textAlignment = NSTextAlignmentLeft;
    self.adLabel.textColor = RGB_74_74_74;
    self.adLabel.text = @"旧密码";
    self.adLabel.font = [UIFont systemFontOfSize:14];
    
    self.oldPwdField.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.adLabel, 0)
    .heightIs(49);
    self.oldPwdField.delegate = self;
    self.oldPwdField.placeholder = @"如果包含字母，请注意大小写";
    self.oldPwdField.textColor = RGB_74_74_74;
    [self.oldPwdField setFont:[UIFont systemFontOfSize:14]];
    self.oldPwdField.backgroundColor = [UIColor whiteColor];
    self.oldPwdField.leftViewMode = UITextFieldViewModeAlways;
    self.oldPwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 0)];
    
    self.numLabel.sd_layout
    .leftSpaceToView(self.view, 17)
    .rightEqualToView(self.view)
    .topSpaceToView(self.oldPwdField, 0)
    .heightIs(50);
    self.numLabel.textAlignment = NSTextAlignmentLeft;
    self.numLabel.textColor = RGB_74_74_74;
    self.numLabel.text = @"新密码";
    self.numLabel.font = [UIFont systemFontOfSize:14];
    
    self.PwdField.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.numLabel, 0);
     self.PwdField.delegate = self;
    self.PwdField.textColor = RGB_74_74_74;
    self.PwdField.placeholder = @"如果包含字母，请注意大小写";
    self.PwdField.font = [UIFont systemFontOfSize:14];
    self.PwdField.backgroundColor = [UIColor whiteColor];
    self.PwdField.leftViewMode = UITextFieldViewModeAlways;
    self.PwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 0)];
    
    self.submmitBtn.sd_layout
    .topSpaceToView(self.PwdField, 50)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(49);
    [self.submmitBtn setTitle:@"确认" forState:UIControlStateNormal];
    self.submmitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.submmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submmitBtn.layer.masksToBounds = YES;
    self.submmitBtn.layer.cornerRadius = 8;
    [self.submmitBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
    [self.submmitBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_//|~＜＞$€^£•'@#$%^&*():;.,?!<>\\_+'/\""];
    NSString *str = [tem stringByTrimmingCharactersInSet:set];
    if (![string isEqualToString:str]) {
        return NO;
        
    }
    return YES;
}

@end
