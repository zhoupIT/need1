//
//  ZPBdingController.m
//  uhealth
//
//  Created by Biao Geng on 2018/8/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPBdingController.h"
#import "ZPLoginController.h"
@interface ZPBdingController ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *tipLabelAccount;
@property (nonatomic,strong) UIButton *bdingAccountBtn;
@property (nonatomic,strong) UILabel *tipLabelNoAccount;
@property (nonatomic,strong) UIButton *registerAccountBtn;
@end

@implementation ZPBdingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    self.nameLabel.text = [NSString stringWithFormat:@"Hi,%@",self.nickName];
}

- (void)initAll {
    self.title =@"账号绑定";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.nameLabel,self.tipLabelAccount,self.bdingAccountBtn,self.tipLabelNoAccount,self.registerAccountBtn]];
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.view, 22)
    .leftSpaceToView(self.view, 17)
    .rightSpaceToView(self.view, 17)
    .autoHeightRatio(0);
    
    self.tipLabelAccount.sd_layout
    .topSpaceToView(self.nameLabel, 29)
    .leftSpaceToView(self.view, 17)
    .rightSpaceToView(self.view, 17)
    .autoHeightRatio(0);
    
    self.bdingAccountBtn.sd_cornerRadius = @5;
    self.bdingAccountBtn.sd_layout
    .centerXEqualToView(self.view)
    .widthIs(ZPWidth(240))
    .heightIs(ZPHeight(41))
    .topSpaceToView(self.tipLabelAccount, 20);
    
    self.tipLabelNoAccount.sd_layout
    .topSpaceToView(self.bdingAccountBtn, 25)
    .leftSpaceToView(self.view, 17)
    .rightSpaceToView(self.view, 17)
    .autoHeightRatio(0);
    
    self.registerAccountBtn.sd_cornerRadius = @5;
    self.registerAccountBtn.sd_layout
    .centerXEqualToView(self.view)
    .widthIs(ZPWidth(240))
    .heightIs(ZPHeight(41))
    .topSpaceToView(self.tipLabelNoAccount, 20);
    
}

#pragma mark - private
//绑定已有的账号
- (void)bdingAccountAction {
    [self.navigationController popViewControllerAnimated:YES];
    ZPLoginController *loginControl = [[ZPLoginController alloc] init];
    loginControl.authID = self.authId;
    loginControl.accessToken = self.accessToken;
    [self.navigationController pushViewController:loginControl animated:YES];
}

//注册新账号
- (void)registeAccountAction {
    [self.navigationController popViewControllerAnimated:YES];
    ZPLoginController *loginControl = [[ZPLoginController alloc] init];
    loginControl.authID = self.authId;
    loginControl.accessToken = self.accessToken;
    loginControl.boolregist = YES;
    [self.navigationController pushViewController:loginControl animated:YES];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = ZPMyOrderDetailFontColor;
    }
    return _nameLabel;
}

- (UILabel *)tipLabelAccount {
    if (!_tipLabelAccount) {
        _tipLabelAccount = [UILabel new];
        _tipLabelAccount.textColor = RGB(153, 153, 153);
        _tipLabelAccount.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        _tipLabelAccount.text = @"如果您已注册过小优健康App账号:";
    }
    return _tipLabelAccount;
}

- (UIButton *)bdingAccountBtn {
    if (!_bdingAccountBtn) {
        _bdingAccountBtn = [UIButton new];
        [_bdingAccountBtn setTitle:@"绑定已有账号" forState:UIControlStateNormal];
        [_bdingAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bdingAccountBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        _bdingAccountBtn.backgroundColor = RGB(255,188,7);
        [_bdingAccountBtn addTarget:self action:@selector(bdingAccountAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bdingAccountBtn;
}

- (UILabel *)tipLabelNoAccount {
    if (!_tipLabelNoAccount) {
        _tipLabelNoAccount = [UILabel new];
        _tipLabelNoAccount.textColor = RGB(153, 153, 153);
        _tipLabelNoAccount.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        _tipLabelNoAccount.text = @"如果您未注册过小优健康App账号:";
    }
    return _tipLabelNoAccount;
}

- (UIButton *)registerAccountBtn {
    if (!_registerAccountBtn) {
        _registerAccountBtn = [UIButton new];
        [_registerAccountBtn setTitle:@"注册新账号" forState:UIControlStateNormal];
        [_registerAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerAccountBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        _registerAccountBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        [_registerAccountBtn addTarget:self action:@selector(registeAccountAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerAccountBtn;
}
@end
