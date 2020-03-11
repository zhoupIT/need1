//
//  ZPReservationServiceController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPReservationServiceController.h"
/* 控制器 */
#import "ZPGreenPathReservationSerController.h"
#import "ZPReservationCityListController.h"
#import "ZPPatientListController.h"
#import "ZPGreenPathHospitalController.h"
#import "ZPReservationCheckOutController.h"
#import "ZPHelpCenterController.h"
/* model */
#import "ZPReservationCityModel.h"
#import "ZPMedicalCityServiceModel.h"
#import "ZPPatientListModel.h"
#import "ZPHospitalModel.h"
#import "ZPPriceModel.h"
/* view */
#import "ZPReservationView.h"
/* 第三方 */
#import "WXApiManager.h"
#import "HSSetTableViewController.h"
@interface ZPReservationServiceController ()<WXApiManagerDelegate>
@property (nonatomic,strong) ZPReservationView *footView;
/** 就医城市    cell Model */
@property (nonatomic,strong) HSTextCellModel *city;
/** 预约服务类型 cell Model */
@property (nonatomic,strong) HSTextCellModel *type;
/** 联系方式    cell Model */
@property (nonatomic,strong) HSCustomCellModel *phone;
/** 医院       cell Model */
@property (nonatomic,strong) HSTextCellModel *hospital;
/** 就医城市 模型 */
@property (nonatomic,strong) ZPReservationCityModel *cityModel;
/** 预约服务类型 模型 */
@property (nonatomic,strong) ZPMedicalCityServiceModel *serviceModel;
/** 就医人 模型 */
@property (nonatomic,strong) ZPPatientListModel *patientModel;
/** 医院 模型 */
@property (nonatomic,strong) ZPHospitalModel *hospitalModel;
/** 联系号码 */
@property (nonatomic,copy) NSString *phoneValue;
/** 底部视图模型 */
@property (nonatomic,strong) HSFooterModel *footerModel;

@end

@implementation ZPReservationServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"在线预约";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [WXApiManager sharedManager].delegate = self;
    __weak typeof(self) weakSelf =self;
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];
    [self setupTableViewConstrint:-10 left:0 right:0 bottom:0];
    NSMutableArray *footerModels = [NSMutableArray array];
    CGFloat w = kSCREEN_WIDTH;
    CGFloat height = 0;
    if ( w <= self.processImg.width) {
        height = (w / self.processImg.width) * self.processImg.height;
    } else{
        height = self.processImg.height;
    }
    ZPReservationView *footView = [[ZPReservationView alloc] init];
    footView.processImage = self.processImg;
    footView.addPerBlock = ^{
        //添加就医人
        ZPPatientListController *patListControl = [[ZPPatientListController alloc] init];
        patListControl.selectedPatientBlock = ^(ZPPatientListModel *model) {
            weakSelf.patientModel = model;
            //更新ui
            [weakSelf.footView updateUIWithModel:model];
            if (weakSelf.serviceModel) {
                [weakSelf getPrice];
            }
            weakSelf.footerModel.footerViewHeight = 488+height;
            [weakSelf.hs_tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:patListControl animated:YES];
    };
    footView.commitAppointmentBlock = ^{
        //提交预约
        ZPLog(@"提交预约");
        [weakSelf submitOrder];
        
    };
    
    footView.deleteBlock = ^{
        weakSelf.patientModel = nil;
        weakSelf.footerModel.footerViewHeight = 438+height;
        [weakSelf.hs_tableView reloadData];
    };
    footView.callBlock = ^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",hotLineNumber];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [weakSelf.view addSubview:callWebview];
    };
    self.footView = footView;
    self.footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 438+height);
    
    HSFooterModel *footerModel = [HSFooterModel new];
    footerModel.footerView = self.footView ;
    footerModel.footerViewHeight = 438+height;
    self.footerModel = footerModel;
    
    HSFooterModel *footerModel1 = [HSFooterModel new];
    footerModel1.footerView = [UIView new] ;
    footerModel1.footerViewHeight = 10.0f;
    
    [footerModels addObject:footerModel];
    [footerModels addObject:footerModel1];
    
    [self setTableViewFooterArry:footerModels];
    
    NSMutableAttributedString * cityStr = [[NSMutableAttributedString alloc] initWithString:@"就医城市*"];
    [cityStr addAttribute:NSForegroundColorAttributeName value:RGB_74_74_74 range:NSMakeRange(0, 3)];
    [cityStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:14] range:NSMakeRange(0, 5)];
    [cityStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,1)];
    
    HSTextCellModel *city = [[HSTextCellModel alloc] initWithAttributeTitle:cityStr detailText:@"请选择城市" actionBlock:^(HSBaseCellModel *model) {
        ZPReservationCityListController *cityListControl =  [[ZPReservationCityListController alloc] init];
        cityListControl.type = ZPGreenChannelSelEnterStatusTypeCity;
        cityListControl.selectedCityBlock = ^(ZPReservationCityModel *model) {
            weakSelf.cityModel = model;
            weakSelf.city.detailText = model.name;
            [weakSelf updateCellModel:weakSelf.city];
        };
        if (weakSelf.cityModel) {
            cityListControl.cityModelSel = weakSelf.cityModel;
        }
        [weakSelf.navigationController pushViewController:cityListControl animated:YES];
    }];
    city.showArrow = YES;
    city.showLine = YES;
    self.city = city;
    
    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:@"预约服务类型*"];
    [typeStr addAttribute:NSForegroundColorAttributeName value:RGB_74_74_74 range:NSMakeRange(0, 5)];
    [typeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:14] range:NSMakeRange(0, 7)];
    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,1)];
    HSTextCellModel *type = [[HSTextCellModel alloc] initWithAttributeTitle:typeStr detailText:@"请选择服务类型" actionBlock:^(HSBaseCellModel *model) {
        if (!weakSelf.city.detailText.length || [weakSelf.city.detailText isEqualToString:@"请选择城市"]) {
            [MBProgressHUD showError:@"请先选择就医城市"];
            return;
        }
        ZPGreenPathReservationSerController *serviceControl = [[ZPGreenPathReservationSerController alloc] init];
        serviceControl.cityID =  weakSelf.cityModel.ID;
        serviceControl.selectedServiceBlock = ^(ZPMedicalCityServiceModel * _Nonnull model) {
            weakSelf.serviceModel = model;
            weakSelf.type.detailText = model.serviceTypeName;
            [weakSelf updateCellModel:weakSelf.type];
            if (weakSelf.patientModel) {
                //查询价格
                [weakSelf getPrice];
            }
        };
        if (weakSelf.serviceModel) {
            serviceControl.serviceModelSel = weakSelf.serviceModel;
        }
        [weakSelf.navigationController pushViewController:serviceControl animated:YES];
    }];
    type.showArrow = YES;
    type.showLine = YES;
    self.type = type;
    
    
    HSCustomCellModel *phone = [[HSCustomCellModel alloc] initWithCellIdentifier:@"ZPReservationTextFieldCell" actionBlock:^(HSBaseCellModel *model) {
        ZPLog(@"点击了自定义cell");
    }];
    self.phone = phone;
    
    
    HSTextCellModel *hospital = [[HSTextCellModel alloc] initWithTitle:@"医院" detailText:@"请选择医院" actionBlock:^(HSBaseCellModel *model) {
        if (!weakSelf.city.detailText.length || [weakSelf.city.detailText isEqualToString:@"请选择城市"]) {
            [MBProgressHUD showError:@"请先选择就医城市"];
            return;
        }
        if (!weakSelf.type.detailText.length || [weakSelf.type.detailText isEqualToString:@"请选择服务类型"]) {
            [MBProgressHUD showError:@"请先选择服务类型"];
            return;
        }
        ZPGreenPathHospitalController *control = [[ZPGreenPathHospitalController alloc] init];
        if (weakSelf.hospitalModel) {
            control.hospitalModelSel = weakSelf.hospitalModel;
        }
        control.cityServiceId = weakSelf.serviceModel.ID;
        control.selHospitalBlock = ^(ZPHospitalModel * _Nonnull model) {
            weakSelf.hospitalModel = model;
            weakSelf.hospital.detailText = model.hospitalName;
            [weakSelf updateCellModel:weakSelf.hospital];
        };
        [weakSelf.navigationController pushViewController:control animated:YES];
        
    }];
    hospital.titleColor = RGB_74_74_74;
    hospital.titleFont = [UIFont fontWithName:ZPPFSCRegular size:14];
    hospital.showArrow = YES;
    hospital.showLine = YES;
    self.hospital = hospital;
    
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:city,type,phone,hospital,nil];
    
    [self.hs_dataArry addObject:section0];
    [self.hs_tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleDone target:self action:@selector(helpCenter)];
}

- (void)initData {
    
}


- (void)helpCenter {
    ZPHelpCenterController *helpControl = [[ZPHelpCenterController alloc] init];
    [self.navigationController pushViewController:helpControl animated:YES];
}

- (void)getPrice {
    WEAK_SELF(weakSelf);
    //获取价格
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/order/price?cityServiceId=%@&medicalPersonId=%@",ZPBaseUrl,self.serviceModel.ID,self.patientModel.ID] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            ZPPriceModel *price = [ZPPriceModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            weakSelf.footView.model = price;
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPReservationServiceController class]];
}

- (void)submitOrder {
    if (!self.city.detailText.length || [self.city.detailText isEqualToString:@"请选择城市"]) {
        [MBProgressHUD showError:@"请先选择就医城市"];
        return;
    }
    if (!self.type.detailText.length || [self.type.detailText isEqualToString:@"请选择服务类型"]) {
        [MBProgressHUD showError:@"请选择服务类型"];
        return;
    }
    if (!self.phoneValue || !self.phoneValue.length) {
        [MBProgressHUD showError:@"请填入联系方式"];
        return;
    }
    if (![Utils checkPhoneNumber:self.phoneValue]) {
        [MBProgressHUD showError:@"请输入正确格式的手机号码"];
        return;
    }
    if (!self.patientModel) {
        [MBProgressHUD showError:@"请添加就医人"];
        return;
    }
    ZPReservationCheckOutController *checkOutControl = [[ZPReservationCheckOutController alloc] init];
    checkOutControl.patientModel = self.patientModel;
    checkOutControl.cityModel = self.cityModel;
    checkOutControl.serviceModel = self.serviceModel;
    checkOutControl.hospitalModel = self.hospitalModel;
    checkOutControl.noti = self.footView.descTextView.text;
    checkOutControl.phoneValue = self.phoneValue;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    checkOutControl.time = [format stringFromDate:[NSDate date]];
    checkOutControl.type =self.type.detailText;
    checkOutControl.originProductAmountTotal = self.footView.model.totalPay;
    checkOutControl.reducedPrice = self.footView.model.discountMoney;
    checkOutControl.logisticsFee = @"0";
    checkOutControl.orderAmountTotal = self.footView.model.finalPay;
    [self.navigationController pushViewController:checkOutControl animated:YES];
}

#pragma mark - 支付代理
- (void)managerDidRecvPaymentResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self checkWechatPayResult];
            break;
        case WXErrCodeUserCancel:
            [MBProgressHUD showError:@"支付失败:用户取消!请到'我的订单'完成支付"];
            break;
        default:{
            [MBProgressHUD showError:@"支付失败:其他原因!请到'我的订单'完成支付"];
        }
            
            break;
    }
}

- (void)checkWechatPayResult {
    //向server查询支付结果，刷新页面
    [MBProgressHUD showError:@"支付成功,请到'我的服务'查看"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldTextChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
    if (textField.tag == 10011) {
        self.phoneValue =textField.text;
    }
}

@end
