//
//  ZPModifyNameController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPModifyNameController.h"
#import "ZPUserModel.h"
@interface ZPModifyNameController ()
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation ZPModifyNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getUserName];
     self.title = @"修改昵称";
    
}

- (void)save {
    [self.view endEditing:YES];
    if (self.textField.text.length<2||self.textField.text.length>10) {
        [MBProgressHUD showError:@"昵称长度不符合要求"];
        return ;
    }
    if ([Utils stringContainsEmoji:self.textField.text]) {
        [MBProgressHUD showError:@"昵称中包含非法字符"];
        return ;
    }
    if (self.textField.text.length) {
        [MBProgressHUD showMessage:@"修改中..."];
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"modifyUserInfo" parameters:@{@"nickName":self.textField.text} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
             [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"修改成功"];
                ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                model.nickName = self.textField.text;
                [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
                if (self.updateName) {
                    self.updateName(self.textField.text);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPModifyNameController class]];
        
    } else {
        [MBProgressHUD showError:@"名字不能为空"];
    }
}

- (void)getUserName {
   
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.textField.text = model.nickName;
    }
}

- (void)setupUI {
    self.view.backgroundColor = RGB_242_242_242;
    self.textField = [UITextField new];
    [self.view addSubview:self.textField];
    self.textField.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(55)
    .topSpaceToView(self.view,8);
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 55)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.tipLabel = [UILabel new];
    [self.view addSubview:self.tipLabel];
    self.tipLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(self.textField, 16)
    .autoHeightRatio(0);
    self.tipLabel.text = @"长度为2-10个字，支持中英字母和数字任意组合";
    self.tipLabel.textColor = RGB_170_170_170;
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}

@end
