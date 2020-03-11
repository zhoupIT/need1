//
//  ZPRegisterBirthController.m
//  uhealth
//
//  Created by Biao Geng on 2018/5/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRegisterBirthController.h"
#import "YYText.h"
#import "UIButton+ZPButton.h"
#import "ZPUserModel.h"
#import "ZPBaseTabBarViewController.h"
@interface ZPRegisterBirthController ()
@property (nonatomic,strong) YYLabel *label;
@property (nonatomic,strong) UIButton *maleBtn;
@property (nonatomic,strong) UIButton *femaleBtn;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIButton *registBtn;

@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation ZPRegisterBirthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.backBtn];
    if (IS_IPhoneX) {
        self.backBtn.sd_layout
        .leftSpaceToView(self.view, 20)
        .topSpaceToView(self.view, 24+30)
        .heightIs(22)
        .widthIs(22);
    } else {
        self.backBtn.sd_layout
        .leftSpaceToView(self.view, 20)
        .topSpaceToView(self.view, 30)
        .heightIs(22)
        .widthIs(22);
    }
    
    self.label = [YYLabel new];
    //设置评论label
    NSMutableAttributedString *contentAtr = [[NSMutableAttributedString alloc]initWithString:@"请正确选择出生日期和性别，\n有助于建立智能化健康档案哦~"];
    //设置文本属性
    contentAtr.yy_font = [UIFont systemFontOfSize:14];
    contentAtr.yy_color = ZPMyOrderDetailFontColor;
    //行间距
    contentAtr.yy_lineSpacing = 6.0;
    contentAtr.yy_alignment = NSTextAlignmentCenter;
    //字间距
    [contentAtr setYy_kern:[NSNumber numberWithInt:3]];
    self.label.numberOfLines = 2;
    self.label.attributedText = contentAtr;
    [self.view addSubview:self.label];
    self.label.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(41)
    .topSpaceToView(self.view, 68);
    
    [self.view addSubview:self.maleBtn];
    self.maleBtn.sd_layout
    .leftSpaceToView(self.view, 75)
    .widthIs(75)
    .heightIs(75+22+16)
    .topSpaceToView(self.label, 50);
    
    [self.view addSubview:self.femaleBtn];
    self.femaleBtn.sd_layout
    .rightSpaceToView(self.view, 75)
    .widthIs(75)
    .heightIs(75+22+16)
    .topSpaceToView(self.label, 50);
    
    
    [self.view addSubview:self.registBtn];
    self.registBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50)
    .bottomEqualToView(self.view);
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = [UIColor whiteColor];
    //设置地区: zh-中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *resDate = [formatter dateFromString:@"1985-01-01"];
    // 设置当前显示时间
    [datePicker setDate:resDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    
    //设置时间格式
    
    //监听DataPicker的滚动
//    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    datePicker.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.registBtn, 0)
    .heightIs(185);
    self.datePicker = datePicker;
}

- (void)selBtn:(UIButton *)btn {
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = NO;
    btn.selected = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
}

- (void)pop {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registAction {
    if (!self.maleBtn.isSelected && !self.femaleBtn.isSelected) {
        [MBProgressHUD showError:@"请选择性别"];
        return;
    }
    if ([self.authId isKindOfClass:[NSNull class]] || self.authId==nil) {
        self.authId = @"";
    }
    if ([self.accessToken isKindOfClass:[NSNull class]] || self.accessToken==nil) {
        self.accessToken = @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:self.datePicker.date];
    if (self.isPersonalReg) {
        [MBProgressHUD showMessage:@"注册中"];
       
        
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"register/oneself" parameters:@{@"phoneNumber":self.phoneNumber,@"authCode":self.authCode,@"password":self.password,@"gender":[self getEngSex],@"birthday":dateStr,@"authId":self.authId,@"accessToken":self.accessToken} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"注册成功"];
                //登录
                [self loginEventWithPhone:self.phoneNumber andWithPassWord:self.password];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPRegisterBirthController class]];
        return;
    } else {
        [MBProgressHUD showMessage:@"注册中"];
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"register/company" parameters:@{@"phoneNumber":self.phoneNumber,@"authCode":self.authCode,@"password":self.password,@"companyRegisterCode":self.companyRegisterCode,@"gender":[self getEngSex],@"birthday":dateStr,@"authId":self.authId,@"accessToken":self.accessToken} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"注册成功"];
                //登录
                [self loginEventWithPhone:self.phoneNumber andWithPassWord:self.password];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPRegisterBirthController class]];
    }
}

- (void)loginEventWithPhone:(NSString *)phoneNumber andWithPassWord:(NSString *)passWord {
    [MBProgressHUD showMessage:@"登录中"];
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"login" parameters:@{@"loginName":phoneNumber,@"password":passWord} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"登录成功"];
            ZPUserModel *model = [ZPUserModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            model.phone = phoneNumber;
            [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
            ZPBaseTabBarViewController *tabbar = [[ZPBaseTabBarViewController alloc] init];
            self.view.window.rootViewController = tabbar;
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
        ZPBaseTabBarViewController *tabbar = [[ZPBaseTabBarViewController alloc] init];
        self.view.window.rootViewController = tabbar;
    } className:[ZPRegisterBirthController class]];
}

- (NSString *)getEngSex {
    if (self.maleBtn.isSelected) {
        return @"MALE";
    } else if (self.femaleBtn.isSelected) {
        return @"FEMALE";
    }
    return @"UNKNOWN";
}

- (NSString *)getChineSex {
    if (self.maleBtn.isSelected) {
        return @"男";
    } else if (self.femaleBtn.isSelected) {
        return @"女";
    }
    return @"未知";
}

- (UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [UIButton new];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registBtn setBackgroundColor:ZPMyOrderDetailValueFontColor];
        [_registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registBtn;
}

- (UIButton *)maleBtn {
    if (!_maleBtn) {
        _maleBtn = [UIButton new];
        [_maleBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        [_maleBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateSelected];
        [_maleBtn setTitle:@"男士" forState:UIControlStateNormal];
        [_maleBtn setTitle:@"男士" forState:UIControlStateSelected];
        _maleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _maleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _maleBtn.imageView.sd_layout.centerXEqualToView(_maleBtn);
        [_maleBtn setImage:[UIImage imageNamed:@"common_userMale_nosel_icon"] forState:UIControlStateNormal];
        [_maleBtn setImage:[UIImage imageNamed:@"common_userMale_icon"] forState:UIControlStateHighlighted];
        [_maleBtn setImage:[UIImage imageNamed:@"common_userMale_icon"] forState:UIControlStateSelected];
        [_maleBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:22];
          [_maleBtn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maleBtn;
}

- (UIButton *)femaleBtn {
    if (!_femaleBtn) {
        _femaleBtn = [UIButton new];
        [_femaleBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateSelected];
        [_femaleBtn setTitle:@"女士" forState:UIControlStateNormal];
        [_femaleBtn setTitle:@"女士" forState:UIControlStateSelected];
        _femaleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _femaleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _femaleBtn.imageView.sd_layout.centerXEqualToView(_femaleBtn);
        [_femaleBtn setImage:[UIImage imageNamed:@"common_userFemale_nosel_icon"] forState:UIControlStateNormal];
         [_femaleBtn setImage:[UIImage imageNamed:@"common_userFemale_icon"] forState:UIControlStateHighlighted];
        [_femaleBtn setImage:[UIImage imageNamed:@"common_userFemale_icon"] forState:UIControlStateSelected];
        [_femaleBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:22];
        [_femaleBtn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femaleBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"black_gray"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
