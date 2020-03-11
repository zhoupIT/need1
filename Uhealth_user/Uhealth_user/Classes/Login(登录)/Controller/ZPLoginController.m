//
//  ZPLoginController.m
//  uhealth
//
//  Created by Biao Geng on 2018/3/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLoginController.h"
/* model */
#import "ZPUserModel.h"
/* view */
#import "ZPButton.h"
/* controller */
#import "ZPBaseTabBarViewController.h"
#import "ZPForPwdController.h"
#import "ZPRegisterBirthController.h"
#import "ZPBdingController.h"
#import "ZPBaseNavigationController.h"
/* other */
#import "WXApiManager.h"

@interface ZPLoginController ()<UITextFieldDelegate,WXApiManagerDelegate>
@property (nonatomic,strong) UIScrollView *scrollview;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *pwdTextField;
@property (nonatomic,strong) ZPButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) UIButton *forpwdBtn;

@property (nonatomic,strong) UITextField *smsTextField;
@property (nonatomic,strong) UIButton *goToLogin;


@property (nonatomic,strong) UIButton *personalRegistion;
@property (nonatomic,strong) CALayer *personalLayer;
@property (nonatomic,strong) UIButton *companyRegistion;
@property (nonatomic,strong) CALayer *companyLayer;

@property (nonatomic,assign) BOOL isPersonalReg;

@property (nonatomic,strong) UITextField *companyCodeTextField;

/** 倒计时总时间 */
@property (nonatomic,assign) int secondsCountDown;
@property (nonatomic,strong) NSTimer *countDownTimer;

@property (nonatomic,strong) UIButton *smsButton;

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIButton *rightIconBtn;

//微信登录
@property (nonatomic,strong) UIButton *wxLoginButton;
@property (nonatomic,strong) UIImageView *loginTipLabel;
@end

@implementation ZPLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPersonalReg = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollview = [UIScrollView new];
    [self.view addSubview:self.scrollview];
    self.scrollview.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupUI];
    if (@available(iOS 11.0, *)) {
        self.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
     [WXApiManager sharedManager].delegate = self;
    
    if (self.authID && self.boolregist == YES) {
        [self registeAccount];
    }
}

#pragma mark - 私有方法
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

//密码可见/不可见
- (void)pwdBeSeen:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.pwdTextField.secureTextEntry = !btn.selected;
}

//登录
- (void)login {

    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    if (!self.pwdTextField.text.length) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if ([self.authID isKindOfClass:[NSNull class]] || self.authID==nil) {
        self.authID = @"";
    }
     WEAK_SELF(weakSelf);
    //注册
    if ([self.loginBtn.titleLabel.text isEqualToString:@"下一步"]) {
        
        if (!self.smsTextField.text.length) {
            [MBProgressHUD showError:@"验证码不能为空"];
            return;
        }
        if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length >16) {
            [MBProgressHUD showError:@"密码请输入6到16位字母或数字"];
            return;
        }
        if (!self.isPersonalReg) {
            if (!self.companyCodeTextField.text.length) {
                [MBProgressHUD showError:@"企业码不能为空"];
                return;
            }
        }
        [MBProgressHUD showMessage:@"加载中..."];
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"authcode/phone/check" parameters:@{@"phoneNumber":self.phoneTextField.text,@"authCode":self.smsTextField.text} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPRegisterBirthController *registerBirthControl = [[ZPRegisterBirthController alloc] init];
                registerBirthControl.phoneNumber = self.phoneTextField.text;
                registerBirthControl.authCode = self.smsTextField.text;
                registerBirthControl.password = self.pwdTextField.text;
                registerBirthControl.isPersonalReg = self.isPersonalReg;
                registerBirthControl.authId = self.authID;
                registerBirthControl.accessToken = self.accessToken;
                if (!self.isPersonalReg) {
                    registerBirthControl.companyRegisterCode = self.companyCodeTextField.text;
                }
//                [self.navigationController pushViewController:registerBirthControl animated:YES];
                [self presentViewController:registerBirthControl animated:YES completion:nil];
                
            } else {
            
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPLoginController class]];
    } else {
        [MBProgressHUD showMessage:@"登录中"];
       
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"login" parameters:@{@"loginName":self.phoneTextField.text,@"password":self.pwdTextField.text,@"authId":self.authID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"登录成功"];
                ZPUserModel *model = [ZPUserModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                model.phone = self.phoneTextField.text;
                [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
                [weakSelf.view endEditing:YES];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPLoginController class]];
    }
    
}

- (void)registeAccount {
    self.isPersonalReg = NO;
    [self updateUI];
//    [self.companyLayer removeFromSuperlayer];
//    [self.companyRegistion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.personalLayer removeFromSuperlayer];
    [self.personalRegistion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.phoneTextField.text = @"";
    self.pwdTextField.text = @"";
}

//忘记密码
- (void)forgetPwd {
    ZPForPwdController *forgetControl = [[ZPForPwdController alloc] init];
    //设置是present出来的
    forgetControl.isPresent = YES;
    ZPBaseNavigationController *nav = [[ZPBaseNavigationController alloc] initWithRootViewController:forgetControl];
    forgetControl.modifyPasswordBlock = ^{
        if (self.pwdTextField.text.length) {
            self.pwdTextField.text = @"";
        }
    };
    
//    [self.navigationController pushViewController:forgetControl animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

//gotoLogin 已经有账号去登录
- (void)gotoLogin {
    [self.phoneTextField removeFromSuperview];
    [self.pwdTextField removeFromSuperview];
    [self.loginBtn removeFromSuperview];
    [self.registerBtn removeFromSuperview];
    [self.forpwdBtn removeFromSuperview];
    [self.smsTextField removeFromSuperview];
    [self.goToLogin removeFromSuperview];
    
    [self.personalRegistion removeFromSuperview];
    [self.companyRegistion removeFromSuperview];

   
    
    [self setupUI];
    
    self.smsTextField.text = @"";
    self.phoneTextField.text = @"";
    self.pwdTextField.text = @"";
}

- (void)personalRegist {
    self.isPersonalReg = YES;
    [self.companyLayer removeFromSuperlayer];
    [self.companyRegistion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self updateUI];
    
    self.phoneTextField.text = @"";
    self.pwdTextField.text = @"";
    self.smsTextField.text = @"";
    self.companyCodeTextField.text = @"";
}

- (void)companyRegist {
    self.isPersonalReg = NO;
    [self.personalLayer removeFromSuperlayer];
    [self.personalRegistion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self updateUI];
    
    self.phoneTextField.text = @"";
    self.pwdTextField.text = @"";
    self.smsTextField.text = @"";
}

/** 获取验证码按钮 */
- (void)obtainButton:(UIButton *)sender {
    if (!self.phoneTextField.text.length) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (![Utils checkPhoneNumber:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    sender.userInteractionEnabled = NO;
    self.rightIconBtn.backgroundColor = RGB(153, 153, 153);
    //设置倒计时总时长
    self.secondsCountDown = 60;//60秒倒计时
    //开始倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法
    //设置倒计时显示的时间
    [sender setTitle:[NSString stringWithFormat:@"%ds后重试",self.secondsCountDown] forState:UIControlStateNormal];
    
    
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"/api/common/customer/auth/register/authcode/%@",self.phoneTextField.text] parameters:nil progress:^(NSProgress *progress) {

    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
         [MBProgressHUD showError:@"验证码发送失败"];
    } className:[ZPLoginController class]];
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
        self.rightIconBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        [self.countDownTimer invalidate];
    }
}

//个人注册 UI
- (void)updateUI {
    if (self.isPersonalReg) {
        [self.phoneTextField removeFromSuperview];
        [self.pwdTextField removeFromSuperview];
        [self.loginBtn removeFromSuperview];
        [self.registerBtn removeFromSuperview];
        [self.forpwdBtn removeFromSuperview];
        [self.companyCodeTextField removeFromSuperview];
        
        [self.scrollview sd_addSubviews:@[self.phoneTextField,self.smsTextField,self.pwdTextField,self.loginBtn,self.goToLogin,self.personalRegistion,self.companyRegistion]];
    } else {
        [self.phoneTextField removeFromSuperview];
        [self.pwdTextField removeFromSuperview];
        [self.loginBtn removeFromSuperview];
        [self.registerBtn removeFromSuperview];
        [self.forpwdBtn removeFromSuperview];
        [self.smsTextField removeFromSuperview];
        [self.companyCodeTextField removeFromSuperview];
        
        [self.scrollview sd_addSubviews:@[self.phoneTextField,self.smsTextField,self.pwdTextField,self.loginBtn,self.goToLogin,self.personalRegistion,self.companyRegistion,self.companyCodeTextField]];
    }
    [self.wxLoginButton removeFromSuperview];
    [self.loginTipLabel removeFromSuperview];
    
    
    self.personalRegistion.sd_layout
    .rightSpaceToView(self.scrollview, 74*[Utils ZPDeviceWidthRation])
    .widthIs(89)
    .heightIs(34)
    .topSpaceToView(self.scrollview, 208);
    
    
    self.companyRegistion.sd_layout
    .topSpaceToView(self.scrollview, 208)
    .leftSpaceToView(self.scrollview, 74*[Utils ZPDeviceWidthRation])
    .widthIs(89)
    .heightIs(34);
    
    
    self.phoneTextField.sd_layout
    .topSpaceToView(self.scrollview, 228+34)
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50);
    
    self.smsTextField.sd_layout
    .topSpaceToView(self.phoneTextField, 25)
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50);
    
    self.pwdTextField.sd_layout
    .topSpaceToView(self.phoneTextField, 100)
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50);
    
    if (!self.isPersonalReg) {
        self.companyCodeTextField.sd_layout
        .topSpaceToView(self.pwdTextField, 28)
        .leftSpaceToView(self.scrollview, 38)
        .rightSpaceToView(self.scrollview, 38)
        .heightIs(50);
        
        self.loginBtn.sd_layout
        .leftSpaceToView(self.scrollview, 38)
        .rightSpaceToView(self.scrollview, 38)
        .heightIs(50)
        .topSpaceToView(self.pwdTextField, 28+50+28);
        [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
        self.goToLogin.sd_layout
        .topSpaceToView(self.loginBtn, 19)
        .centerXEqualToView(self.scrollview)
        .heightIs(13)
        .widthIs(111);
    } else {
        self.loginBtn.sd_layout
        .leftSpaceToView(self.scrollview, 38)
        .rightSpaceToView(self.scrollview, 38)
        .heightIs(50)
        .topSpaceToView(self.pwdTextField, 28);
        [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
        self.goToLogin.sd_layout
        .topSpaceToView(self.loginBtn, 19)
        .centerXEqualToView(self.scrollview)
        .heightIs(13)
        .widthIs(111);
    }
    //添加layer
    if (self.isPersonalReg) {
        [self.personalRegistion.layer addSublayer:self.personalLayer];
        self.personalLayer.frame =CGRectMake(0, self.personalRegistion.frame.size.height-1, self.personalRegistion.frame.size.width, 1);
        [self.personalRegistion setTitleColor:RGB_78_178_255 forState:UIControlStateNormal];
    } else {
        [self.companyRegistion.layer addSublayer:self.companyLayer];
        self.companyLayer.frame =CGRectMake(0, self.companyRegistion.frame.size.height-1, self.companyRegistion.frame.size.width, 1);
        [self.companyRegistion setTitleColor:RGB_78_178_255 forState:UIControlStateNormal];
    }
    
    [self.scrollview setupAutoContentSizeWithBottomView:self.goToLogin bottomMargin:20];
}

- (void)setupUI {
    
    [self.scrollview sd_addSubviews:@[self.imageView,self.phoneTextField,self.pwdTextField,self.loginBtn,self.registerBtn,self.forpwdBtn,self.wxLoginButton,self.loginTipLabel]];
    
    self.imageView.sd_layout
    .leftEqualToView(self.scrollview)
    .topEqualToView(self.scrollview)
    .rightEqualToView(self.scrollview)
    .heightIs(ZPHeight(225));
    
    self.phoneTextField.sd_layout
    .topSpaceToView(self.imageView, 5)
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50);
    
    self.pwdTextField.sd_layout
    .topSpaceToView(self.phoneTextField, 25)
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50);
    
    self.loginBtn.sd_layout
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50)
    .topSpaceToView(self.pwdTextField, 28);
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    self.registerBtn.sd_layout
    .topSpaceToView(self.loginBtn, 19)
    .leftSpaceToView(self.scrollview, 38)
    .heightIs(13)
    .widthIs(55);
    
    self.forpwdBtn.sd_layout
    .topSpaceToView(self.loginBtn, 19)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(13)
    .widthIs(55);
    
    self.wxLoginButton.sd_layout
    .topSpaceToView(self.forpwdBtn, 76)
    .centerXEqualToView(self.scrollview)
    .widthIs(49)
    .heightIs(49);
    
    self.loginTipLabel.sd_layout
    .bottomSpaceToView(self.wxLoginButton, 18)
    .centerXEqualToView(self.scrollview)
    .widthIs(ZPWidth(320))
    .heightIs(ZPHeight(11));
    if ((self.authID && [[NSString stringWithFormat:@"%@",self.authID] length]>0) || ![WXApi isWXAppInstalled]) {
        self.wxLoginButton.hidden = YES;
        self.loginTipLabel.hidden = YES;
        [self.scrollview setupAutoHeightWithBottomView:self.forpwdBtn bottomMargin:20];
    } else {
        self.wxLoginButton.hidden = NO;
        self.loginTipLabel.height = NO;
        [self.scrollview setupAutoContentSizeWithBottomView:self.wxLoginButton bottomMargin:20];
    }
    [self.imageView addSubview:self.backBtn];
    if (IS_IPhoneX) {
        self.backBtn.sd_layout
        .leftSpaceToView(self.imageView, 20)
        .topSpaceToView(self.imageView, 24+30)
        .heightIs(22)
        .widthIs(22);
    } else {
        self.backBtn.sd_layout
        .leftSpaceToView(self.imageView, 20)
        .topSpaceToView(self.imageView, 30)
        .heightIs(22)
        .widthIs(22);
    }
}

#pragma mark - 微信登录
- (void)wxLoginAction {
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark - 微信登录返回
- (void)managerDidRecvLoginResponse:(SendAuthResp *)wxresponse {
    ZPLog(@"微信登录返回:%@",wxresponse.code);
    [MBProgressHUD showMessage:@"微信登录中..."];
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"wx/login" parameters:@{@"wxCode":wxresponse.code} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 1003) {
            //没有绑定的小优健康账号
            [weakSelf.navigationController popViewControllerAnimated:YES];
            ZPBdingController *bdingControl = [[ZPBdingController alloc] init];
            bdingControl.nickName = [[response objectForKey:@"data"] objectForKey:@"nickName"];
            bdingControl.authId = [[response objectForKey:@"data"] objectForKey:@"authId"];
            bdingControl.accessToken = [[response objectForKey:@"data"] objectForKey:@"accessToken"];
            [weakSelf.navigationController pushViewController:bdingControl animated:YES];
        } else if ([[response objectForKey:@"code"] integerValue]  == 200) {
            //有绑定的小优健康账号 登录成功
            [weakSelf.navigationController popViewControllerAnimated:YES];
            ZPUserModel *model = [ZPUserModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
     
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPLoginController class]];
    
}

#pragma mark - delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_//|~＜＞$€^£•'@#$%^&*():;.,?!<>\\_+'/\""];
    NSString *str = [tem stringByTrimmingCharactersInSet:set];
    if (![string isEqualToString:str]) {
        return NO;
    }
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
   
    [self.navigationController setNavigationBarHidden:false animated:animated];
     [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
   
    [self.navigationController setNavigationBarHidden:true animated:animated];
     [super viewWillAppear:animated];
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"login_banner"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [UITextField new];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.layer.cornerRadius = 25;
        _phoneTextField.layer.masksToBounds = YES;
        _phoneTextField.layer.borderWidth = 1;
        _phoneTextField.layer.borderColor = RGBA(0,144,255,0.32).CGColor;
        _phoneTextField.placeholder = @"请输入大陆11位手机号码";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25+20+15, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone"]];
        [view addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(view)
        .leftSpaceToView(view, 25)
        .heightIs(20)
        .widthIs(20);
        
        _phoneTextField.leftView = view;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.layer.shadowColor = RGBA(0, 162, 255,0.17).CGColor;
        _phoneTextField.layer.shadowOpacity = 1;
        _phoneTextField.layer.shadowOffset = CGSizeMake(0, 0);
        _phoneTextField.layer.shadowRadius = 5;
        
        _phoneTextField.font = ZPFont(14);
        
        _phoneTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextField;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [UITextField new];
        _pwdTextField.backgroundColor = [UIColor whiteColor];
        _pwdTextField.layer.cornerRadius = 25;
        _pwdTextField.layer.masksToBounds = YES;
        _pwdTextField.layer.borderWidth = 1;
        _pwdTextField.layer.borderColor = RGBA(0,144,255,0.32).CGColor;
        _pwdTextField.placeholder = @"密码6到16位字母或数字";
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.delegate = self;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25+20+15, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        [view addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(view)
        .leftSpaceToView(view, 25)
        .heightIs(20)
        .widthIs(20);
        
        _pwdTextField.leftView = view;
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25+16, 50)];
        rightView.backgroundColor = [UIColor whiteColor];
        
        UIButton *righticonView = [UIButton new];
        [rightView addSubview:righticonView];
        
        [righticonView setImage:[UIImage imageNamed:@"login_pwd_no"] forState:UIControlStateNormal];
        [righticonView setImage:[UIImage imageNamed:@"login_pwd"] forState:UIControlStateSelected];
        
        [righticonView addTarget:self action:@selector(pwdBeSeen:) forControlEvents:UIControlEventTouchUpInside];
        
        righticonView.sd_layout
        .centerYEqualToView(rightView)
        .rightSpaceToView(rightView, 25)
        .heightIs(16)
        .widthIs(16);
        
        _pwdTextField.rightView = rightView;
        _pwdTextField.rightViewMode = UITextFieldViewModeAlways;
        
        
        _pwdTextField.layer.shadowColor = RGBA(0, 162, 255,0.17).CGColor;
        _pwdTextField.layer.shadowOpacity = 1;
        _pwdTextField.layer.shadowOffset = CGSizeMake(0, 0);
        _pwdTextField.layer.shadowRadius = 5;
         _pwdTextField.font = ZPFont(14);
        _pwdTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
    }
    return _pwdTextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [ZPButton new];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 25;
        [_loginBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:RGB(90,174,255) forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerBtn addTarget:self action:@selector(registeAccount) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
}

- (UIButton *)forpwdBtn {
    if (!_forpwdBtn) {
        _forpwdBtn = [UIButton new];
        [_forpwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forpwdBtn setTitleColor:RGB(255,131,77) forState:UIControlStateNormal];
        _forpwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_forpwdBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forpwdBtn;
}

- (UITextField *)smsTextField {
    if (!_smsTextField) {
        _smsTextField = [UITextField new];
        _smsTextField.backgroundColor = [UIColor whiteColor];
        _smsTextField.layer.cornerRadius = 25;
        _smsTextField.layer.masksToBounds = YES;
        _smsTextField.layer.borderWidth = 1;
        _smsTextField.layer.borderColor = RGBA(0,144,255,0.32).CGColor;
        _smsTextField.placeholder = @"请输入验证码";
        _smsTextField.font = ZPFont(14);
        _smsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _smsTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25+20+15, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_yms"]];
        [view addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(view)
        .leftSpaceToView(view, 25)
        .heightIs(20)
        .widthIs(20);
        _smsTextField.leftView = view;
        _smsTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25+75, 50)];
        rightView.backgroundColor = [UIColor whiteColor];
        
        UIButton *righticonView = [UIButton new];
        [rightView addSubview:righticonView];
        righticonView.layer.cornerRadius = 5;
        righticonView.layer.masksToBounds = YES;
        
        [righticonView setTitle:@"获取验证码" forState:UIControlStateNormal];
        righticonView.titleLabel.font = ZPFont(13);
        righticonView.backgroundColor = ZPMyOrderDetailValueFontColor;

        
        [righticonView addTarget:self action:@selector(obtainButton:) forControlEvents:UIControlEventTouchUpInside];
        
        righticonView.sd_layout
        .centerYEqualToView(rightView)
        .rightSpaceToView(rightView, 25)
        .heightIs(27)
        .widthIs(75);
        self.rightIconBtn = righticonView;
        
        _smsTextField.rightView = rightView;
        _smsTextField.rightViewMode = UITextFieldViewModeAlways;
        
        self.smsButton = righticonView;
        
        
        
        _smsTextField.layer.shadowColor = RGBA(0, 162, 255,0.17).CGColor;
        _smsTextField.layer.shadowOpacity = 1;
        _smsTextField.layer.shadowOffset = CGSizeMake(0, 0);
        _smsTextField.layer.shadowRadius = 5;
    }
    return _smsTextField;
}

- (UIButton *)goToLogin {
    if (!_goToLogin) {
        _goToLogin = [UIButton new];
        [_goToLogin setTitle:@"已有账号，去登录" forState:UIControlStateNormal];
        [_goToLogin setTitleColor:RGB_74_74_74 forState:UIControlStateNormal];
        _goToLogin.titleLabel.font = [UIFont systemFontOfSize:13];
        _goToLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_goToLogin addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goToLogin;
}

- (UIButton *)personalRegistion {
    if (!_personalRegistion) {
        _personalRegistion = [UIButton new];
        [_personalRegistion setTitle:@"个人注册" forState:UIControlStateNormal];
        [_personalRegistion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _personalRegistion.titleLabel.font = ZPFont(17);
        [_personalRegistion addTarget:self action:@selector(personalRegist) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personalRegistion;
}

- (UIButton *)companyRegistion {
    if (!_companyRegistion) {
        _companyRegistion = [UIButton new];
        [_companyRegistion setTitle:@"企业注册" forState:UIControlStateNormal];
        [_companyRegistion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _companyRegistion.titleLabel.font = ZPFont(17);
        [_companyRegistion addTarget:self action:@selector(companyRegist) forControlEvents:UIControlEventTouchUpInside];
    }
   return _companyRegistion;
}

- (UITextField *)companyCodeTextField {
    if (!_companyCodeTextField) {
        _companyCodeTextField = [UITextField new];
        _companyCodeTextField.backgroundColor = [UIColor whiteColor];
        _companyCodeTextField.font = ZPFont(14);
        _companyCodeTextField.layer.cornerRadius = 25;
        _companyCodeTextField.layer.masksToBounds = YES;
        _companyCodeTextField.layer.borderWidth = 1;
        _companyCodeTextField.layer.borderColor = RGBA(0,144,255,0.32).CGColor;
        _companyCodeTextField.placeholder = @"请输入所在企业发放的服务卡卡号";
        _companyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25+20+15, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_companyCode"]];
        [view addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(view)
        .leftSpaceToView(view, 25)
        .heightIs(20)
        .widthIs(20);
        
        _companyCodeTextField.leftView = view;
        _companyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        _companyCodeTextField.layer.shadowColor = RGBA(0, 162, 255,0.17).CGColor;
        _companyCodeTextField.layer.shadowOpacity = 1;
        _companyCodeTextField.layer.shadowOffset = CGSizeMake(0, 0);
        _companyCodeTextField.layer.shadowRadius = 5;
    }
    return _companyCodeTextField;
}

- (CALayer *)personalLayer {
    if (!_personalLayer) {
        _personalLayer = [CALayer layer];
        _personalLayer.backgroundColor = RGB_78_178_255.CGColor;
    }
    return _personalLayer;
}

- (CALayer *)companyLayer {
    if (!_companyLayer) {
        _companyLayer = [CALayer layer];
        _companyLayer.backgroundColor = RGB_78_178_255.CGColor;
    }
    return _companyLayer;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"common_back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)wxLoginButton {
    if (!_wxLoginButton) {
        _wxLoginButton = [UIButton new];
        [_wxLoginButton setImage:[UIImage imageNamed:@"login_wexin"] forState:UIControlStateNormal];
        [_wxLoginButton addTarget:self action:@selector(wxLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxLoginButton;
}

- (UIImageView *)loginTipLabel {
    if (!_loginTipLabel) {
        _loginTipLabel = [UIImageView new];
        _loginTipLabel.image = [UIImage imageNamed:@"login_tip"];
    }
    return _loginTipLabel;
}
@end
