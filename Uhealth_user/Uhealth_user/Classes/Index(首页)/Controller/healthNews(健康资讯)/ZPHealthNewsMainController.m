//
//  ZPHealthNewsMainController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHealthNewsMainController.h"
#import "VTMagic.h"
#import "ZPHealthNewsController.h"
#import "ZPRootArticleWebViewController.h"

@interface ZPHealthNewsMainController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation ZPHealthNewsMainController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _menuList = @[@"综合",@"心理", @"儿童",@"孕妇",@"老人",@"女性"];
    [_magicController.magicView reloadData];
}

- (void)setupUI {
    self.title = @"健康资讯";
    self.view.backgroundColor = RGB_242_242_242;
    [self.view addSubview:self.magicController.view];
    self.magicController.view.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
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
    static NSString *gridId = @"relate.identifier";
    ZPHealthNewsController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[ZPHealthNewsController alloc] init];
    }
    viewController.didClickBlock = ^(NSString *mainBody,ZPHealthNewsModel *healthNewsModel){
        //健康资讯
        ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
        webView.healthNewsModel = healthNewsModel;
        webView.url = mainBody;
        webView.titleString = @"健康资讯";
        //设置文章类型
        webView.articelType = ZPArticleTypeNews;
        //正常跳转来的
        webView.enterStatusType = ZPArticleEnterStatusTypeNormal;
        [self.navigationController pushViewController:webView animated:YES];
    };
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    ZPHealthNewsController *viewControllerTemp = viewController;
    viewControllerTemp.pageIndex = pageIndex;
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
