//
//  ZPCheckOutResultController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutResultController.h"
#import "ZPBaseTabBarViewController.h"
#import "ZPMyShoppingCartController.h"
#import "ZPOrderDetailController.h"
#import "ZPMyOrderMainController.h"
#import "ZPReservationServiceController.h"
#import "ZPIndexViewController.h"
#import "ZPShopMallController.h"
@interface ZPCheckOutResultController ()
@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIImageView *statusImageView;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UIButton *backToIndexButton;
@property (nonatomic,strong) UIButton *otherButton;
@end

@implementation ZPCheckOutResultController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initData {
    self.title = @"支付完成";
    self.statusLabel.text = @"支付完成";
    self.tipLabel.text = @"小优正带着你的优选商品飞奔而来";
    self.statusImageView.image = [UIImage imageNamed:@"pay_success"];
}

- (void)initAll {
    self.view.backgroundColor = RGB_242_242_242;
    [self.view addSubview:self.backView];
    self.backView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(325)
    .topEqualToView(self.view);
    
    [self.backView sd_addSubviews:@[self.statusImageView,self.statusLabel,self.tipLabel,self.backToIndexButton,self.otherButton]];
    
    self.statusImageView.sd_layout
    .topSpaceToView(self.backView, 42)
    .centerXEqualToView(self.backView)
    .heightIs(80)
    .widthIs(80);
    
    self.statusLabel.sd_layout
    .topSpaceToView(self.statusImageView, 20)
    .leftSpaceToView(self.backView, 10)
    .rightSpaceToView(self.backView, 10)
    .heightIs(17);
    
    self.tipLabel.sd_layout
    .leftSpaceToView(self.backView, 10)
    .rightSpaceToView(self.backView, 10)
    .heightIs(13)
    .topSpaceToView(self.statusLabel, 22);
    
    self.backToIndexButton.sd_layout
    .leftSpaceToView(self.backView, 48)
    .widthIs(115)
    .heightIs(40)
    .topSpaceToView(self.tipLabel, 53);
    
    self.otherButton.sd_layout
    .rightSpaceToView(self.backView, 48)
    .heightIs(40)
    .widthIs(115)
    .centerYEqualToView(self.backToIndexButton);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

#pragma mark - 私有方法
- (void)backAction {
    //支付成功后  从商品详情过来->返回到商品详情
              //从购物车过来->返回到购物车
    if (self.enterResultType == ZPCheckOutResultTypeFromCart) {
        //购物车
        BOOL isNeed = NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZPMyShoppingCartController class]]) {
                isNeed = YES;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        if (!isNeed) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (self.enterResultType == ZPCheckOutResultTypeFromOrderDetail) {
       //商品详情
        BOOL isNeedDetail = NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZPOrderDetailController class]]) {
                isNeedDetail = YES;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        if (!isNeedDetail) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (self.enterResultType == ZPCheckOutResultTypeFromMyOrder) {
        //我的订单页面
        BOOL isNeedMyOrder = NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZPMyOrderMainController class]]) {
                isNeedMyOrder = YES;
                ZPMyOrderMainController *con = (ZPMyOrderMainController *)controller;
                [con refresh];
                [self.navigationController popToViewController:con animated:YES];
            }
        }
        if (!isNeedMyOrder) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (self.enterResultType == ZPCheckOutResultTypeFromGreenPath) {
        //绿通页面
        BOOL isNeedMyOrder = NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZPReservationServiceController class]]) {
                isNeedMyOrder = YES;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        if (!isNeedMyOrder) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)ramdom {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZPShopMallController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)backToIndex {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZPShopMallController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
    }
    return _statusImageView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.textColor = ZPMyOrderDetailFontColor;
        _statusLabel.font = [UIFont systemFontOfSize:17];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = ZPMyOrderDeleteBorderColor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)backToIndexButton {
    if (!_backToIndexButton) {
        _backToIndexButton = [UIButton new];
        _backToIndexButton.layer.cornerRadius = 5;
        _backToIndexButton.layer.masksToBounds = YES;
        _backToIndexButton.layer.borderColor = ZPMyOrderDetailValueFontColor.CGColor;
        _backToIndexButton.layer.borderWidth = 1;
        [_backToIndexButton setTitleColor:ZPMyOrderDetailValueFontColor forState:UIControlStateNormal];
        _backToIndexButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backToIndexButton setTitle:@"回首页" forState:UIControlStateNormal];
        [_backToIndexButton addTarget:self action:@selector(backToIndex) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToIndexButton;
}

- (UIButton *)otherButton {
    if (!_otherButton) {
        _otherButton = [UIButton new];
        _otherButton.layer.cornerRadius = 5;
        _otherButton.layer.masksToBounds = YES;
        _otherButton.layer.borderColor = ZPMyOrderDeleteBorderColor.CGColor;
        _otherButton.layer.borderWidth = 1;
        [_otherButton setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        [_otherButton setTitle:@"随便逛逛" forState:UIControlStateNormal];
        _otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_otherButton addTarget:self action:@selector(ramdom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}
@end
