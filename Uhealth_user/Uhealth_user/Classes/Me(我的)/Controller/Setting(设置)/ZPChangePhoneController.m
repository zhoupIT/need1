//
//  ZPChangePhoneController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPChangePhoneController.h"
#import "ZPButton.h"
#import "ZPUserModel.h"
#import "ZPChangePhoneSubController.h"
@interface ZPChangePhoneController ()
@property (nonatomic,strong) UITextField *currentTextfield;
@property (nonatomic,strong) ZPButton *submmitBtn;
@end

@implementation ZPChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = @"更改手机号码";
    
    [self setData];
}

- (void)setData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.currentTextfield.text = model.phone;
    }
}

- (void)changePhone {
    ZPChangePhoneSubController *changeControl = [[ZPChangePhoneSubController alloc] init];
    changeControl.currentPhone = self.currentTextfield.text;
    changeControl.updatePhoneBlock = ^(NSString *phone) {
        self.currentTextfield.text = phone;
    };
    [self.navigationController pushViewController:changeControl animated:YES];
}

- (void)setupUI {
    self.view.backgroundColor = RGB_242_242_242;
    
    self.currentTextfield = [UITextField new];
    self.submmitBtn = [ZPButton new];
    [self.view sd_addSubviews:@[self.currentTextfield,self.submmitBtn]];
    
    self.currentTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.view, 8);
    self.currentTextfield.textColor = RGB(175, 175, 175);
    self.currentTextfield.font = [UIFont systemFontOfSize:14];
    self.currentTextfield.backgroundColor = [UIColor whiteColor];
    self.currentTextfield.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
    label.text = @"当前手机号";
    label.textColor = RGB_74_74_74;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    self.currentTextfield.leftView = label;
    self.currentTextfield.userInteractionEnabled = NO;
    
    
    self.submmitBtn.sd_layout
    .topSpaceToView(self.currentTextfield, 50)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(49);
    [self.submmitBtn setTitle:@"修改手机号码" forState:UIControlStateNormal];
    self.submmitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.submmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submmitBtn.layer.masksToBounds = YES;
    self.submmitBtn.layer.cornerRadius = 8;
    [self.submmitBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
    [self.submmitBtn addTarget:self action:@selector(changePhone) forControlEvents:UIControlEventTouchUpInside];
}

@end
