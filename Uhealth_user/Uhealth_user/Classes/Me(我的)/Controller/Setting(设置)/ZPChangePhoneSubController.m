//
//  ZPChangePhoneSubController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPChangePhoneSubController.h"
#import "ZPButton.h"
#import "ZPUserModel.h"
@interface ZPChangePhoneSubController ()
@property (nonatomic,strong) UITextField *phoneTextfield;
@property (nonatomic,strong) UITextField *smsTextfield;
@property (nonatomic,strong) UITextField *newphoneTextfield;
@property (nonatomic,strong) ZPButton *submmitBtn;

/** 倒计时总时间 */
@property (nonatomic,assign) int secondsCountDown;
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic,strong) UIButton *smsButton;
@end

@implementation ZPChangePhoneSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.phoneTextfield.text = self.currentPhone;
}

#pragma mark - 私有方法
- (void)resetPwd {
    if (self.newphoneTextfield.text.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.newphoneTextfield.text]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    if (!self.smsTextfield.text.length) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"更改中..."];
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"phone" parameters:@{@"phoneNumber":self.newphoneTextfield.text,@"authCode":self.smsTextfield.text} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"更改手机号成功"];
            ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
            model.phone = self.newphoneTextfield.text;
            [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
            if (self.updatePhoneBlock) {
                self.updatePhoneBlock(self.newphoneTextfield.text);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPChangePhoneSubController class]];
    
}

/** 获取验证码按钮 */
- (void)obtainButton:(UIButton *)sender {
    if (!self.newphoneTextfield.text.length) {
        [MBProgressHUD showError:@"新手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.newphoneTextfield.text]) {
        [MBProgressHUD showError:@"新手机号码格式不正确"];
        return;
    }
    if ([self.phoneTextfield.text isEqualToString:self.newphoneTextfield.text]) {
        [MBProgressHUD showError:@"新手机号码不能和当前的一样"];
        return;
    }
    sender.userInteractionEnabled = NO;
    //设置倒计时总时长
    self.secondsCountDown = 60;//60秒倒计时
    //开始倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法
    //设置倒计时显示的时间
    [sender setTitle:[NSString stringWithFormat:@"%ds后重试",self.secondsCountDown] forState:UIControlStateNormal];
    
    
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"/api/common/customer/auth/phone/authcode/%@",self.newphoneTextfield.text] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"验证码发送失败"];
    } className:[ZPChangePhoneSubController class]];
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
    
    self.title  = @"更改手机号码";
    self.view.backgroundColor = RGB_242_242_242;
    
    //    self.submmitBtn = [ZPButton new];
    [self.view sd_addSubviews:@[self.phoneTextfield,self.smsTextfield,self.newphoneTextfield,self.submmitBtn]];
    
    self.phoneTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.view, 8);
    
    self.newphoneTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.phoneTextfield, 1);
    
    
    self.smsTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.newphoneTextfield, 1);
    
    
    self.submmitBtn.sd_layout
    .topSpaceToView(self.smsTextfield, 50)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(49);
    
}


- (UITextField *)phoneTextfield {
    if (!_phoneTextfield) {
        _phoneTextfield = [UITextField new];
        _phoneTextfield.textColor = RGB(175, 175, 175);
        _phoneTextfield.font = [UIFont systemFontOfSize:14];
        _phoneTextfield.backgroundColor = [UIColor whiteColor];
        _phoneTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
        label.text = @"    当前手机号";
        label.textColor = RGB_74_74_74;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        _phoneTextfield.leftView = label;
        _phoneTextfield.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextfield.userInteractionEnabled = NO;
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
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
        label.text = @"    输入验证码";
        label.textColor = RGB_74_74_74;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        _smsTextfield.leftView = label;
        _smsTextfield.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _smsTextfield;
}

- (UITextField *)newphoneTextfield {
    if (!_newphoneTextfield) {
        _newphoneTextfield = [UITextField new];
        _newphoneTextfield.textColor = RGB(175, 175, 175);
        _newphoneTextfield.font = [UIFont systemFontOfSize:14];
        _newphoneTextfield.backgroundColor = [UIColor whiteColor];
        _newphoneTextfield.placeholder = @"请输入新手机号码";
        _newphoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
        label.text = @"    新手机号";
        label.textColor = RGB_74_74_74;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        _newphoneTextfield.leftView = label;
        _newphoneTextfield.leftViewMode = UITextFieldViewModeAlways;
        
        _newphoneTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _newphoneTextfield;
}

- (ZPButton *)submmitBtn {
    if (!_submmitBtn) {
        _submmitBtn = [ZPButton new];
        [_submmitBtn setTitle:@"完成" forState:UIControlStateNormal];
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
