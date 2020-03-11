//
//  ZPBaseTabBarViewController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPBaseTabBarViewController.h"
/* 加载的控制器 */
#import "ZPIndexViewController.h"
#import "ZPShopMallController.h"
#import "ZPUserController.h"
/* 自定义的tabbar */
#import "ZPTabBar.h"
#import "ZPBaseNavigationController.h"
@interface ZPBaseTabBarViewController ()
@property (nonatomic,strong) ZPTabBar *uhtabbar;
@end

@implementation ZPBaseTabBarViewController

+ (void)initialize {
    NSDictionary *norAttr = @{
                              NSForegroundColorAttributeName : RGB_102_102_102
                              };
    NSDictionary *selAttr = @{
                              NSForegroundColorAttributeName : RGB_78_178_255
                              };
    [[UITabBarItem appearance] setTitleTextAttributes:norAttr forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selAttr forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:RGB_255_255_255];
    [[UITabBar appearance] setBarTintColor:RGB_255_255_255];
    //设置不透明
    [[UITabBar appearance] setTranslucent:NO];
    
    //去除tabbar上的黑线
    [UITabBar appearance].backgroundImage = [UIImage new];
    [UITabBar appearance].shadowImage = [UIImage new];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    ZPIndexViewController *view1 = [[ZPIndexViewController alloc] init];
    ZPShopMallController *view2 = [[ZPShopMallController alloc] init];
    ZPUserController *view3 = [[ZPUserController alloc] init];
    
    [self addChildVC:view1 title:@"首页" image:@"tabbar_index_icon" selImage:@"tabbar_index_sel_icon"];
    [self addChildVC:view2 title:@"优选" image:@"tabbar_prefer_icon" selImage:@"tabbar_prefer_icon"];
    [self addChildVC:view3 title:@"我的" image:@"tabbar_me_icon" selImage:@"tabbar_me_sel_icon"];
    
    self.selectedIndex = 0;
    
    self.tabBar.layer.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.16f].CGColor;;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBar.layer.shadowOpacity = 1;
    self.tabBar.layer.shadowRadius = 3;
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage
{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    ZPBaseNavigationController *nvc = [[ZPBaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nvc];
}

- (void)buttonAction:(UIButton *)button{
    if (!self.tabBar.hidden) {
        self.selectedIndex = 1;//关联中间按钮
    }
}

@end
