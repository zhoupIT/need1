//
//  ZPOrderDetailController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPOrderDetailController.h"
/* model */
#import "ZPOrderDetailModel.h"
#import "ZPCommodity.h"
#import "ZPSpecificationsModel.h"
#import "ZPFeatureContentModel.h"
#import "ZPCommodityItemModel.h"
/* view */
#import "ZPOrderDetailTopCell.h"
#import "ZPCheckOutSubtitleIconCell.h"
#import "ZPOrderDetailImageCell.h"
/* controller */
#import "ZPMyShoppingCartController.h"
#import "ZPCheckOutBillController.h"
#import "ZPSelectOrderParamController.h"
/* 三方 */
#import "SDCycleScrollView.h"
#import <UShareUI/UShareUI.h>
#import <WebKit/WebKit.h>


@interface ZPOrderDetailController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *centerDatasArray;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollview;

@property (nonatomic, strong) WKWebView     *webView;
@property (nonatomic, strong) UIScrollView  *containerScrollView;
@property (nonatomic, strong) UIView        *contentView;

/* 已选属性 */
@property (nonatomic,copy) NSString *selStr;
/* 已选属性的模型 */
@property (nonatomic,strong) ZPCommodityItemModel *selCommodityItemModel;
@property (nonatomic,strong) NSMutableDictionary *choosedOptionMap;
@end

@implementation ZPOrderDetailController{
    CGFloat _lastWebViewContentHeight;
    CGFloat _lastTableViewContentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)dealloc{
    [self removeObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)removeObservers{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)initAll {
    self.title = @"商品详情";
    
    [self.view addSubview:self.containerScrollView];
    self.containerScrollView.sd_layout
    .spaceToSuperView(IS_IPhoneX?UIEdgeInsetsMake(0, 0, 84, 0):UIEdgeInsetsMake(0, 0, 50, 0));
    [self.containerScrollView addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, self.view.width, IS_IPhoneX?(self.view.height-84 )* 2:(self.view.height -50)* 2);
    
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, IS_IPhoneX?(kSCREEN_HEIGHT-84):(kSCREEN_HEIGHT-50));
    
    self.tableView.top = 0;
    self.webView.height = self.view.height;
    self.webView.top = self.tableView.bottom;
    
    [self setupHeaderView];
    [self setupBottomView];
}

- (void)initData {
    _lastWebViewContentHeight = 0;
    _lastTableViewContentHeight = 0;
    [self addObservers];
    [self getdata];
    NSString *path = orderDetailUrl(self.commodity.commodityId);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    ZPLog(@"商品详情地址:%@",path);
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [self.webView loadRequest:request];
}

/** 刷新界面 */
- (void)refreshPage {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/store/commodity/%ld",ZPBaseUrl,self.commodity.commodityId] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.commodity = [ZPCommodity mj_objectWithKeyValues:[response objectForKey:@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPOrderDetailController class]];
}
#pragma mark - Observers
- (void)addObservers{
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)getdata {
    WEAK_SELF(weakSelf);
    NSString *urlString = [NSString stringWithFormat:@"/api/store/commodity/%ld",self.commodity.commodityId];
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:urlString parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.commodity = [ZPCommodity mj_objectWithKeyValues:[response objectForKey:@"data"]];
            weakSelf.dataArray = [ZPOrderDetailModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"commodityAttachmentsAtCommodityParticularsPosition"]];
            NSArray *temp = [ZPOrderDetailModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"commodityAttachmentsAtCenterPosition"]];
            
            if (temp.count) {
                for (ZPOrderDetailModel *model in temp) {
                    NSString *rule = [NSString stringWithFormat:@"%@",model.attachmentFullUrl];
                    [weakSelf.centerDatasArray addObject:rule];
                }
            }
            weakSelf.cycleScrollview.imageURLStringsGroup = self.centerDatasArray.copy;
            weakSelf.cycleScrollview.autoScrollTimeInterval = 2;
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPOrderDetailController class]];
}

- (void)setupHeaderView {
    UIView *header = [UIView new];
    
    // 由于tableviewHeaderView的特殊性，在使他高度自适应之前你最好先给它设置一个宽度
    header.width = kSCREEN_WIDTH;
    NSArray *picImageNamesArray = @[];
    
    SDCycleScrollView *scrollView = [SDCycleScrollView new];
    scrollView.imageURLStringsGroup = picImageNamesArray;
    scrollView.backgroundColor = RGB(207, 207, 207);
    scrollView.placeholderImage = [UIImage imageWithColor:RGB(207, 207, 207)];
    [header addSubview:scrollView];
    
    self.cycleScrollview = scrollView;
    
    scrollView.sd_layout
    .leftSpaceToView(header, 0)
    .topSpaceToView(header, 0)
    .rightSpaceToView(header, 0)
    .heightIs(295);
    
    [header setupAutoHeightWithBottomView:scrollView bottomMargin:0];
    [header layoutSubviews];
    
    self.tableView.tableHeaderView = header;
}

- (void)setupBottomView {
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(IS_IPhoneX?84:50)
    .bottomEqualToView(self.view);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }else if(object == _tableView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }
}

- (void)updateContainerScrollViewContentSize:(NSInteger)flag webViewContentHeight:(CGFloat)inWebViewContentHeight{
    
    CGFloat webViewContentHeight = flag==1 ?inWebViewContentHeight :self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (webViewContentHeight == _lastWebViewContentHeight && tableViewContentHeight == _lastTableViewContentHeight) {
        return;
    }
    
    _lastWebViewContentHeight = webViewContentHeight;
    _lastTableViewContentHeight = tableViewContentHeight;
    
    self.containerScrollView.contentSize = CGSizeMake(self.view.width, webViewContentHeight + tableViewContentHeight);
    
    CGFloat webViewHeight = (webViewContentHeight < self.view.height) ?webViewContentHeight :self.view.height ;
    CGFloat tableViewHeight = tableViewContentHeight < self.view.height ?tableViewContentHeight :self.view.height;
    self.webView.height = webViewHeight <= 0.1 ?0.1 :webViewHeight;
    self.contentView.height = webViewHeight + tableViewHeight;
    self.tableView.height = tableViewHeight;
    self.webView.top = self.tableView.bottom;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_containerScrollView != scrollView) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat webViewHeight = self.webView.height;
    CGFloat tableViewHeight = self.tableView.height;
    
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (offsetY <= 0) {
        self.contentView.top = 0;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < tableViewContentHeight - tableViewHeight){
        self.contentView.top = offsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
        self.tableView.contentOffset = CGPointMake(0, offsetY);
    }else if(offsetY < tableViewContentHeight){
        self.contentView.top = tableViewContentHeight - tableViewHeight;
       self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
         self.webView.scrollView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight + tableViewContentHeight - webViewHeight){
        self.contentView.top = offsetY - tableViewHeight;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY - tableViewContentHeight);
        self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
    }else if(offsetY <= webViewContentHeight + tableViewContentHeight ){
        self.contentView.top = self.containerScrollView.contentSize.height - self.contentView.height;
        self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
    }else {
        //do nothing
        NSLog(@"do nothing");
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.commodity.specifications.hasDefaultOption?1:2;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        ZPOrderDetailTopCell *cell = [ZPOrderDetailTopCell cellWithTableView:tableView];
        ZPOrderDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPOrderDetailTopCell class])];
        cell.model = self.commodity;
        return cell;
    }
    if (self.commodity.specifications.hasDefaultOption) {
        ZPCheckOutSubtitleIconCell *cell = [ZPCheckOutSubtitleIconCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.leftstr = @"商品介绍";
            cell.rightstr = @"";
        }
        return cell;
    }
        ZPCheckOutSubtitleIconCell *cell = [ZPCheckOutSubtitleIconCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.leftstr = @"规格数量选择";
            cell.rightstr = self.selStr;
        } else if (indexPath.row == 1) {
            cell.leftstr = @"商品介绍";
            cell.rightstr = @"";
        }
        return cell;
}


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
    if (section == 1) {
        return 0.01f;
    }
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = RGB_242_242_242;
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//         return 115;
        ZPCommodity *model = self.commodity;
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ZPOrderDetailTopCell class] contentViewWidth:kSCREEN_WIDTH];
//        return 115;
    }
        return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        ZPOrderCommentsController *commentsControl = [[ZPOrderCommentsController alloc] init];
//        [self.navigationController pushViewController:commentsControl animated:YES];
//    }
    if (!self.commodity.specifications.hasDefaultOption && indexPath.row == 0 && indexPath.section ==1) {
//        WEAK_SELF(weakSelf);
//        ZPSelectOrderParamController * halfVC = [[ZPSelectOrderParamController alloc] initWithCHeight:SCREEN_HEIGHT*0.7 andDimAlpha:0.4];
//        halfVC.commodity = self.commodity;
//        halfVC.featureAttr = self.commodity.specifications.specifications;
//        halfVC.selCommodityItemModel = self.selCommodityItemModel;
//        halfVC.buyActionBlock = ^(NSArray * _Nonnull array, ZPCommodityItemModel * _Nonnull selModel) {
//            //立即购买
//            [self dismissViewControllerAnimated:YES completion:^{
//                ZPCheckOutBillController *checkoutCtrol = [[ZPCheckOutBillController alloc] init];
//                checkoutCtrol.orderArray = array;
//                checkoutCtrol.entertype = ZPEnterOrderDetail;
//                checkoutCtrol.commodityItemModel = selModel;
//                checkoutCtrol.hasDefaultOption = self.commodity.specifications.hasDefaultOption;
//                [self.navigationController pushViewController:checkoutCtrol animated:YES];
//            }];
//        };
//        halfVC.selectAttachBlock = ^(ZPCommodityItemModel * _Nonnull selModel, NSString * _Nonnull selStr) {
//            //选择属性
//            weakSelf.selCommodityItemModel = selModel;
//            weakSelf.selStr = selStr;
//            [weakSelf.tableView reloadData];
//        };
//        halfVC.addToCartActionBlock = ^(ZPCommodityItemModel * _Nonnull selModel) {
//            //添加到购物车
//            [self dismissViewControllerAnimated:YES completion:^{
//                weakSelf.selCommodityItemModel = selModel;
//                [weakSelf addtoCartAction];
//            }];
//        };
//        halfVC.cartBlock = ^{
//            [self dismissViewControllerAnimated:YES completion:^{
//                ZPMyShoppingCarController *myshoppingCarControl = [[ZPMyShoppingCarController alloc] init];
//                [self.navigationController pushViewController:myshoppingCarControl animated:YES];
//            }];
//        };
//        [self presentViewController:halfVC animated:YES completion:nil];
        [self showSelectOrderParamControl];
    }
   
}

#pragma mark - 底部事件
 //添加到购物车
- (void)addAction {
    if (!self.commodity.specifications.hasDefaultOption) {
        /* 没有默认规格就得选规格 */
        if (!self.selCommodityItemModel) {
            /* 如果没有选择规格的话 得弹出让用户先去选 */
            [self showSelectOrderParamControl];
            return;
        }
    }
    [self addtoCartAction];
}

/* 添加到购物车 */
- (void)addtoCartAction {
    [MBProgressHUD showMessage:@"加载中"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/shopping/cart",ZPBaseUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"PUT";
    
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
    if (self.commodity.specifications.hasDefaultOption) {
        //当它是默认规格
        self.selCommodityItemModel = self.commodity.specifications.commodityItem.firstObject;
    }
    NSDictionary *msg = @{@"commodityId":[NSNumber numberWithInteger:self.commodity.commodityId],@"commodityCount":@1,@"commoditySpecificationNo":self.selCommodityItemModel?self.selCommodityItemModel.number:@""};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
    
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            if (error == nil) {
                NSDictionary *dict = [data mj_JSONObject];
                if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                    [MBProgressHUD showSuccess:@"成功添加到购物车"];
                } else if ([[dict objectForKey:@"code"] integerValue]  == 401){
                    //未登录页面
                    [self logout];
                } else if ([[dict objectForKey:@"code"] integerValue]  == 402){
                    //在别的地方登陆
                    [self clearLoginInfo];
                    [LEEAlert alert].config
                    .LeeContent([dict objectForKey:@"message"])
                    .LeeAction(@"确认", ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPOrderDetailController class]) object:nil];
                    })
                    .LeeShow();
                } else {
                    [MBProgressHUD showError:[dict objectForKey:@"message"]];
                }
            } else {
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        
        
    }] resume];
}

//立刻购买
- (void)buyAction {
    if (!self.commodity.specifications.hasDefaultOption) {
        /* 没有默认规格就得选规格 */
        if (!self.selCommodityItemModel) {
            /* 如果没有选择规格的话 得弹出让用户先去选 */
            [self showSelectOrderParamControl];
            return;
        }
    }
    [MBProgressHUD showMessage:@"加载中"];
     self.selCommodityItemModel = self.commodity.specifications.commodityItem.firstObject;
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"commodity/settlement" parameters:@{@"commodityId":[NSNumber numberWithInteger:self.commodity.commodityId],@"commodityCount":@"1",@"itemNumber":self.selCommodityItemModel.number} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            ZPSettlementModel *model = [ZPSettlementModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            /* 有默认规格就直接下单;没有默认规格的情况,如果选择了规格的话 下单 */
            NSArray *array = [NSArray arrayWithObject:self.commodity];
            ZPCheckOutBillController *checkoutCtrol = [[ZPCheckOutBillController alloc] init];
            checkoutCtrol.settlementModel = model;
            checkoutCtrol.orderArray = array;
            checkoutCtrol.enterBillType = ZPCheckOutBillTypeFromOrderDetail;
            checkoutCtrol.commodityItemModel = self.selCommodityItemModel;
            checkoutCtrol.hasDefaultOption = self.commodity.specifications.hasDefaultOption;
            [self.navigationController pushViewController:checkoutCtrol animated:YES];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
    } className:[ZPOrderDetailController class]];
    
}

//我的购物车
- (void)myCart {
    ZPMyShoppingCartController *myshoppingCarControl = [[ZPMyShoppingCartController alloc] init];
    [self.navigationController pushViewController:myshoppingCarControl animated:YES];
}

//收藏
- (void)star {
    [MBProgressHUD showError:@"功能开发中..."];
}

/* 弹出规格选择的弹窗 */
- (void)showSelectOrderParamControl {
//    WEAK_SELF(weakSelf);
//    ZPSelectOrderParamController * halfVC = [[ZPSelectOrderParamController alloc] initWithCHeight:SCREEN_HEIGHT*0.7 andDimAlpha:0.4];
//    halfVC.commodity = self.commodity;
//    halfVC.featureAttr = self.commodity.specifications.specifications;
//    halfVC.buyActionBlock = ^(NSArray * _Nonnull array, ZPCommodityItemModel * _Nonnull selModel) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            ZPCheckOutBillController *checkoutCtrol = [[ZPCheckOutBillController alloc] init];
//            checkoutCtrol.orderArray = array;
//            checkoutCtrol.entertype = ZPEnterOrderDetail;
//            checkoutCtrol.commodityItemModel = selModel;
//            [self.navigationController pushViewController:checkoutCtrol animated:YES];
//        }];
//    };
//    halfVC.selectAttachBlock = ^(ZPCommodityItemModel * _Nonnull selModel, NSString * _Nonnull selStr) {
//        weakSelf.selCommodityItemModel = selModel;
//        weakSelf.selStr = selStr;
//        [weakSelf.tableView reloadData];
//    };
//    [self presentViewController:halfVC animated:YES completion:nil];
    WEAK_SELF(weakSelf);
    ZPSelectOrderParamController * halfVC = [[ZPSelectOrderParamController alloc] initWithCHeight:kSCREEN_HEIGHT*0.7 andDimAlpha:0.4];
    halfVC.commodity = self.commodity;
    halfVC.featureAttr = self.commodity.specifications.specifications;
    halfVC.selCommodityItemModel = self.selCommodityItemModel;
    halfVC.choosedOptionMap = self.choosedOptionMap;
    halfVC.buyActionBlock = ^(NSArray * _Nonnull array, ZPCommodityItemModel * _Nonnull selModel) {
        [self dismissViewControllerAnimated:YES completion:^{
        //立即购买
        [MBProgressHUD showMessage:@"加载中"];
        self.selCommodityItemModel = self.commodity.specifications.commodityItem.firstObject;
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"commodity/settlement" parameters:@{@"commodityId":[NSNumber numberWithInteger:self.commodity.commodityId],@"commodityCount":@"1",@"itemNumber":self.selCommodityItemModel.number} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPSettlementModel *model = [ZPSettlementModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                
                    ZPCheckOutBillController *checkoutCtrol = [[ZPCheckOutBillController alloc] init];
                    checkoutCtrol.settlementModel = model;
                    checkoutCtrol.orderArray = array;
                    checkoutCtrol.enterBillType = ZPCheckOutBillTypeFromOrderDetail;
                    checkoutCtrol.commodityItemModel = selModel;
                    checkoutCtrol.hasDefaultOption = self.commodity.specifications.hasDefaultOption;
                    [self.navigationController pushViewController:checkoutCtrol animated:YES];
               
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
        } className:[ZPOrderDetailController class]];
      }];
    };
    halfVC.selectAttachBlock = ^(ZPCommodityItemModel * _Nonnull selModel, NSString * _Nonnull selStr, NSMutableDictionary * _Nonnull choosedOptionMap) {
        //选择属性
//        if (weakSelf.selCommodityItemModel) {
             weakSelf.selCommodityItemModel = selModel;
//        }
        weakSelf.choosedOptionMap = [NSMutableDictionary dictionaryWithDictionary:choosedOptionMap];
        weakSelf.selStr = selStr;
        [weakSelf.tableView reloadData];
    };
    halfVC.addToCartActionBlock = ^(ZPCommodityItemModel * _Nonnull selModel) {
        //添加到购物车
        [self dismissViewControllerAnimated:YES completion:^{
            weakSelf.selCommodityItemModel = selModel;
            [weakSelf addtoCartAction];
        }];
    };
    halfVC.cartBlock = ^{
        [self dismissViewControllerAnimated:YES completion:^{
            ZPMyShoppingCartController *myshoppingCarControl = [[ZPMyShoppingCartController alloc] init];
            [self.navigationController pushViewController:myshoppingCarControl animated:YES];
        }];
    };
    [self presentViewController:halfVC animated:YES completion:nil];
}

//退出登录
- (void)logout {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPOrderDetailController class]) object:nil];
    
}

- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[ZPOrderDetailImageCell class] forCellReuseIdentifier:@"ZPOrderDetailImageCell"];
        [_tableView registerClass:[ZPOrderDetailTopCell class] forCellReuseIdentifier:NSStringFromClass([ZPOrderDetailTopCell class])];
        
    }
    return _tableView;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *collectBtn = [UIButton new];
        [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
         collectBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [collectBtn setImage:[UIImage imageNamed:@"prefer_star"] forState:UIControlStateNormal];
        [collectBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [collectBtn addTarget:self action:@selector(star) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shopCarBtn = [UIButton new];
        [shopCarBtn setTitle:@"购物车" forState:UIControlStateNormal];
        [shopCarBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        shopCarBtn.titleLabel.font = [UIFont systemFontOfSize:10];
         [shopCarBtn setImage:[UIImage imageNamed:@"prefer_addTocar"] forState:UIControlStateNormal];
        [shopCarBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [shopCarBtn addTarget:self action:@selector(myCart) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView sd_addSubviews:@[collectBtn,shopCarBtn]];
        collectBtn.sd_layout
        .leftEqualToView(_bottomView)
        .heightIs(50)
        .topEqualToView(_bottomView)
        .widthIs(50);
        
        shopCarBtn.sd_layout
        .leftSpaceToView(collectBtn, 0)
        .heightIs(50)
        .topEqualToView(_bottomView)
        .widthIs(50);
        
        UIButton *addbtn = [UIButton new];
        [_bottomView addSubview:addbtn];
        addbtn.sd_layout
        .leftSpaceToView(shopCarBtn, 0)
        .widthIs((kSCREEN_WIDTH-100)*0.5)
        .heightIs(50)
        .topEqualToView(_bottomView);
        [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addbtn setBackgroundColor:RGB(255,200,50)];
        addbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addbtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    
        
        UIButton *buybtn = [UIButton new];
        [_bottomView addSubview:buybtn];
        buybtn.sd_layout
        .leftSpaceToView(addbtn, 0)
        .widthIs((kSCREEN_WIDTH-100)*0.5)
        .heightIs(50)
        .topEqualToView(_bottomView);
        [buybtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buybtn setBackgroundColor:RGB(255, 150, 0)];
        buybtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [buybtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (NSMutableArray *)centerDatasArray {
    if (!_centerDatasArray) {
        _centerDatasArray = [NSMutableArray array];
    }
    return _centerDatasArray;
}

- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
        
    }
    
    return _webView;
}

- (UIScrollView *)containerScrollView{
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _containerScrollView.delegate = self;
        _containerScrollView.alwaysBounceVertical = YES;
        _containerScrollView.backgroundColor = RGB_242_242_242;
    }
    
    return _containerScrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGB_242_242_242;
    }
    
    return _contentView;
}

- (NSMutableDictionary *)choosedOptionMap {
    if (!_choosedOptionMap) {
        _choosedOptionMap = [NSMutableDictionary dictionary];
    }
    return _choosedOptionMap;
}
@end
