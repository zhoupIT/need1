//
//  ZPMyOrderController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyOrderController.h"
#import "ZPMyOrderCell.h"

#import "ZPOrderModel.h"
#import "ZPOrderItemModel.h"

#import "ZPMyOrderDetailController.h"
#import "WXApi.h"
#import "ZPWechatPayModel.h"
#import "WXApiManager.h"

#import "ZPCommentView.h"
#import "ZPPayController.h"
@interface ZPMyOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
//传的参数
@property (nonatomic,copy) NSString *orderStatus;
@end

@implementation ZPMyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无订单"
                                                           detailStr:@""];
}

- (void)initData {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"order" parameters:@{@"orderStatus":self.orderStatus} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.datas = [ZPOrderModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMyOrderController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"order" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"orderStatus":self.orderStatus} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPOrderModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.datas addObjectsFromArray:arrays];
                    [tableView reloadData];
                    
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMyOrderController class]];
    }];
    
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
    [self.tableView.mj_header endRefreshing];
}

/* 刷新界面 */
- (void)refreshPage {
}

- (void)setOrderStatusType:(ZPOrderStatusType)orderStatusType {
    _orderStatusType = orderStatusType;
    self.orderStatus = @"";
    switch (orderStatusType) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            self.orderStatus = @"NON_PAYMENT";
        }
            break;
        case 2:
        {
            self.orderStatus = @"NON_SEND";
        }
            break;
        case 3:
        {
           self.orderStatus = @"NON_RECIEVE";
        }
            break;
        case 4:
        {
            self.orderStatus = @"NON_EVALUATED";
        }
            break;
        default:
            break;
    }
    ZPLog(@"状态:%ld--------参数:%@",self.orderStatusType,self.orderStatus);
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPOrderModel *model =self.datas[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ZPMyOrderCell class] contentViewWidth:kSCREEN_WIDTH];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPMyOrderCell class])];
    ZPOrderModel *model = self.datas[indexPath.section];
    cell.model = model;
    cell.payActionBlock = ^(UIButton *btn) {
        if ([btn.titleLabel.text isEqualToString:@"立即支付"]) {
            /*
            //微信支付
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"payment/wechat" parameters:@{@"orderId":model.orderId} progress:^(NSProgress *progress) {
                
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
                
            } className:[ZPMyOrderController class]];
            */
            
            if (self.payBlock) {
                self.payBlock(model);
            }
        } else if ([btn.titleLabel.text isEqualToString:@"评价"]) {
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
                    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"order" parameters:@{@"orderId":model.orderId,@"evaluateLevel":[NSNumber numberWithInteger:count],@"evaluateContent":content} progress:^(NSProgress *progress) {
                        
                    } success:^(NSURLSessionDataTask *task, id response) {
                        [MBProgressHUD hideHUD];
                        if ([[response objectForKey:@"code"] integerValue]  == 200) {
                            [MBProgressHUD showSuccess:@"评价成功!"];
                             [self.tableView.mj_header beginRefreshing];
                        } else {
                            
                            [MBProgressHUD showError:[response objectForKey:@"message"]];
                        }
                    } failed:^(NSURLSessionDataTask *task, NSError *error) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:error.localizedDescription];
                    } className:[ZPMyOrderController class]];
                }];
            };
    
            [LEEAlert alert].config
            .LeeCustomView(view)
            .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeShow();
        } else if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
            //确认收货
            [MBProgressHUD showMessage:@"加载中..."];
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"order/receipt/confirm" parameters:@{@"orderId":model.orderId} progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    [MBProgressHUD showSuccess:@"收货成功!"];
                    [self.tableView.mj_header beginRefreshing];
                } else {
                    
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPMyOrderController class]];
        }
    };
    cell.deleteActionBlock = ^(UIButton *btn) {
        if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
            [MBProgressHUD showMessage:@"取消中..."];
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWithUrlString:[NSString stringWithFormat:@"/api/order/order/cancellation/%@",model.orderId] parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                   [MBProgressHUD showSuccess:@"订单取消成功"];
                    [self.tableView.mj_header beginRefreshing];
                } else {
                    
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPMyOrderController class]];
        } else if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
            [MBProgressHUD showMessage:@"删除中..."];
            //删除
            NSMutableArray *idDeleteArray = [NSMutableArray array];
            [idDeleteArray addObject:model.orderId];
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
                             [self.tableView.mj_header beginRefreshing];
                        } else {
                            [MBProgressHUD showError:[dict objectForKey:@"message"]];
                        }
                    } else {
                        [MBProgressHUD showError:error.localizedDescription];
                    }
                });
            }] resume];
        } else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
            if (self.traceBlock) {
                self.traceBlock(model);
            }
        }
    };
    cell.didSelectBlock = ^{
        if (self.detailClickEventBlock) {
            self.detailClickEventBlock(model);
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZPOrderModel *model = self.datas[indexPath.section];
    if (self.detailClickEventBlock) {
        self.detailClickEventBlock(model);
    }
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
    return 10;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

/*
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
    if (self.refreshTableBlock) {
        self.refreshTableBlock();
    }
    
}
*/

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.datas removeAllObjects];
  
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGB_242_242_242;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZPMyOrderCell class] forCellReuseIdentifier:NSStringFromClass([ZPMyOrderCell class])];
    }
    return _tableView;
}
@end
