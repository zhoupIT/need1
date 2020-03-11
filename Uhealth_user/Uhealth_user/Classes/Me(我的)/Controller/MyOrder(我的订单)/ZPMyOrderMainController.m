//
//  ZPMyOrderMainController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyOrderMainController.h"
#import "VTMagic.h"
#import "ZPMyOrderController.h"
#import "ZPMyOrderDetailController.h"
#import "ZPOrderModel.h"
#import "ZPPayController.h"
#import "ZPMyShoppingCartController.h"
#import "ZPOrderDetailController.h"
#import "ZPReservationServiceController.h"
#import "ZPTracesController.h"
@interface ZPMyOrderMainController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation ZPMyOrderMainController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)initAll {
    self.title = @"我的订单";
    self.view.backgroundColor = RGB_242_242_242;
    [self.view addSubview:self.magicController.view];
    self.magicController.view.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)initData {
    _menuList = @[@"全部订单", @"待付款",@"待发货",@"待收货",@"待评价"];
    [_magicController.magicView reloadData];
    [_magicController switchToPage:self.index animated:YES];
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
//    [self.tableView.mj_header endRefreshing];
}

/* 刷新界面 */
- (void)refreshPage {
    [_magicController.magicView reloadData];
    [_magicController switchToPage:self.index animated:YES];
}

#pragma mark - private
- (void)back {
    BOOL isNeed = NO;
    BOOL isNeedDetail = NO;
    BOOL isNeedGreenPath = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZPMyShoppingCartController class]]) {
            isNeed = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
     }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZPOrderDetailController class]]) {
            isNeedDetail = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZPReservationServiceController class]]) {
            isNeedGreenPath = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    if (!isNeed && !isNeedDetail && !isNeedGreenPath) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGB_78_178_255 forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    ZPLog(@"viewControllerAtPage %ld",pageIndex);
    static NSString *gridId = @"relate.identifier";
    WEAK_SELF(weakSelf);
    ZPMyOrderController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[ZPMyOrderController alloc] init];
    }
//    viewController.orderStatusType = pageIndex;
    viewController.detailClickEventBlock = ^(ZPOrderModel *model){
        ZPMyOrderDetailController *myorderDetailCtrol = [[ZPMyOrderDetailController alloc] init];
        myorderDetailCtrol.orderModel = model;
        myorderDetailCtrol.updateTableBlock = ^{
             [_magicController.magicView reloadData];
        };
        [weakSelf.navigationController pushViewController:myorderDetailCtrol animated:YES];
    };
    viewController.payBlock = ^(ZPOrderModel *model) {
        ZPPayController *payControl = [[ZPPayController alloc] init];
        payControl.orderID =model.orderId;
        /*
        if (model.orderType.code == 1010) {
            //绿通服务
             payControl.payEnterType = ZPPayEnterTypeGreenPath;
        } else {
             payControl.payEnterType = ZPPayEnterTypeNormal;
        }
       */
         payControl.payEnterType = ZPPayEnterTypeNormal;
        [weakSelf.navigationController pushViewController:payControl animated:YES];
    };
    viewController.traceBlock = ^(ZPOrderModel *model) {
      //物流
        ZPTracesController *tracesControl = [[ZPTracesController alloc] init];
        tracesControl.orderId = model.orderId;
        [weakSelf.navigationController pushViewController:tracesControl animated:YES];
    };
    viewController.refreshTableBlock = ^{
         [_magicController.magicView reloadData];
    };
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    ZPLog(@"viewDidAppear %ld",pageIndex);
    ZPMyOrderController *viewControllerTemp = viewController;
    viewControllerTemp.orderStatusType = pageIndex;
}

- (void)refresh {
    if (_magicController && _magicController.magicView) {
        [_magicController.magicView reloadData];
    }
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGB_78_178_255;
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationHeight = 46.f;
        _magicController.magicView.sliderExtension = 10.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}


@end
