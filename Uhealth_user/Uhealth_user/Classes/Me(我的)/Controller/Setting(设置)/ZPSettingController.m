//
//  ZPSettingController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPSettingController.h"
#import "HSSetTableViewController.h"
#import "ZPButton.h"

#import "ZPMyAddressController.h"
#import "ZPChangePwdController.h"
#import "ZPChangePhoneController.h"

#import "ZPLoginController.h"
#import "ZPNavigationController.h"

#import "ZPPatientListController.h"

#import "ZPBaseTabBarViewController.h"

#import "ZPAccountSecurityController.h"
@interface ZPSettingController ()
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) ZPButton *logoutBtn;
@end

@implementation ZPSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)logOut:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"退出登录"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/common/customer/auth/logout",ZPBaseUrl]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"DELETE";
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        request.HTTPBody = nil;
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"退出登录成功"];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                            [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
                        }
                        if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
                            [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
                            NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                            for (NSHTTPCookie *cookie in cookiesArray) {
                                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                            }
                        }
                        if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
                            [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
                        }
                        if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
                            [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
                        }
                        if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
                            [kUSER_DEFAULT removeObjectForKey:@"accId"];
                        }
                        if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
                            [kUSER_DEFAULT removeObjectForKey:@"token"];
                        }
                        [kUSER_DEFAULT synchronize];
                        [ZPNetWorkManager destroyInstance];
//                        ZPLoginController *loginControl = [[ZPLoginController alloc] init];
//                        ZPNavigationController *nav = [[ZPNavigationController alloc] initWithRootViewController:loginControl];
//
//                        self.view.window.rootViewController = nav;
                        
                        ZPBaseTabBarViewController *tabbar = [[ZPBaseTabBarViewController alloc] init];
                        tabbar.selectedIndex = 2;
                        self.view.window.rootViewController = tabbar;
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
        }] resume];
    } else {
//        ZPLoginController *loginControl = [[ZPLoginController alloc] init];
//        ZPNavigationController *nav = [[ZPNavigationController alloc] initWithRootViewController:loginControl];
//        self.view.window.rootViewController = nav;
        [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPSettingController class]) object:nil];
    }
}

- (void)initAll {
    self.view.backgroundColor = RGB_242_242_242;
    self.title = @"设置";
    
    __weak typeof(self) weakSelf = self;
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];
    

    NSMutableArray *footerModels = [NSMutableArray array];

    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 99)];
    self.footView.backgroundColor = RGB_242_242_242;
    
    self.logoutBtn = [[ZPButton alloc] initWithFrame:CGRectMake(30, 50, kSCREEN_WIDTH-60, 49)];
    [self.footView addSubview:self.logoutBtn];
    [self.logoutBtn setTitle:[[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]?@"退出登录":@"去登录" forState:UIControlStateNormal];
    self.logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.layer.cornerRadius = 8;
    [self.logoutBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
    [self.logoutBtn addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    
    
    HSFooterModel *footerModel0 = [HSFooterModel new];
    HSFooterModel *footerModel = [HSFooterModel new];
    footerModel.footerView = self.footView ;
    footerModel.footerViewHeight = 99.0f;
    
    [footerModels addObject:footerModel0];
    [footerModels addObject:footerModel];
    
    [self setTableViewFooterArry:footerModels];

    HSTextCellModel *address = [[HSTextCellModel alloc] initWithTitle:@"我的收货地址" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        ZPMyAddressController *myAddControl = [[ZPMyAddressController alloc] init];
        [weakSelf.navigationController pushViewController:myAddControl animated:YES];
    }];
    address.titleColor = RGB_74_74_74;
    address.titleFont = [UIFont systemFontOfSize:15];
    
    HSTextCellModel *info = [[HSTextCellModel alloc] initWithTitle:@"绿通就医人信息" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        ZPPatientListController *patientControl = [[ZPPatientListController alloc] init];
        patientControl.type = 1;
        [weakSelf.navigationController pushViewController:patientControl animated:YES];
    }];
    info.titleColor = RGB_74_74_74;
    info.titleFont = [UIFont systemFontOfSize:15];
    
    HSTextCellModel *phoneNum = [[HSTextCellModel alloc] initWithTitle:@"账号与安全" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPSettingController class]) object:nil];
        } else {
            ZPAccountSecurityController *accountSecurity = [[ZPAccountSecurityController alloc] init];
            [weakSelf.navigationController pushViewController:accountSecurity animated:YES];
        }
    }];
    phoneNum.titleColor = RGB_74_74_74;
    phoneNum.titleFont = [UIFont systemFontOfSize:15];
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:address,info,nil];
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:phoneNum,nil];
    [self.hs_dataArry addObject:section0];
    [self.hs_dataArry addObject:section1];
    
    
}

- (void)initData {
    [self.logoutBtn setTitle:[[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]?@"退出登录":@"去登录" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.logoutBtn) {
         [self.logoutBtn setTitle:[[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]?@"退出登录":@"去登录" forState:UIControlStateNormal];
    }
}

@end
