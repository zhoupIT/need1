//
//  ZPCheckOutBillController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutBillController.h"

/* model */
#import "ZPCheckOutModel.h"
#import "ZPShoppingCartCommodityModel.h"
#import "ZPCommodity.h"
#import "ZPWechatPayModel.h"
#import "WXApi.h"
#import "ZPWechatPayModel.h"
#import "WXApiManager.h"
#import "ZPAddressModel.h"
/* view */
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
/* controller */
#import "ZPCheckOutResultController.h"
#import "ZPMyAddressController.h"
#import "ZPPayController.h"
@interface ZPCheckOutBillController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WXApiManagerDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) ZPCheckOutSubmitView *submitView;

@property (nonatomic,strong) NSDecimalNumber *originaltotalPrice;
@property (nonatomic,strong) NSDecimalNumber *totalPrice;
@property (nonatomic,strong) NSDecimalNumber *favourPrice;
/** 运费 */
@property (nonatomic,copy) NSString *logisticsFee;
/** 配送方式 */
@property (nonatomic,copy) NSString *logisticsMode;

//是否选择了地点
@property (nonatomic,assign) BOOL isLocSel;

//下单的商品的数组
@property (nonatomic,strong) NSMutableArray *payArray;
@property (nonatomic,copy) NSString *note;

@property (nonatomic,strong) ZPAddressModel *addressmodel;
@end

@implementation ZPCheckOutBillController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.addressmodel) {
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/common/receiveAddress/%@",ZPBaseUrl,self.addressmodel.ID] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if ([[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                    self.addressmodel = nil;
                    self.isLocSel = NO;
                    [self.tableView reloadData];
                } else {
                    ZPAddressModel *model = [ZPAddressModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                    self.addressmodel = model;
                    [self.tableView reloadData];
                }
            } else {
                self.addressmodel = nil;
                self.isLocSel = NO;
                [self.tableView reloadData];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            self.addressmodel = nil;
            self.isLocSel = NO;
            [self.tableView reloadData];
        } className:[ZPCheckOutBillController class]];
    } else {
        self.addressmodel = nil;
        self.isLocSel = NO;
        [self.tableView reloadData];
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"receiveAddress/list" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *list = [ZPAddressModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (list.count) {
                    for (ZPAddressModel *model in list) {
                        if ([model.addressStatus.name isEqualToString:@"DEFAULT"]) {
                            self.addressmodel = model;
                            self.isLocSel = YES;
                            [self.tableView reloadData];
                        }
                    }
                }
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
        } className:[ZPMyAddressController class]];
    }
}

- (void)initData {
    [self.dataArray addObject: [ZPCheckOutModel creatDetailsData]];
     if (self.enterBillType == ZPCheckOutBillTypeFromCart) {
         //从购物车进入 计算价格
        [self calPrice];
         
     }else {
         [self calPriceWithNum:@"1" andIsDefaultOredr:YES];
     }
    [self.tableView reloadData];
    [WXApiManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initAll {
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
        if (weakSelf.addressmodel == nil) {
            [MBProgressHUD showError:@"请先选择收货地址"];
            return ;
        }
        //下单
        [MBProgressHUD showMessage:@"下单中..."];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/order/order",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        if (weakSelf.note == nil) {
            weakSelf.note = @"";
        }
        NSDictionary *msg = @{@"receiveAddressId":weakSelf.addressmodel.ID,@"note":weakSelf.note,@"needInvoice":@"NO",@"orderItems":weakSelf.payArray};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            ZPLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        //下单成功 --> 清空购物车 -> 微信支付
                        if (self.enterBillType == ZPCheckOutBillTypeFromCart) {
                            //删除购物车里面的商品
                            NSMutableArray *commodityIDDeleteArray = [NSMutableArray array];
                            for (ZPShoppingCartCommodityModel *model in weakSelf.orderArray) {
                                [commodityIDDeleteArray addObject:model.itemId];
                            }
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/shopping/cart",ZPBaseUrl]];
                            
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                            
                            request.HTTPMethod = @"DELETE";
                            
                            request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
                            
                            
                            NSData *data = [NSJSONSerialization dataWithJSONObject:commodityIDDeleteArray options:NSJSONWritingPrettyPrinted error:nil];
                            
                            request.HTTPBody = data;
                            
                            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                    if (error == nil) {
                                        NSDictionary *dict = [data mj_JSONObject];
                                        if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                                            if (weakSelf.emptyCartBlock) {
                                                weakSelf.emptyCartBlock();
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
                        ZPPayController *payControl = [[ZPPayController alloc] init];
                        payControl.orderID =[dict objectForKey:@"data"];
                        if (self.enterBillType == ZPCheckOutBillTypeFromCart) {
                            payControl.payEnterType = ZPPayEnterTypeCart;
                        } else if (self.enterBillType == ZPCheckOutBillTypeFromOrderDetail) {
                            payControl.payEnterType = ZPPayEnterTypeOrderDetail;
                        }
                        [weakSelf.navigationController pushViewController:payControl animated:YES];
                        
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
    return 3;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        if (self.enterBillType == ZPCheckOutBillTypeFromCart) {
            return 2+self.orderArray.count;
        }
        return 3+self.orderArray.count;
    }
//    if (section == 2) {
//        return 2;
//    }
    return 4;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.isLocSel) {
            ZPCheckOutNoLocHeaderCell *cell = [ZPCheckOutNoLocHeaderCell cellWithTableView:tableView];
            cell.addLocBlock = ^{
                __weak typeof(self) weakSelf = self;
                ZPMyAddressController *myaddressControl = [[ZPMyAddressController alloc] init];
                myaddressControl.selectLocBlock = ^(ZPAddressModel *model) {
                    weakSelf.addressmodel = model;
                    weakSelf.isLocSel = YES;
                    [weakSelf.tableView reloadData];
                };
               
                [self.navigationController pushViewController:myaddressControl animated:YES];
            };
            return cell;
        } 
        ZPCheckOutHeaderCell *cell = [ZPCheckOutHeaderCell cellWithTableView:tableView];
        cell.model = self.addressmodel;
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ZPCheckOutTitleCell *cell = [ZPCheckOutTitleCell cellWithTableView:tableView];
            return cell;
        }
        if (self.enterBillType == ZPCheckOutBillTypeFromCart) {
            if (indexPath.row == self.orderArray.count+1) {
                ZPCheckOutSubtitleIconCell *cell = [ZPCheckOutSubtitleIconCell cellWithTableView:tableView];
                cell.rightstr = self.logisticsMode;
                return cell;
            }
        } else {
            if (indexPath.row == self.orderArray.count+1) {
                WEAK_SELF(weakSelf);
                ZPCheckOutSubViewCell *cell = [ZPCheckOutSubViewCell cellWithTableView:tableView];
                ZPCommodity *commodity = self.orderArray.firstObject;
                cell.updatePriceBlock = ^(NSInteger num) {
                    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"commodity/settlement" parameters:@{@"commodityId":[NSNumber numberWithInteger:commodity.commodityId],@"commodityCount":[NSNumber numberWithInteger:num],@"itemNumber":self.commodityItemModel.number} progress:^(NSProgress *progress) {
                        
                    } success:^(NSURLSessionDataTask *task, id response) {
                        [MBProgressHUD hideHUD];
                        if ([[response objectForKey:@"code"] integerValue]  == 200) {
                            weakSelf.settlementModel = [ZPSettlementModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                            weakSelf.logisticsMode = weakSelf.settlementModel.logisticsMode;
                            [weakSelf calPriceWithNum:[NSString stringWithFormat:@"%ld",num] andIsDefaultOredr:NO];
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:weakSelf.orderArray.count+1] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                            
                            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.orderArray.count+2 inSection:1]; //你需要更新的组数中的cell
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];//collection 相同
                        } else {
                            [MBProgressHUD showError:[response objectForKey:@"message"]];
                        }
                    } failed:^(NSURLSessionDataTask *task, NSError *error) {
                        [MBProgressHUD hideHUD];
                    } className:[ZPCheckOutBillController class]];
                    
                };
                return cell;
            }
            if (indexPath.row == self.orderArray.count+2) {
                ZPCheckOutSubtitleIconCell *cell = [ZPCheckOutSubtitleIconCell cellWithTableView:tableView];
                cell.rightstr = self.logisticsMode;
                return cell;
            }
        }
       
        ZPCheckOutOrderCell *cell = [ZPCheckOutOrderCell cellWithTableView:tableView];
        if (self.enterBillType == ZPCheckOutBillTypeFromCart) {
             cell.model = self.orderArray[indexPath.row-1];
        } else {
             cell.commodityModel = self.orderArray[indexPath.row-1];
             cell.commodityItemModel = self.commodityItemModel;
        }
        return cell;
    }
//    else if(indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            ZPCheckOutFavourCell *cell = [ZPCheckOutFavourCell cellWithTableView:tableView];
//            return cell;
//        }
//        if (indexPath.row == 1) {
//            ZPCheckOutScoreCell *cell = [ZPCheckOutScoreCell cellWithTableView:tableView];
//            return cell;
//        }
//    }
    else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            ZPCheckOutRemarkCell *cell = [ZPCheckOutRemarkCell cellWithTableView:tableView];
            return cell;
        }
       
        ZPCheckOutSubTitleCell *cell = [ZPCheckOutSubTitleCell cellWithTableView:tableView];
          if (indexPath.row == 1) {
              cell.subtitleStr = [NSString stringWithFormat:@"¥%@",self.originaltotalPrice];
              cell.titleStr = @"商品合计:";
         } else  if (indexPath.row == 2) {
             cell.subtitleStr = [NSString stringWithFormat:@"-¥%@",self.favourPrice];
             cell.titleStr = @"优惠金额：";
         } else if (indexPath.row == 3) {
             cell.subtitleStr = [NSString stringWithFormat:@"¥%@",self.logisticsFee];
             cell.titleStr = @"运费：";
         }
        return cell;
        
    }
    ZPCheckOutSubTitleCell *cell = [ZPCheckOutSubTitleCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    if (indexPath.section == 1) {
        if (indexPath.row >0 && indexPath.row <=self.orderArray.count) {
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
//    if (section == 1) {
//        return 43;
//    }
    return 10;
}
//section底部视图
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 43)];
        view.backgroundColor = RGB_242_242_242;
        UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 43)];
        [view addSubview:bView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH-15, 43)];
        lab.backgroundColor =RGB_242_242_242;
        lab.textColor = ZPMyOrderDetailFontColor;
        lab.text = @"优惠";
        lab.font = [UIFont systemFontOfSize:13];
        [view addSubview:lab];
        return view;
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        ZPMyAddressController *myaddressControl = [[ZPMyAddressController alloc] init];
        myaddressControl.selectLocBlock = ^(ZPAddressModel *model) {
            weakSelf.addressmodel = model;
            weakSelf.isLocSel = YES;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:myaddressControl animated:YES];
    }
    
}


- (void)textFieldTextChange:(NSNotification *)noti {
    UITextField *currentTextField = (UITextField *)noti.object;
    self.note = currentTextField.text;
}

//购物车 重新计算价格
- (void)calPrice {
   /*
        //原本的价格
        self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
        //应付价格
        self.totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    
        for (ZPShoppingCartCommodityModel *model in self.orderArray) {
            ZPCommodityItemModel * commodityItemModel = model.commodity.specifications.commodityItem.firstObject;
            NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.presentPrice];
            self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.commodityCount]]];
            
            NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.originalPrice];
            self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.commodityCount]]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[NSNumber numberWithInteger:model.commodity.commodityId] forKey:@"commodityId"];
            [dict setValue:model.commodityCount forKey:@"number"];
            [dict setValue:model.commoditySpecificationNo forKey:@"commoditySpecificationNo"];
            [self.payArray addObject:dict];
        }
        //优惠的价格
        self.favourPrice = [self.originaltotalPrice decimalNumberBySubtracting:self.totalPrice];
        self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.totalPrice];
    */
    
    //原本的价格
    self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    //应付价格
    self.totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (ZPShoppingCartCommodityModel *model in self.orderArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInteger:model.commodity.commodityId] forKey:@"commodityId"];
        [dict setValue:model.commodityCount forKey:@"number"];
        [dict setValue:model.commoditySpecificationNo forKey:@"commoditySpecificationNo"];
        [self.payArray addObject:dict];
    }
    self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:self.cartSettlementModel.originProductAmountTotal];
    self.logisticsFee = self.cartSettlementModel.logisticsFee;
    self.logisticsMode = self.cartSettlementModel.logisticsMode;
    //优惠的价格
    self.favourPrice = [NSDecimalNumber decimalNumberWithString:self.cartSettlementModel.reducedPrice];
    self.submitView.presentPriceLabel.text = self.cartSettlementModel.amountPayable;
}

/* 是否默认直接购买 */
- (void)calPriceWithNum:(NSString *)num andIsDefaultOredr:(BOOL)isDefaultOrder {
    //原本的价格
    self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    //应付价格
    self.totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    [self.payArray removeAllObjects];
    if (isDefaultOrder) {
        //默认直接购买的话 商品数量为1 只有一个商品
        /*
        ZPCommodity *model = self.orderArray.firstObject;
        ZPCommodityItemModel *commodityItemModel = model.specifications.commodityItem.firstObject;
        NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.presentPrice];
        self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
        
        NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.originalPrice];
        self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
        [dict setValue:num forKey:@"number"];
        [dict setValue:self.commodityItemModel.number forKey:@"commoditySpecificationNo"];
        [self.payArray addObject:dict];
        //优惠的价格
        self.favourPrice = [self.originaltotalPrice decimalNumberBySubtracting:self.totalPrice];
        self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.totalPrice];
         */
        ZPCommodity *model = self.orderArray.firstObject;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
        [dict setValue:num forKey:@"number"];
        [dict setValue:self.commodityItemModel.number forKey:@"commoditySpecificationNo"];
        [self.payArray addObject:dict];
         self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:self.settlementModel.originProductAmountTotal];
        self.logisticsFee = self.settlementModel.logisticsFee;
        self.logisticsMode = self.settlementModel.logisticsMode;
        //优惠的价格
        self.favourPrice = [NSDecimalNumber decimalNumberWithString:self.settlementModel.reducedPrice];
        self.submitView.presentPriceLabel.text = self.settlementModel.amountPayable;
    } else {
        if (self.hasDefaultOption) {
            //有默认规格就直接下单
            /*
            for (ZPCommodity *model in self.orderArray) {
               
                ZPCommodityItemModel *commodityItemModel = model.specifications.commodityItem.firstObject;
                NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.presentPrice];
                self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
                
                NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.originalPrice];
                self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
                [dict setValue:num forKey:@"number"];
                [self.payArray addObject:dict];
            }
            //优惠的价格
            self.favourPrice = [self.originaltotalPrice decimalNumberBySubtracting:self.totalPrice];
            self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.totalPrice];
             */
            for (ZPCommodity *model in self.orderArray) {
                
//                ZPCommodityItemModel *commodityItemModel = model.specifications.commodityItem.firstObject;
//                NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.presentPrice];
//                self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
                
//                NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:commodityItemModel.originalPrice];
//                self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
                [dict setValue:num forKey:@"number"];
                [self.payArray addObject:dict];
            }
          
            self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:self.settlementModel.originProductAmountTotal];
            self.logisticsFee = self.settlementModel.logisticsFee;
            self.logisticsMode = self.settlementModel.logisticsMode;
            //优惠的价格
            self.favourPrice = [NSDecimalNumber decimalNumberWithString:self.settlementModel.reducedPrice];
            self.submitView.presentPriceLabel.text = self.settlementModel.amountPayable;
        } else {
            /*
            for (ZPCommodity *model in self.orderArray) {
                
                NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:self.commodityItemModel.presentPrice];
                self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
                
                NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:self.commodityItemModel.originalPrice];
                self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
                [dict setValue:num forKey:@"number"];
                [self.payArray addObject:dict];
            }
            //优惠的价格
            self.favourPrice = [self.originaltotalPrice decimalNumberBySubtracting:self.totalPrice];
            self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.totalPrice];
             */
            for (ZPCommodity *model in self.orderArray) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
                [dict setValue:num forKey:@"number"];
                [self.payArray addObject:dict];
            }
            self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:self.settlementModel.originProductAmountTotal];
            self.logisticsFee = self.settlementModel.logisticsFee;
            self.logisticsMode = self.settlementModel.logisticsMode;
            //优惠的价格
            self.favourPrice = [NSDecimalNumber decimalNumberWithString:self.settlementModel.reducedPrice];
            self.submitView.presentPriceLabel.text = self.settlementModel.amountPayable;
        }
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
    ZPCheckOutResultController *checkOutResultControl = [[ZPCheckOutResultController alloc] init];
    checkOutResultControl.enterResultType = self.enterBillType;
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

- (NSMutableArray *)payArray {
    if (!_payArray) {
        _payArray = [NSMutableArray array];
    }
    return _payArray;
}

@end
