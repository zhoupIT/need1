//
//  ZPBindingCompanyController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPBindingCompanyController.h"
#import "ZPButton.h"
#import "ZPUserModel.h"
#import "ZPBaseTabBarViewController.h"
@interface ZPBindingCompanyController ()
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *companyCodeTextField;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) ZPButton *loginBtn;

@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation ZPBindingCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.scrollview];
    self.scrollview.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self.scrollview sd_addSubviews:@[self.imageView,self.titleLabel,self.companyCodeTextField,self.tipLabel,self.loginBtn]];
    self.imageView.sd_layout
    .leftEqualToView(self.scrollview)
    .rightEqualToView(self.scrollview)
    .heightIs(208)
    .topEqualToView(self.scrollview);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.imageView, 13)
    .leftEqualToView(self.scrollview)
    .rightEqualToView(self.scrollview)
    .heightIs(16);
    
    self.companyCodeTextField.sd_layout
    .topSpaceToView(self.titleLabel, 39)
    .leftSpaceToView(self.scrollview, 38)
    .rightSpaceToView(self.scrollview, 38)
    .heightIs(50);
    
    self.tipLabel.sd_layout
    .leftSpaceToView(self.scrollview, 55)
    .rightSpaceToView(self.scrollview, 15)
    .heightIs(14)
    .topSpaceToView(self.companyCodeTextField, 19);
    
    self.loginBtn.sd_layout
    .leftEqualToView(self.companyCodeTextField)
    .rightEqualToView(self.companyCodeTextField)
    .heightIs(50)
    .topSpaceToView(self.tipLabel, 39);
    
    [self.scrollview setupAutoContentSizeWithBottomView:self.loginBtn bottomMargin:10];
    
    self.imageView.userInteractionEnabled= YES;
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

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)regist {
    if (!self.companyCodeTextField.text.length) {
        [MBProgressHUD showError:@"企业码不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"绑定公司中..."];
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"bind" parameters:@{@"code":self.companyCodeTextField.text} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"绑定公司成功"];
            ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
            model.welcomeMessage = [response objectForKey:@"codeText"];
            model.companyName = [response objectForKey:@"data"];
            [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
//            if (self.updateComBlock) {
//                self.updateComBlock();
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            ZPBaseTabBarViewController *tabbar = [[ZPBaseTabBarViewController alloc] init];
            weakSelf.view.window.rootViewController = tabbar;
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPBindingCompanyController class]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
}

- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [UIScrollView new];
        _scrollview.backgroundColor = [UIColor whiteColor];
    }
    return _scrollview;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_banner"]];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"企业认证";
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGB(78,178,255);
    }
    return _titleLabel;
}

- (UITextField *)companyCodeTextField {
    if (!_companyCodeTextField) {
        _companyCodeTextField = [UITextField new];
        _companyCodeTextField.backgroundColor = [UIColor whiteColor];
        _companyCodeTextField.font = [UIFont systemFontOfSize:14];
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

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = ZPMyOrderBorderColor;
        _tipLabel.text = @"注：企业码是企业身份标识";
    }
    return _tipLabel;
}

- (ZPButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [ZPButton new];
        [_loginBtn setTitle:@"成为企业用户" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 25;
        [_loginBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
        [_loginBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"common_back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
