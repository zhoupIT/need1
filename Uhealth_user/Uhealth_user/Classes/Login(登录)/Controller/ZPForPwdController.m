//
//  ZPForPwdController.m
//  uhealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPForPwdController.h"
#import "ZPButton.h"
@interface ZPForPwdController ()
@property (nonatomic,strong) UITextField *phoneTextfield;
@property (nonatomic,strong) UITextField *smsTextfield;
@property (nonatomic,strong) UITextField *pwdTextfield;
@property (nonatomic,strong) ZPButton *submmitBtn;

/** 倒计时总时间 */
@property (nonatomic,assign) int secondsCountDown;
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic,strong) UIButton *smsButton;
@end

@implementation ZPForPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - 私有方法
- (void)resetPwd {
    if (self.phoneTextfield.text.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.phoneTextfield.text]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    if (!self.smsTextfield.text.length) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    if (!self.pwdTextfield.text.length) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.pwdTextfield.text.length < 6 || self.pwdTextfield.text.length >16) {
        [MBProgressHUD showError:@"密码请输入6到16位字母或数字"];
        return;
    }
    [MBProgressHUD showMessage:@"重置密码中..."];
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"forget" parameters:@{@"phoneNumber":self.phoneTextfield.text,@"authCode":self.smsTextfield.text,@"password":self.pwdTextfield.text} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"重置密码成功"];
            if (self.modifyPasswordBlock) {
                self.modifyPasswordBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPForPwdController class]];
    
}

/** 获取验证码按钮 */
- (void)obtainButton:(UIButton *)sender {
    if (!self.phoneTextfield.text.length) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.phoneTextfield.text]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    sender.userInteractionEnabled = NO;
    //设置倒计时总时长
    self.secondsCountDown = 60;//60秒倒计时
    //开始倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法
    //设置倒计时显示的时间
    [sender setTitle:[NSString stringWithFormat:@"%ds后重试",self.secondsCountDown] forState:UIControlStateNormal];
    
    
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"/api/common/customer/auth/password/authcode/%@",self.phoneTextfield.text] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"验证码发送失败"];
    } className:[ZPForPwdController class]];
}

/**
 *  倒计时方法
 */
-(void)timeFireMethod{
    //倒计时-1
    self.secondsCountDown--;
    //不设置会闪烁
    self.smsButton.titleLabel.text = [NSString stringWithFormat:@"%ds后重试",self.secondsCountDown];
    //修改倒计时标签现实内容
    [self.smsButton setTitle:[NSString stringWithFormat:@"%ds后重试",self.secondsCountDown] forState:UIControlStateNormal];
    //当倒计时到0时，做需要的操作,重新获取
    if(self.secondsCountDown==0){
        self.smsButton.userInteractionEnabled = YES;
        [self.smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.countDownTimer invalidate];
    }
}

- (void)setupUI {
    
    self.title  = @"忘记密码";
    self.view.backgroundColor = RGB_242_242_242;
    
//    self.submmitBtn = [ZPButton new];
    [self.view sd_addSubviews:@[self.phoneTextfield,self.smsTextfield,self.pwdTextfield,self.submmitBtn]];
    
    self.phoneTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.view, 8);
    
    self.smsTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.phoneTextfield, 1);
    
    self.pwdTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.smsTextfield, 1);
    
    self.submmitBtn.sd_layout
    .topSpaceToView(self.pwdTextfield, 50)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(49);
   
    if (self.isPresent) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITextField *)phoneTextfield {
    if (!_phoneTextfield) {
        _phoneTextfield = [UITextField new];
        _phoneTextfield.textColor =RGB_74_74_74;
        _phoneTextfield.font = [UIFont systemFontOfSize:14];
        _phoneTextfield.backgroundColor = [UIColor whiteColor];
        _phoneTextfield.placeholder = @"请输入手机号";
        _phoneTextfield.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
        
        _phoneTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneTextfield;
}

- (UITextField *)smsTextfield {
    if (!_smsTextfield) {
        _smsTextfield = [UITextField new];
        _smsTextfield.textColor =RGB_74_74_74;
        _smsTextfield.font = [UIFont systemFontOfSize:14];
        _smsTextfield.backgroundColor = [UIColor whiteColor];
        _smsTextfield.placeholder = @"请输入验证码";
        _smsTextfield.leftViewMode = UITextFieldViewModeAlways;
        _smsTextfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+75, 49)];
        rightView.backgroundColor = [UIColor whiteColor];
        
        UIButton *righticonView = [UIButton new];
        [rightView addSubview:righticonView];
        righticonView.layer.cornerRadius = 5;
        righticonView.layer.masksToBounds = YES;
        
        [righticonView setTitle:@"获取验证码" forState:UIControlStateNormal];
        righticonView.titleLabel.font = [UIFont systemFontOfSize:13];
        righticonView.backgroundColor = ZPMyOrderDetailValueFontColor;
        
        
        [righticonView addTarget:self action:@selector(obtainButton:) forControlEvents:UIControlEventTouchUpInside];
        
        righticonView.sd_layout
        .centerYEqualToView(rightView)
        .rightSpaceToView(rightView, 15)
        .heightIs(27)
        .widthIs(75);
        
        self.smsButton = righticonView;
        
        _smsTextfield.rightView = rightView;
        _smsTextfield.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return _smsTextfield;
}

- (UITextField *)pwdTextfield {
    if (!_pwdTextfield) {
        _pwdTextfield = [UITextField new];
        _pwdTextfield.textColor =RGB_74_74_74;
        _pwdTextfield.font = [UIFont systemFontOfSize:14];
        _pwdTextfield.backgroundColor = [UIColor whiteColor];
        _pwdTextfield.placeholder = @"请输入新密码6到16位字母或数字";
        _pwdTextfield.leftViewMode = UITextFieldViewModeAlways;
        _pwdTextfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
        
        _pwdTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _pwdTextfield;
}

- (ZPButton *)submmitBtn {
    if (!_submmitBtn) {
        _submmitBtn = [ZPButton new];
        [_submmitBtn setTitle:@"重置" forState:UIControlStateNormal];
        _submmitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submmitBtn.layer.masksToBounds = YES;
        _submmitBtn.layer.cornerRadius = 8;
        [_submmitBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
        [_submmitBtn addTarget:self action:@selector(resetPwd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submmitBtn;
}
@end
