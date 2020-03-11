//
//  ZPAccountSecurityController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAccountSecurityController.h"
#import "HSSetTableViewController.h"
#import "ZPChangePhoneController.h"
#import "ZPChangePwdController.h"
#import "ZPUserModel.h"
#import "ZPAccountSecurityWxCell.h"
#import "WXApiManager.h"
#import "ZPBdingCellModel.h"
@interface ZPAccountSecurityController ()<WXApiManagerDelegate>
@property (nonatomic,strong) ZPBdingCellModel *bdingmodel;
@end

@implementation ZPAccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"账号与安全";
    self.view.backgroundColor = RGB_242_242_242;
    __weak typeof(self) weakSelf = self;
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];

   
    NSMutableArray *footerModels = [NSMutableArray array];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 29)];
    UILabel *label = [UILabel new];
    [footView addSubview:label];
    label.text = @"账号绑定后可用于快速登录";
    label.textColor = ZPMyOrderDeleteBorderColor;
    label.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    label.frame = CGRectMake(17, 17, kSCREEN_WIDTH, 12);
    
    HSFooterModel *footerModel = [HSFooterModel new];
    footerModel.footerView = footView ;
    footerModel.footerViewHeight = 29;
    
    HSFooterModel *footerModel0 = [HSFooterModel new];
    [footerModels addObject:footerModel0];
    
    [footerModels addObject:footerModel];
  
    
    [self setTableViewFooterArry:footerModels];
    
    NSString *phone = @"";
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        phone = model.phone;
    }
    HSTextCellModel *phoneNum = [[HSTextCellModel alloc] initWithTitle:@"手机号码" detailText:phone actionBlock:^(HSBaseCellModel *model) {
        ZPChangePhoneController *changePhone = [[ZPChangePhoneController alloc] init];
        [weakSelf.navigationController pushViewController:changePhone animated:YES];
    }];
    phoneNum.titleColor = RGB_74_74_74;
    phoneNum.titleFont = [UIFont systemFontOfSize:15];
    
    HSTextCellModel *pwd = [[HSTextCellModel alloc] initWithTitle:@"修改密码" detailText:@"去修改" actionBlock:^(HSBaseCellModel *model) {
        ZPChangePwdController *changePwd = [[ZPChangePwdController alloc] init];
        [weakSelf.navigationController pushViewController:changePwd animated:YES];
    }];
    pwd.titleColor = RGB_74_74_74;
    pwd.titleFont = [UIFont systemFontOfSize:15];
    
    ZPBdingCellModel *wxbding = [[ZPBdingCellModel alloc] initWithCellIdentifier:@"ZPAccountSecurityWxCell" actionBlock:^(HSBaseCellModel *model) {
        ZPLog(@"点击了自定义cell");
        ZPBdingCellModel *cellModel = (ZPBdingCellModel *)model;
        if (cellModel.bding) {
            [MBProgressHUD showMessage:@"解绑中..."];
            //绑定状态  ->解绑
            [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/common/customer/auth/wx/bind" andHTTPMethod:@"DELETE" andDict:@{} success:^(NSDictionary *response) {
                [MBProgressHUD showSuccess:@"解绑微信成功"];
                //解绑成功
                weakSelf.bdingmodel.bding = NO;
                [weakSelf.hs_tableView reloadData];
            } failed:^(NSError *error) {
                
            } withClassName:NSStringFromClass([ZPAccountSecurityController class])];
        } else {
            //未绑定状态  ->绑定
            SendAuthReq* req =[[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
        }
    }];
    self.bdingmodel = wxbding;
    
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:phoneNum,pwd,nil];
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:wxbding,nil];
    [self.hs_dataArry addObject:section0];
    [self.hs_dataArry addObject:section1];
}

- (void)initData {
    [WXApiManager sharedManager].delegate = self;
    [self  setupData];
}

- (void)setupData {
    [MBProgressHUD showMessage:@"加载中"];
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"wx/bind/status" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.bdingmodel.bding = YES;
            [weakSelf.hs_tableView reloadData];
        } else if ([[response objectForKey:@"code"] integerValue]  == 1003) {
            weakSelf.bdingmodel.bding = NO;
            [weakSelf.hs_tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
    } className:[ZPAccountSecurityController class]];
}

#pragma mark - delegate
- (void)managerDidRecvLoginResponse:(SendAuthResp *)wxresponse {
    ZPLog(@"微信登录返回:%@",wxresponse.code);
    WEAK_SELF(weakSelf);
    [MBProgressHUD showMessage:@"绑定中..."];
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"wx/bind" parameters:@{@"code":wxresponse.code} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [MBProgressHUD showSuccess:@"绑定微信成功"];
            //绑定成功
            weakSelf.bdingmodel.bding = YES;
            [weakSelf.hs_tableView reloadData];
            
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPAccountSecurityController class]];
}

@end
