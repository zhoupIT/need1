//
//  ZPReservationCheckOutController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPReservationCheckOutController.h"

#import "ZPCheckOutModel.h"

#import "ZPCheckOutNoLocHeaderCell.h"
#import "ZPCheckOutHeaderCell.h"
#import "ZPCheckOutSubTitleCell.h"
#import "ZPCheckOutSubtitleIconCell.h"
#import "ZPCheckOutSubViewCell.h"
#import "ZPCheckOutScoreCell.h"
#import "ZPCheckOutRemarkCell.h"
#import "ZPCheckOutOrderCell.h"
#import "ZPCheckOutTitleCell.h"
#import "ZPCheckOutFavourCell.h"

#import "ZPCheckOutSubmitView.h"
#import "ZPCheckOutResultController.h"

#import "ZPShoppingCartCommodityModel.h"
#import "ZPCommodity.h"

#import "ZPMyAddressController.h"

#import "ZPWechatPayModel.h"
#import "WXApi.h"
#import "ZPWechatPayModel.h"
#import "WXApiManager.h"

#import "ZPAddressModel.h"

#import "ZPPayController.h"
@interface ZPReservationCheckOutController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WXApiManagerDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) ZPCheckOutSubmitView *submitView;

@property (nonatomic,strong) NSDecimalNumber *originaltotalPrice;
@property (nonatomic,strong) NSDecimalNumber *totalPrice;
@property (nonatomic,strong) NSDecimalNumber *favourPrice;

//@property (nonatomic,copy) NSString *note;

@end

@implementation ZPReservationCheckOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getData];
}

- (void)getData {
    [self.dataArray addObject: [ZPCheckOutModel creatDetailsData]];
    [self calPrice];
    [self.tableView reloadData];
    [WXApiManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)setupUI {
    self.view.backgroundColor = RGB_242_242_242;
    self.title = @"填写订单";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, IS_IPhoneX?84:50);
    
    self.submitView = [ZPCheckOutSubmitView addSubmitView];
    [self.view addSubview:self.submitView];
    self.submitView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(IS_IPhoneX?84:50)
    .bottomEqualToView(self.view);
    __weak typeof(self) weakSelf = self;
    
    self.submitView.submitBlock = ^(UIButton *btn){
        //下单
        [MBProgressHUD showMessage:@"提交中..."];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/green/channel/order",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        
        NSDictionary *msg = @{@"cityServiceId":weakSelf.serviceModel.ID,@"medicalPersonId":weakSelf.patientModel.ID,@"linkPhone":weakSelf.phoneValue,@"note":weakSelf.noti,@"hospital":weakSelf.hospitalModel?weakSelf.hospitalModel.hospitalName:@"",@"hospitalId":weakSelf.hospitalModel?weakSelf.hospitalModel.ID:@""};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        //                    [MBProgressHUD showSuccess:@"提交预约成功!"];
                        //                    [self.navigationController popViewControllerAnimated:YES];
                        
                        
                        ZPPayController *payControl = [[ZPPayController alloc] init];
                        payControl.payEnterType = ZPPayEnterTypeGreenPath;
                        payControl.orderID =[dict objectForKey:@"data"];
                        [weakSelf.navigationController pushViewController:payControl animated:YES];
                        /*
                        //微信支付
                        if (![WXApi isWXAppInstalled]) {
                            ZPLog(@"没有安装微信...");
                            [MBProgressHUD showError:@"您没有安装微信..."];
                            return;
                        }
                        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"payment/wechat" parameters:@{@"orderId":[dict objectForKey:@"data"]} progress:^(NSProgress *progress) {
                            
                        } success:^(NSURLSessionDataTask *task, id response) {
                            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                                ZPWechatPayModel *model = [ZPWechatPayModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                                PayReq *req = [[PayReq alloc] init];
                                req.openID = model.appId;
                                req.partnerId = model.partnerId;
                                req.prepayId = model.prepayId;
                                req.package = model.wxPackage;
                                req.nonceStr = model.nonceStr;
                                UInt32 timestamp = (UInt32)[model.timestamp intValue];
                                
                                req.timeStamp = timestamp;
                                req.sign = model.sign;
                                
                                if ([WXApi sendReq:req]) {
                                    NSLog(@"吊起成功");
                                } else {
                                    NSLog(@"吊起失败");
                                }
                                //生成URLscheme
                                //                    NSString *str = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",req.openID,req.nonceStr,req.partnerId,req.prepayId,model.timestamp,model.sign];
                                
                                //通过openURL的方法唤起支付界面
                                //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                            } else {
                                [MBProgressHUD showError:[response objectForKey:@"message"]];
                            }
                        } failed:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        } className:[ZPReservationCheckOutController class]];
                         */
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
            
            
        }] resume];

    };
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (section == 0) {
        return 3;
    }
    return 3;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZPCheckOutTitleCell *cell = [ZPCheckOutTitleCell cellWithTableView:tableView];
            cell.titleStr = [NSString stringWithFormat:@"下单时间:%@",self.time];
            return cell;
        }
        if (indexPath.row == 2) {
            ZPCheckOutRemarkCell *cell = [ZPCheckOutRemarkCell cellWithTableView:tableView];
            cell.remarkTextfield.text = self.noti;
            return cell;
        }
        ZPCheckOutOrderCell *cell = [ZPCheckOutOrderCell cellWithTableView:tableView];
        cell.type = self.type;
        cell.orginTotal = self.originProductAmountTotal;
        cell.total = self.orderAmountTotal;
        return cell;
    }
    else if(indexPath.section == 1) {
        
        
        ZPCheckOutSubTitleCell *cell = [ZPCheckOutSubTitleCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.subtitleStr = [NSString stringWithFormat:@"¥%@",self.originaltotalPrice];
            cell.titleStr = @"商品合计:";
        } else  if (indexPath.row == 1) {
            cell.subtitleStr = [NSString stringWithFormat:@"-¥%@",self.favourPrice];
            cell.titleStr = @"优惠金额：";
        } else if (indexPath.row == 2) {
            cell.subtitleStr = @"¥0";
            cell.titleStr = @"运费：";
        }
        return cell;
        
    }
    ZPCheckOutSubTitleCell *cell = [ZPCheckOutSubTitleCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row ==1) {
            return 110;
        }
        return 40;
    }
    return 40;
}


//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 1;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)textFieldTextChange:(NSNotification *)noti {
    UITextField *currentTextField = (UITextField *)noti.object;
    self.noti = currentTextField.text;
}

- (void)calPrice {
    //原本的价格
    self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:self.originProductAmountTotal];
    //应付价格
    self.totalPrice = [NSDecimalNumber decimalNumberWithString:self.orderAmountTotal];
    //优惠的价格
    self.favourPrice = [NSDecimalNumber decimalNumberWithString:self.reducedPrice];
    self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.orderAmountTotal];
    
}


- (void)managerDidRecvPaymentResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self checkWechatPayResult];
            break;
        case WXErrCodeUserCancel:
            [MBProgressHUD showError:@"支付失败:用户取消"];
            break;
        default:{
            [MBProgressHUD showError:@"支付失败:其他原因"];
        }
            
            break;
    }
}

- (void)checkWechatPayResult {
    //向server查询支付结果，刷新页面
    [MBProgressHUD showError:@"支付成功"];
    ZPCheckOutResultController *checkOutResultControl = [[ZPCheckOutResultController alloc] init];
    [self.navigationController pushViewController:checkOutResultControl animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
