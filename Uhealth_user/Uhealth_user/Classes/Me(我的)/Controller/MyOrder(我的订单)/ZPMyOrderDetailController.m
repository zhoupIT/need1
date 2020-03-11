//
//  ZPMyOrderDetailController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyOrderDetailController.h"
#import "ZPCheckOutOrderCell.h"
#import "ZPWechatPayModel.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "ZPCommentView.h"
#import "ZPPayController.h"
#import "ZPTracesController.h"
@interface ZPMyOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *locImageView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *userPhoneLabel;
@property (nonatomic,strong) UILabel *locLabel;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UIImageView *lineImageView;


//
@property (nonatomic,strong) UILabel *yxLabel;
@property (nonatomic,strong) UILabel *statusLabel;

//商品列表
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *orderNumLabel;
@property (nonatomic,strong) UILabel *orderNumValueLabel;

@property (nonatomic,strong) UILabel *buyTimeLabel;
@property (nonatomic,strong) UILabel *buyTimeValueLabel;

@property (nonatomic,strong) UILabel *payLabel;
@property (nonatomic,strong) UILabel *payValueLabel;

@property (nonatomic,strong) UILabel *totalLabel;
@property (nonatomic,strong) UILabel *totalValueLabel;

//优惠金额
@property (nonatomic,strong) UILabel *preferentialLabel;
@property (nonatomic,strong) UILabel *preferentialValueLabel;

//运费
@property (nonatomic,strong) UILabel *freightLabel;
@property (nonatomic,strong) UILabel *freightValueLabel;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *sjPayLabel;
@property (nonatomic,strong) UILabel *sjPayValueLabel;


//应付
@property (nonatomic,strong) UILabel *yfLabel;
@property (nonatomic,strong) UILabel *yfValueLabel;

@property (nonatomic,strong) UIButton *payButton;
@property (nonatomic,strong) UIButton *leftButton;


//商品信息
@property (nonatomic,strong) UIImageView *orderImageView;
@property (nonatomic,strong) UILabel *orderNameLabel;
@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *orderPriceLabel;

//白色背景
@property (nonatomic,strong) UIView *whiteBackView1;
@property (nonatomic,strong) UIView *whiteBackView2;
@property (nonatomic,strong) UIView *whiteBackView3;
@property (nonatomic,strong) UIView *whiteBackView4;


@property (nonatomic,strong) NSMutableArray *datas;
@end

@implementation ZPMyOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setData];
   [WXApiManager sharedManager].delegate = self;
}

#pragma -mark 私有方法
//设置数据
- (void)setData {
    self.tableView.sd_layout
    .heightIs(110*self.orderModel.orderItems.count);
    [self.tableView reloadData];
    self.userNameLabel.text = self.orderModel.recipientsName;
    self.userPhoneLabel.text = self.orderModel.recipientsTelephone;
    self.locLabel.text= self.orderModel.address;
    
    self.statusLabel.text = self.orderModel.orderStatus.text;
    //订单号
    self.orderNumValueLabel.text = self.orderModel.serialNumber;
    self.buyTimeValueLabel.text = self.orderModel.createDate;
    //支付方式
    self.payValueLabel.text = self.orderModel.payMethod.text;
    //商品合计
    self.totalValueLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.originProductAmountTotal];
    //优惠金额
    self.preferentialValueLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.reducedPrice];
    //运费
    self.freightValueLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.logisticsFee];
    //实付款
    self.sjPayValueLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.orderAmountTotal];
    //应付
    self.yfValueLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.orderAmountTotal];
    
    //处理不同类型的订单
    [self handleOrderType];
    
    if (self.orderModel.orderType.code == 1010) {
        self.whiteBackView3.hidden = YES;
        
        self.whiteBackView1.sd_layout
        .topSpaceToView(self.scrollView,0);
        
        self.yxLabel.text = @"绿通服务";
    }
}

- (void)handleOrderType {
    
    if ([self.orderModel.orderStatus.name isEqualToString:@"NON_PAYMENT"]) {
        //待付款
        
    } else if ([self.orderModel.orderStatus.name isEqualToString:@"NON_SEND"]) {
        //待发货
        self.whiteBackView4.hidden = YES;
    }else if ([self.orderModel.orderStatus.name isEqualToString:@"NON_RECIEVE"]) {
        //待收货
        self.yfLabel.hidden = YES;
        self.yfValueLabel.hidden = YES;
        
        [self.leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.payButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([self.orderModel.orderStatus.name isEqualToString:@"CANCELED_CANC"]) {
        //已关闭
         self.whiteBackView4.hidden = YES;
    }else if ([self.orderModel.orderStatus.name isEqualToString:@"NON_EVALUATED"]) {
        //待评价
        self.yfLabel.hidden = YES;
        self.yfValueLabel.hidden = YES;
    
        [self.leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.payButton setTitle:@"评价" forState:UIControlStateNormal];
    }else if ([self.orderModel.orderStatus.name isEqualToString:@"OFF_THE_STOCKS"]) {
        //已完成
        self.whiteBackView4.hidden = YES;
    }else {
        //其它
        self.whiteBackView4.hidden = YES;
    }
}

- (void)selectLoc {
    ZPLog(@"选择地点");
}

- (void)cancleOrder {
//    [EBBannerView showWithContent:@"取消订单成功"];
    if ([self.leftButton.titleLabel.text isEqualToString:@"取消订单"]) {
        [MBProgressHUD showMessage:@"取消中..."];
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWithUrlString:[NSString stringWithFormat:@"/api/order/order/cancellation/%@",self.orderModel.orderId] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"订单取消成功"];
                if (self.updateTableBlock) {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.updateTableBlock();
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMyOrderDetailController class]];
    } else if ([self.leftButton.titleLabel.text isEqualToString:@"删除订单"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
            message:@"订单删除后将不恢复!"
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {
                [MBProgressHUD showMessage:@"删除中..."];
                //删除
                NSMutableArray *idDeleteArray = [NSMutableArray array];
                [idDeleteArray addObject:self.orderModel.orderId];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/order/order",ZPBaseUrl]];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                
                request.HTTPMethod = @"DELETE";
                
                request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
                
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:idDeleteArray options:NSJSONWritingPrettyPrinted error:nil];
                
                request.HTTPBody = data;
                
                [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                        if (error == nil) {
                            NSDictionary *dict = [data mj_JSONObject];
                            if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                                [MBProgressHUD showSuccess:@"删除订单成功"];
                                if (self.updateTableBlock) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                    self.updateTableBlock();
                                }
                            } else {
                                [MBProgressHUD showError:[dict objectForKey:@"message"]];
                            }
                        } else {
                            [MBProgressHUD showError:error.localizedDescription];
                        }
                    });
                }] resume];
                
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {
               
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([self.leftButton.titleLabel.text isEqualToString:@"查看物流"]) {
        ZPTracesController *tracesControl = [[ZPTracesController alloc] init];
        tracesControl.orderId = self.orderModel.orderId;
        [self.navigationController pushViewController:tracesControl animated:YES];
    }
    
}

- (void)pay {

    if ([self.payButton.titleLabel.text isEqualToString:@"付款"]) {
        ZPPayController *payControl = [[ZPPayController alloc] init];
        payControl.orderID =self.orderModel.orderId;
        [self.navigationController pushViewController:payControl animated:YES];
    } else if ([self.payButton.titleLabel.text isEqualToString:@"评价"]) {
        ZPCommentView *view = [[ZPCommentView alloc] initWithFrame:CGRectMake(0, 0, 302, 0)];
        
        view.closeBlock = ^{
            
            [LEEAlert closeWithCompletionBlock:nil];
        };
        view.updateBlock = ^(NSInteger count, NSString *content) {
            [LEEAlert closeWithCompletionBlock:^{
                ZPLog(@"您给出了%ld颗星,评价的内容是%@",count,content);
                if (count == 0) {
                    [MBProgressHUD showError:@"请先打分"];
                    return ;
                }
                [MBProgressHUD showMessage:@"加载中..."];
                [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"order" parameters:@{@"orderId":self.orderModel.orderId,@"evaluateLevel":[NSNumber numberWithInteger:count],@"evaluateContent":content} progress:^(NSProgress *progress) {
                    
                } success:^(NSURLSessionDataTask *task, id response) {
                    [MBProgressHUD hideHUD];
                    if ([[response objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"评价成功!"];
                        if (self.updateTableBlock) {
                            [self.navigationController popViewControllerAnimated:YES];
                            self.updateTableBlock();
                        }
                    } else {
                        
                        [MBProgressHUD showError:[response objectForKey:@"message"]];
                    }
                } failed:^(NSURLSessionDataTask *task, NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:error.localizedDescription];
                } className:[ZPMyOrderDetailController class]];
            }];
        };
        
        [LEEAlert alert].config
        .LeeCustomView(view)
        .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeShow();
    } else if ([self.payButton.titleLabel.text isEqualToString:@"确认收货"]){
        [MBProgressHUD showMessage:@"加载中..."];
        //确认收货
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"order/receipt/confirm" parameters:@{@"orderId":self.orderModel.orderId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                 [MBProgressHUD showSuccess:@"收货成功!"];
                if (self.updateTableBlock) {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.updateTableBlock();
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
         [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMyOrderDetailController class]];
    }
    
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
    if (self.updateTableBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        self.updateTableBlock();
    }
    
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orderModel.orderItems.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPCheckOutOrderCell *cell = [ZPCheckOutOrderCell cellWithTableView:tableView];
    cell.itemModel = self.orderModel.orderItems[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)setupUI {
    self.title = @"订单详情";
    
    self.view.backgroundColor = RGB_242_242_242;
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.whiteBackView4];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.scrollView sd_addSubviews:@[self.whiteBackView1,self.whiteBackView2,self.whiteBackView3]];
    ZPLog(@"%ld",self.orderModel.orderType.code);
    //---------地址  用户信息
    self.whiteBackView3.sd_layout
    .autoHeightRatio(0)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .topEqualToView(self.scrollView);
    [self.whiteBackView3 sd_addSubviews:@[self.locImageView,self.userNameLabel,self.userPhoneLabel,self.locLabel,self.rightImageView,self.lineImageView]];
    self.locImageView.sd_layout
    .leftSpaceToView(self.whiteBackView3, 15)
    .widthIs(20)
    .heightIs(20)
    .centerYEqualToView(self.whiteBackView3);
    
    self.rightImageView.sd_layout
    .heightIs(18)
    .rightSpaceToView(self.whiteBackView3, 15)
    .centerYEqualToView(self.whiteBackView3)
    .widthIs(18);
    self.rightImageView.hidden = YES;
    
    self.userNameLabel.sd_layout
    .leftSpaceToView(self.locImageView, 15)
    .topSpaceToView(self.whiteBackView3, 23)
    .heightIs(13);
    [self.userNameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.userPhoneLabel.sd_layout
    .leftSpaceToView(self.userNameLabel, 15)
    .centerYEqualToView(self.userNameLabel)
    .heightIs(13);
    [self.userPhoneLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    
    self.locLabel.sd_layout
    .topSpaceToView(self.userNameLabel, 17)
    .leftEqualToView(self.userNameLabel)
    .heightIs(12)
    .rightSpaceToView(self.rightImageView, 5);
    
    self.lineImageView.sd_layout
    .topSpaceToView(self.locLabel, 21)
    .heightIs(2)
    .leftEqualToView(self.whiteBackView3)
    .rightEqualToView(self.whiteBackView3);
    
    [self.whiteBackView3 setupAutoHeightWithBottomView:self.lineImageView bottomMargin:0];
    
    
    //---------优选商城
    self.whiteBackView1.sd_layout
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .topSpaceToView(self.whiteBackView3,12)
    .autoHeightRatio(0);
    
    [self.whiteBackView1 sd_addSubviews:@[self.yxLabel,self.statusLabel,self.orderNumLabel,self.orderNumValueLabel,self.buyTimeLabel,self.buyTimeValueLabel,self.tableView]];
    
    self.yxLabel.sd_layout
    .topSpaceToView(self.whiteBackView1, 15)
    .leftSpaceToView(self.whiteBackView1, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.statusLabel.sd_layout
    .rightSpaceToView(self.whiteBackView1, 15)
    .heightIs(13)
    .leftSpaceToView(self.yxLabel, 10)
    .topSpaceToView(self.whiteBackView1, 15);
    
    self.tableView.sd_layout
    .topSpaceToView(self.yxLabel, 15)
    .leftEqualToView(self.whiteBackView1)
    .rightEqualToView(self.whiteBackView1);
    
    self.orderNumLabel.sd_layout
    .topSpaceToView(self.tableView, 15)
    .leftSpaceToView(self.whiteBackView1, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.orderNumValueLabel.sd_layout
    .leftSpaceToView(self.orderNumLabel, 10)
    .rightSpaceToView(self.whiteBackView1, 15)
    .heightIs(10)
    .centerYEqualToView(self.orderNumLabel);
    
    self.buyTimeLabel.sd_layout
    .topSpaceToView(self.orderNumLabel, 14)
    .leftSpaceToView(self.whiteBackView1, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.buyTimeValueLabel.sd_layout
    .leftSpaceToView(self.buyTimeLabel, 10)
    .rightSpaceToView(self.whiteBackView1, 15)
    .heightIs(10)
    .centerYEqualToView(self.buyTimeLabel);
    
    [self.whiteBackView1 setupAutoHeightWithBottomView:self.buyTimeLabel bottomMargin:15];
    
    
    //-------------支付方式
    self.whiteBackView2.sd_layout
    .topSpaceToView(self.whiteBackView1, 12)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .autoHeightRatio(0);
    
    [self.whiteBackView2 sd_addSubviews:@[self.payLabel,self.payValueLabel,self.totalLabel,self.totalValueLabel,self.preferentialLabel,self.preferentialValueLabel,self.freightLabel,self.freightValueLabel,self.lineView,self.sjPayLabel,self.sjPayValueLabel]];
    
    self.payLabel.sd_layout
    .topSpaceToView(self.whiteBackView2, 14)
    .leftSpaceToView(self.whiteBackView2, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.payValueLabel.sd_layout
    .leftSpaceToView(self.payLabel, 10)
    .rightSpaceToView(self.whiteBackView2, 15)
    .heightIs(10)
    .centerYEqualToView(self.payLabel);
    
    self.totalLabel.sd_layout
    .topSpaceToView(self.payLabel, 14)
    .leftSpaceToView(self.whiteBackView2, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.totalValueLabel.sd_layout
    .leftSpaceToView(self.totalLabel, 10)
    .rightSpaceToView(self.whiteBackView2, 15)
    .heightIs(10)
    .centerYEqualToView(self.totalLabel);
    
    self.preferentialLabel.sd_layout
    .topSpaceToView(self.totalLabel, 14)
    .leftSpaceToView(self.whiteBackView2, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.preferentialValueLabel.sd_layout
    .leftSpaceToView(self.preferentialLabel, 10)
    .rightSpaceToView(self.whiteBackView2, 15)
    .heightIs(10)
    .centerYEqualToView(self.preferentialLabel);
    
    self.freightLabel.sd_layout
    .topSpaceToView(self.preferentialLabel, 14)
    .leftSpaceToView(self.whiteBackView2, 15)
    .widthIs(60)
    .heightIs(13);
    
    self.freightValueLabel.sd_layout
    .leftSpaceToView(self.freightLabel, 10)
    .rightSpaceToView(self.whiteBackView2, 15)
    .heightIs(10)
    .centerYEqualToView(self.freightLabel);
    
    self.lineView.sd_layout
    .leftEqualToView(self.whiteBackView2)
    .rightEqualToView(self.whiteBackView2)
    .heightIs(1)
    .topSpaceToView(self.freightLabel, 15);
    
    self.sjPayValueLabel.sd_layout
    .topSpaceToView(self.lineView, 15)
    .rightSpaceToView(self.whiteBackView2, 15)
    .heightIs(13);
    
    self.sjPayLabel.sd_layout
    .rightSpaceToView(self.sjPayValueLabel, 5)
    .heightIs(15)
    .centerYEqualToView(self.sjPayValueLabel);
    
    [self.sjPayValueLabel setSingleLineAutoResizeWithMaxWidth:(kSCREEN_WIDTH-100)];
    [self.sjPayLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [self.whiteBackView2 setupAutoHeightWithBottomView:self.sjPayLabel bottomMargin:15];
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.whiteBackView2 bottomMargin:100];
    
    //----------  付款
    self.whiteBackView4.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50)
    .bottomEqualToView(self.view);
    
    [self.whiteBackView4 sd_addSubviews:@[self.payButton,self.leftButton,self.yfLabel,self.yfValueLabel]];
    self.payButton.sd_layout
    .rightSpaceToView(self.whiteBackView4, 15)
    .centerYEqualToView(self.whiteBackView4)
    .widthIs(68)
    .heightIs(26);
    
    self.leftButton.sd_layout
    .rightSpaceToView(self.payButton, 8)
    .centerYEqualToView(self.whiteBackView4)
    .widthIs(68)
    .heightIs(26);
    
    self.yfLabel.sd_layout
    .leftSpaceToView(self.whiteBackView4, 15)
    .heightIs(14)
    .widthIs(30)
    .centerYEqualToView(self.whiteBackView4);
    
    self.yfValueLabel.sd_layout
    .bottomEqualToView(self.yfLabel)
    .leftSpaceToView(self.yfLabel, 5)
    .heightIs(13)
    .rightSpaceToView(self.leftButton, 5);
    
}


- (UILabel *)yxLabel {
    if (!_yxLabel) {
        _yxLabel = [UILabel new];
        _yxLabel.font = [UIFont systemFontOfSize:13];
        _yxLabel.textColor = ZPMyOrderDetailFontColor;
        _yxLabel.text = @"优选商城";
    }
    return _yxLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textColor = ZPMyOrderDetailValueFontColor;
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.text = @"待收货";
    }
    return _statusLabel;
}

- (UILabel *)orderNumLabel {
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
        _orderNumLabel.font = [UIFont systemFontOfSize:13];
        _orderNumLabel.textColor = ZPMyOrderDetailFontColor;
        _orderNumLabel.text = @"订单号：";
    }
    return _orderNumLabel;
}


- (UILabel *)orderNumValueLabel {
    if (!_orderNumValueLabel) {
        _orderNumValueLabel = [UILabel new];
        _orderNumValueLabel.font = [UIFont systemFontOfSize:13];
        _orderNumValueLabel.textColor = ZPMyOrderDeleteBorderColor;
        _orderNumValueLabel.textAlignment = NSTextAlignmentRight;
        _orderNumValueLabel.text = @"- -";
    }
    return _orderNumValueLabel;
}

- (UILabel *)buyTimeLabel {
    if (!_buyTimeLabel) {
        _buyTimeLabel = [UILabel new];
        _buyTimeLabel.font = [UIFont systemFontOfSize:13];
        _buyTimeLabel.textColor = ZPMyOrderDetailFontColor;
        _buyTimeLabel.text = @"下单时间:";
    }
    return _buyTimeLabel;
}


- (UILabel *)buyTimeValueLabel {
    if (!_buyTimeValueLabel) {
        _buyTimeValueLabel = [UILabel new];
        _buyTimeValueLabel.font = [UIFont systemFontOfSize:13];
        _buyTimeValueLabel.textColor = ZPMyOrderDeleteBorderColor;
        _buyTimeValueLabel.textAlignment = NSTextAlignmentRight;
        _buyTimeValueLabel.text = @"- -";
    }
    return _buyTimeValueLabel;
}

- (UILabel *)payLabel {
    if (!_payLabel) {
        _payLabel = [UILabel new];
        _payLabel.font = [UIFont systemFontOfSize:13];
        _payLabel.textColor = ZPMyOrderDetailFontColor;
        _payLabel.text = @"支付方式:";
    }
    return _payLabel;
}


- (UILabel *)payValueLabel {
    if (!_payValueLabel) {
        _payValueLabel = [UILabel new];
        _payValueLabel.font = [UIFont systemFontOfSize:13];
        _payValueLabel.textColor = ZPMyOrderDeleteBorderColor;
        _payValueLabel.textAlignment = NSTextAlignmentRight;
        _payValueLabel.text = @"微信";
    }
    return _payValueLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.font = [UIFont systemFontOfSize:13];
        _totalLabel.textColor = ZPMyOrderDetailFontColor;
        _totalLabel.text = @"商品合计:";
    }
    return _totalLabel;
}


- (UILabel *)totalValueLabel {
    if (!_totalValueLabel) {
        _totalValueLabel = [UILabel new];
        _totalValueLabel.font = [UIFont systemFontOfSize:13];
        _totalValueLabel.textColor = ZPMyOrderDeleteBorderColor;
        _totalValueLabel.textAlignment = NSTextAlignmentRight;
        _totalValueLabel.text = @"¥0";
    }
    return _totalValueLabel;
}

- (UILabel *)preferentialLabel {
    if (!_preferentialLabel) {
        _preferentialLabel = [UILabel new];
        _preferentialLabel.font = [UIFont systemFontOfSize:13];
        _preferentialLabel.textColor = ZPMyOrderDetailFontColor;
        _preferentialLabel.text = @"优惠金额:";
    }
    return _preferentialLabel;
}


- (UILabel *)preferentialValueLabel {
    if (!_preferentialValueLabel) {
        _preferentialValueLabel = [UILabel new];
        _preferentialValueLabel.font = [UIFont systemFontOfSize:13];
        _preferentialValueLabel.textColor = ZPMyOrderDeleteBorderColor;
        _preferentialValueLabel.textAlignment = NSTextAlignmentRight;
        _preferentialValueLabel.text = @"-¥0";
    }
    return _preferentialValueLabel;
}

- (UILabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel = [UILabel new];
        _freightLabel.font = [UIFont systemFontOfSize:13];
        _freightLabel.textColor = ZPMyOrderDetailFontColor;
        _freightLabel.text = @"运费:";
    }
    return _freightLabel;
}


- (UILabel *)freightValueLabel {
    if (!_freightValueLabel) {
        _freightValueLabel = [UILabel new];
        _freightValueLabel.font = [UIFont systemFontOfSize:13];
        _freightValueLabel.textColor = ZPMyOrderDeleteBorderColor;
        _freightValueLabel.textAlignment = NSTextAlignmentRight;
        _freightValueLabel.text = @"¥0";
    }
    return _freightValueLabel;
}

- (UIImageView *)orderImageView {
    if (!_orderImageView) {
        _orderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_placeholder_icon"]];
        _orderImageView.layer.cornerRadius=  5;
        _orderImageView.layer.masksToBounds = YES;
    }
    return _orderImageView;
}

- (UILabel *)orderNameLabel {
    if (!_orderNameLabel) {
        _orderNameLabel = [UILabel new];
        _orderNameLabel.textColor = ZPMyOrderDetailFontColor;
        _orderNameLabel.font = [UIFont systemFontOfSize:13];
        _orderNameLabel.text = @"- -";
    }
    return _orderNameLabel;
}

- (UILabel *)orderTypeLabel {
    if (!_orderTypeLabel) {
        _orderTypeLabel = [UILabel new];
        _orderTypeLabel.textColor = ZPMyOrderDeleteBorderColor;
        _orderTypeLabel.text = @"服务类型 单次";
        _orderTypeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _orderTypeLabel;
}

- (UILabel *)orderPriceLabel {
    if (!_orderPriceLabel) {
        _orderPriceLabel = [UILabel new];
        _orderPriceLabel.textColor = ZPMyOrderBorderColor;
        _orderPriceLabel.font = [UIFont systemFontOfSize:15];
        _orderPriceLabel.text = @"¥0";
    }
    return _orderPriceLabel;
}

- (UIView *)whiteBackView1 {
    if (!_whiteBackView1) {
        _whiteBackView1 = [UIView new];
        _whiteBackView1.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView1;
}

- (UIView *)whiteBackView2 {
    if (!_whiteBackView2) {
        _whiteBackView2 = [UIView new];
        _whiteBackView2.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView2;
}

- (UIView *)whiteBackView3 {
    if (!_whiteBackView3) {
        _whiteBackView3 = [UIView new];
        _whiteBackView3.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView3;
}

- (UIView *)whiteBackView4 {
    if (!_whiteBackView4) {
        _whiteBackView4 = [UIView new];
        _whiteBackView4.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView4;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB_242_242_242;
    }
    return _lineView;
}

- (UILabel *)sjPayLabel {
    if (!_sjPayLabel) {
        _sjPayLabel = [UILabel new];
        _sjPayLabel.text = @"实付款:";
        _sjPayLabel.textColor = ZPMyOrderDetailFontColor;
        _sjPayLabel.textAlignment = NSTextAlignmentRight;
        _sjPayLabel.font = [UIFont systemFontOfSize:13];
    }
    return _sjPayLabel;
}

- (UILabel *)sjPayValueLabel {
    if (!_sjPayValueLabel) {
        _sjPayValueLabel = [UILabel new];
        _sjPayValueLabel.text = @"¥0";
        _sjPayValueLabel.textColor = ZPMyOrderBorderColor;
        _sjPayValueLabel.textAlignment = NSTextAlignmentRight;
        _sjPayValueLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sjPayValueLabel;
}

- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton new];
        [_payButton setTitle:@"付款" forState:UIControlStateNormal];
        [_payButton setTitleColor:ZPMyOrderBorderColor forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = 5;
        _payButton.layer.masksToBounds = YES;
        _payButton.layer.borderColor = ZPMyOrderBorderColor.CGColor;
        _payButton.layer.borderWidth = 1;
        _payButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _leftButton.layer.cornerRadius = 5;
        _leftButton.layer.masksToBounds = YES;
        _leftButton.layer.borderColor = ZPMyOrderDetailFontColor.CGColor;
        _leftButton.layer.borderWidth = 1;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
         [_leftButton addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIImageView *)locImageView {
    if (!_locImageView) {
        _locImageView = [UIImageView new];
        _locImageView.image = [UIImage imageNamed:@"prefer_loc"];
        
    }
    return _locImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        _userNameLabel.textColor = ZPMyOrderDetailFontColor;
        _userNameLabel.font = [UIFont systemFontOfSize:14];
        _userNameLabel.text = @"- -";
    }
    return _userNameLabel;
}

- (UILabel *)userPhoneLabel {
    if (!_userPhoneLabel) {
        _userPhoneLabel = [UILabel new];
        _userPhoneLabel.textColor = ZPMyOrderDetailFontColor;
        _userPhoneLabel.font = [UIFont systemFontOfSize:14];
        _userPhoneLabel.text = @"- -";
    }
    return _userPhoneLabel;
}

- (UILabel *)locLabel {
    if (!_locLabel) {
        _locLabel = [UILabel new];
        _locLabel.textColor = ZPMyOrderDetailFontColor;
        _locLabel.font = [UIFont systemFontOfSize:12];
        _locLabel.text = @"- -";
    }
    return _locLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _rightImageView;
}

- (UIImageView *)lineImageView {
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prefer_locborder"]];
    }
    return _lineImageView;
}

- (UILabel *)yfLabel {
    if (!_yfLabel) {
        _yfLabel = [UILabel new];
        _yfLabel.text = @"应付";
        _yfLabel.font = [UIFont systemFontOfSize:14];
        _yfLabel.textColor = ZPMyOrderDetailFontColor;
    }
    return _yfLabel;
}

- (UILabel *)yfValueLabel {
    if (!_yfValueLabel) {
        _yfValueLabel = [UILabel new];
        _yfValueLabel.text = @"¥0";
        _yfValueLabel.font = [UIFont systemFontOfSize:17];
        _yfValueLabel.textColor = ZPMyOrderBorderColor;
    }
    return _yfValueLabel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = RGB(249, 249, 249);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end

