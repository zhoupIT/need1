//
//  ZPAddAddressController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAddAddressController.h"
/* model */
#import "ZPAddressModel.h"
/* view */
#import "ZPAddAddressView.h"

@interface ZPAddAddressController ()
@property (nonatomic,strong) ZPAddAddressView *addView;
//日期上方的取消和确定视图
@property (nonatomic,strong) UIToolbar *inputAccessoryView;
@end

@implementation ZPAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initAll {
    self.title = self.addressType == ZPAddressTypeAdd?@"添加收货地址":@"编辑收货地址";
    self.view.backgroundColor = RGB_242_242_242;
    ZPAddAddressView *addView = [ZPAddAddressView addAddressView];
    [self.view addSubview:addView];
    addView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,8)
    .heightIs(354);
    self.addView = addView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}

- (void)initData {
    
    if (self.addressType == ZPAddressTypeEdit) {
        //设置数据
        self.addView.textField.text = [NSString stringWithFormat:@"%@%@%@",self.model.provinceName,self.model.cityName,self.model.countryName];
        self.addView.textView.text = self.model.address;
        self.addView.nameTextField.text = self.model.receiver;
        self.addView.phoneTextField.text = self.model.phone;
        self.addView.cityId = self.model.cityId;
        self.addView.counntryId = self.model.countryId;
        self.addView.provinceId = self.model.provinceId;
        self.addView.cityName = self.model.cityName;
        self.addView.countryName = self.model.countryName;
        self.addView.provinceName = self.model.provinceName;
        if ([self.model.addressStatus.name isEqualToString:@"DEFAULT"]) {
            self.addView.isSelcted.selected = YES;
        } else {
            self.addView.isSelcted.selected = NO;;
        }
    }
}

- (void)save {
    if (!self.addView.textField.text.length) {
        [MBProgressHUD showError:@"请选择省市区"];
        return;
    }
    if (!self.addView.textView.text.length) {
        [MBProgressHUD showError:@"请输入详细地址"];
        return;
    }
    if (!self.addView.nameTextField.text.length) {
        [MBProgressHUD showError:@"请输入收货人姓名"];
        return;
    }
    if (!self.addView.phoneTextField.text.length) {
        [MBProgressHUD showError:@"请输入联系方式"];
        return;
    }
    if (![Utils checkPhoneNumber:self.addView.phoneTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机格式"];
        return;
    }
    
    if (self.addressType == ZPAddressTypeAdd) {
        [MBProgressHUD showMessage:@"添加中..."];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/common/receiveAddress",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        //NO_DEFAULT DEFAULT
        NSString *addressStatus = @"";
        if (self.addView.isSelcted.isSelected) {
            addressStatus = @"DEFAULT";
        } else {
            addressStatus = @"NO_DEFAULT";
        }
        
        NSDictionary *msg = @{@"receiver":self.addView.nameTextField.text,@"phone":self.addView.phoneTextField.text,@"address":self.addView.textView.text,@"addressStatus":addressStatus,@"cityId":self.addView.cityId,@"countryId":self.addView.counntryId,@"provinceId":self.addView.provinceId,@"cityName":self.addView.cityName,@"countryName":self.addView.countryName,@"provinceName":self.addView.provinceName};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"添加地址成功"];
                        if (self.addAddressBlock) {
                            self.addAddressBlock();
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
    } else {
        //
        NSString *addressStatus = @"";
        if (self.addView.isSelcted.isSelected) {
            addressStatus = @"DEFAULT";
        } else {
            addressStatus = @"NO_DEFAULT";
        }
        if (!self.addView.cityId) {
            [MBProgressHUD showError:@"请确认地址"];
            return;
        }
        NSDictionary *msg = @{@"receiver":self.addView.nameTextField.text,@"phone":self.addView.phoneTextField.text,@"address":self.addView.textView.text,@"addressStatus":addressStatus,@"cityId":self.addView.cityId,@"countryId":self.addView.counntryId,@"provinceId":self.addView.provinceId,@"cityName":self.addView.cityName,@"countryName":self.addView.countryName,@"provinceName":self.addView.provinceName,@"id":self.model.ID};
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"receiveAddress" parameters:msg progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"修改地址成功"];
                if (self.addAddressBlock) {
                    self.addAddressBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        } className:[ZPAddAddressController class]];
    }
    
}
@end
