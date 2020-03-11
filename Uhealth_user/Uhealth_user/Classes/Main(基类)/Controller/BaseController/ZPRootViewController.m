//
//  ZPRootViewController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootViewController.h"
/* 控制器 */
#import "ZPLoginController.h"
#import "ZPBaseNavigationController.h"
#import "ZPBaseTabBarViewController.h"
@interface ZPRootViewController ()

@end

@implementation ZPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAll];
    [self initData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLoginAction) name:kNotificationNeedSignIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLoginAction) name:NSStringFromClass([self class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxloginSuccess) name:kNotificationWXLoginSuccess object:nil];
}

/* 微信登录后无法dismiss */
- (void)wxloginSuccess {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* 初始化界面UI */
- (void)initAll {
    
}

/* 初始化数据 */
- (void)initData {
    
}

/* 刷新界面 */
- (void)refreshPage {
//    [self dismissViewControllerAnimated:YES completion:nil];
    ZPLog(@"刷新界面");
}

/* 结束上次的刷新 */
-(void)endLastRefresh {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/* 弹出登录界面 */
- (void)needLoginAction {
    //如果有刷新 得关闭
    [self endLastRefresh];
    ZPLog(@"当前界面%@",self.navigationController.visibleViewController);
    if (![self.navigationController.visibleViewController isKindOfClass:[ZPLoginController class]]) {
        ZPLoginController *loginControl = [[ZPLoginController alloc] init];
        [self.navigationController pushViewController:loginControl animated:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,1),RGBA(99,205,255,1)]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 导航栏设置
- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY {
    self.navigationBarAlpha = offsetY / 100.0;
    self.navigationController.navigationBar.translucent = self.navigationBarAlpha <1 ?YES:NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,self.navigationBarAlpha >= 0 ? self.navigationBarAlpha : 0),RGBA(99,205,255,self.navigationBarAlpha >= 0 ? self.navigationBarAlpha : 0)]] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)itemBackgroundImage {
    return [[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(30, 30)] zp_cornerImageWithSize:CGSizeMake(30, 30) fillColor:[UIColor clearColor]];
}

//绘制对象背景的渐变色特效
- (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count > 1) {
        //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CGRect rect=CGRectMake(0,0, 1, 1);
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于按钮的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = rect;
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的背景色
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        //使用UIColor的如下方法，将字体颜色设为gradientImage模式，这样就可以将渐变色填充到背景色上了，同理可以设置按钮各状态的不同显示效果
        return gradientImage;
    }
    return nil;
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
