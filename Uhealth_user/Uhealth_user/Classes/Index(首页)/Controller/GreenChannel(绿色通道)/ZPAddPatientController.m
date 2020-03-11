//
//  ZPAddPatientController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAddPatientController.h"
#import "ZPAddPatientView.h"
#import "ZPPatientListModel.h"
@interface ZPAddPatientController ()
@property (nonatomic,strong) ZPAddPatientView *addPatientView;
@property (nonatomic,strong) UIButton *saveBtn;
@end

@implementation ZPAddPatientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initAll {
    self.title = self.model?@"编辑就医人":@"添加就医人";
  
    [self.view addSubview:self.addPatientView];
    self.addPatientView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(270)
    .topSpaceToView(self.view, 0);
    
    [self.view addSubview:self.saveBtn];
    self.saveBtn.sd_layout
    .heightIs(50)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
}

- (void)initData {
    if (self.model) {
        [self setupData];
    }
}

- (void)setupData {
    self.addPatientView.staffBtn.selected = self.model.relation.code == 1010?YES:NO;
     self.addPatientView.familyBtn.selected = self.model.relation.code == 1010?NO:YES;
    self.addPatientView.nameTextfield.text = self.model.name;
    self.addPatientView.phoneTextfield.text = self.model.telephone;
    self.addPatientView.codeTextfield.text = self.model.idCardNo;
    if (self.model.idCardType.code == 1010) {
        self.addPatientView.sfzBtn.selected = YES;
    }else if (self.model.idCardType.code == 1020) {
        self.addPatientView.hzBtn.selected = YES;
    }else if (self.model.idCardType.code == 1030) {
        self.addPatientView.jrBtn.selected = YES;
    }
}

- (void)saveAction:(UIButton *)btn {
    if (!self.addPatientView.staffBtn.isSelected && !self.addPatientView.familyBtn.isSelected) {
        [MBProgressHUD showError:@"请选择就医类型"];
        return;
    }
    if (!self.addPatientView.nameTextfield.text.length) {
        [MBProgressHUD showError:@"请输入就医人的姓名"];
        return;
    }
    if (!self.addPatientView.phoneTextfield.text.length) {
        [MBProgressHUD showError:@"请输入就医人的手机号码"];
        return;
    }
    if (![Utils checkPhoneNumber:self.addPatientView.phoneTextfield.text]) {
        [MBProgressHUD showError:@"请输入正确格式的手机号码"];
        return;
    }
    if (!self.addPatientView.sfzBtn.isSelected && !self.addPatientView.jrBtn.isSelected&& !self.addPatientView.hzBtn.isSelected) {
        [MBProgressHUD showError:@"请选择证件类型"];
        return;
    }
    
    if (!self.addPatientView.codeTextfield.text.length) {
        [MBProgressHUD showError:@"请输入就医人的证件号码"];
        return;
    }
    if(self.addPatientView.sfzBtn.isSelected && ![Utils checkIDCardNumber:self.addPatientView.codeTextfield.text]) {
        [MBProgressHUD showError:@"身份证号码格式错误!"];
        return;
    }
  
    if(self.model) {
        [MBProgressHUD showMessage:@"修改中..."];
        //更新
        NSString *relation =self.addPatientView.staffBtn.isSelected?@"STAFF":@"FAMILY";
        NSString *type = @"";
        if (self.addPatientView.sfzBtn.isSelected) {
            type = @"IDCARD";
        } else if (self.addPatientView.jrBtn.isSelected) {
            type = @"CERTIFICATE_OF_OFFICERS";
        }else if (self.addPatientView.hzBtn.isSelected) {
            type = @"PASSPORT";
        }
        NSDictionary *msg = @{@"name":self.addPatientView.nameTextfield.text,@"relation":relation,@"telephone":self.addPatientView.phoneTextfield.text,@"idCardType":type,@"idCardNo":self.addPatientView.codeTextfield.text,@"id":self.model.ID};
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"channel/medicalPerson" parameters:msg progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                 [MBProgressHUD showSuccess:@"成功更新就医人的信息"];
                if (self.updateSuceesBlock) {
                    self.updateSuceesBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
             [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPAddPatientController class]];
        
    } else {
        //添加就医人
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/green/channel/medicalPerson",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        NSString *relation =self.addPatientView.staffBtn.isSelected?@"STAFF":@"FAMILY";
        NSString *type = @"";
        if (self.addPatientView.sfzBtn.isSelected) {
            type = @"IDCARD";
        } else if (self.addPatientView.jrBtn.isSelected) {
            type = @"CERTIFICATE_OF_OFFICERS";
        }else if (self.addPatientView.hzBtn.isSelected) {
            type = @"PASSPORT";
        }
        NSDictionary *msg = @{@"name":self.addPatientView.nameTextfield.text,@"relation":relation,@"telephone":self.addPatientView.phoneTextfield.text,@"idCardType":type,@"idCardNo":self.addPatientView.codeTextfield.text};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"成功添加就医人"];
                        if (self.addSuceesBlock) {
                            self.addSuceesBlock();
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
            
            
        }] resume];
        
    }

    
}

- (ZPAddPatientView *)addPatientView {
    if (!_addPatientView) {
        _addPatientView = [ZPAddPatientView addPatientView];
    }
    return _addPatientView;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton new];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_saveBtn setBackgroundColor:ZPMyOrderDetailValueFontColor];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
@end
