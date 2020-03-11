//
//  ZPCabinController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCabinController.h"
/* model */
#import "ZPCabinDetailModel.h"
#import "ZPNurseModel.h"
/* view */
#import "ZPNurseCell.h"
#import "ZPCarbinTitleCell.h"
#import "ZPCarbinImgCell.h"
#import "ZPCarbinServiceCell.h"
/* controller */
#import "ZPRootWebViewController.h"
@interface ZPCabinController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UILabel *titleNavLabel;
@end

@implementation ZPCabinController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.titleNavLabel;
}

- (void)initData {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cabin/detail" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            ZPCabinDetailModel *cabinDetailModel = [ZPCabinDetailModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            weakSelf.model = cabinDetailModel;
            weakSelf.titleNavLabel.text = cabinDetailModel.healthCabinName;
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPCabinController class]];
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
   
}

/* 刷新界面 */
- (void)refreshPage {
    [self initData];
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
    
    return self.data.count+3;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
    if (indexPath.row == 0) {
        ZPNurseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPNurseCell class])];
        cell.model = self.model;
        cell.contactNurseBlock = ^(ZPNurseModel *model) {
            if (model.nursePhone && model.nursePhone.length) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.nursePhone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [weakSelf.view addSubview:callWebview];
            }
        };
        return cell;
    } else if (indexPath.row == 1) {
        ZPCarbinTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCarbinTitleCell class])];
        cell.dict = self.data[0];
        return cell;
    } else if (indexPath.row == 2) {
        ZPCarbinImgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCarbinImgCell class])];
        cell.model = self.model;
        return  cell;
    } else if (indexPath.row == 3) {
        ZPCarbinTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCarbinTitleCell class])];
        cell.dict = self.data[1];
        return cell;
    }
    ZPCarbinServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPCarbinServiceCell class])];
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //244
        return ZPHeight(254.0f);
    } else if (indexPath.row == 2) {
        return ZPHeight(70.0f);
    } else if (indexPath.row == 4) {
        return ZPHeight(120.0f);
    }
    return ZPHeight(47.0f);
}

#pragma mark - 导航栏设置
//- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY {
//    CGFloat alpha = offsetY / 100.0;
//    ZPLog(@"%f",alpha);
//    self.navigationController.navigationBar.translucent = alpha <1 ?YES:NO;
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,alpha >= 0 ? alpha : 0),RGBA(99,205,255,alpha >= 0 ? alpha : 0)]] forBarMetrics:UIBarMetricsDefault];
//}
//
//- (UIImage *)itemBackgroundImage {
//    return [[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(30, 30)] zp_cornerImageWithSize:CGSizeMake(30, 30) fillColor:[UIColor clearColor]];
//}
//
////绘制对象背景的渐变色特效
//- (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors {
//    if (colors.count > 1) {
//        //有多种颜色，需要渐变层对象来上色
//        //创建渐变层对象
//        CGRect rect=CGRectMake(0,0, 1, 1);
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        //设置渐变层的frame等同于按钮的frame（这里高度有个小误差，补上就可以了）
//        gradientLayer.frame = rect;
//        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
//        NSMutableArray *gradientColors = [NSMutableArray array];
//        for (UIColor *colorItem in colors) {
//            [gradientColors addObject:(id)colorItem.CGColor];
//        }
//        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
//        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的背景色
//        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
//        //使用UIColor的如下方法，将字体颜色设为gradientImage模式，这样就可以将渐变色填充到背景色上了，同理可以设置按钮各状态的不同显示效果
//        return gradientImage;
//    }
//    return nil;
//}
//
////将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
//- (UIImage *)imageFromLayer:(CALayer *)layer {
//    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
//    [layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return outputImage;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    self.scrollOffsetY = offsetY;
//    [self changeNavigationBarStyleWhenScroll:offsetY];
//    [self setNavItem];
//}

#pragma mark - -界面的消失与出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //改变导航栏的颜色
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    [self setNavItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    [self setNavItem];
}

/* 设置导航栏上的item */
- (void)setNavItem {
    if (self.navigationBarAlpha < 0.3) {
        self.titleNavLabel.text = @"";
    } else {
        self.titleNavLabel.text = self.model.healthCabinName;
    }
}



- (void)cabinIntroductionEvent {
    ZPRootWebViewController *htmlWebControl = [[ZPRootWebViewController alloc]init];
    htmlWebControl.url = cabinUrl(self.model.cabinDetail);
    htmlWebControl.titleString = @"小屋详情";
    ZPLog(@"小屋地址:%@", htmlWebControl.url );
    [self.navigationController pushViewController:htmlWebControl animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPCarbinTitleCell class] forCellReuseIdentifier:NSStringFromClass([ZPCarbinTitleCell class])];
        [_tableView registerClass:[ZPCarbinImgCell class] forCellReuseIdentifier:NSStringFromClass([ZPCarbinImgCell class])];
        [_tableView registerClass:[ZPCarbinServiceCell class] forCellReuseIdentifier:NSStringFromClass([ZPCarbinServiceCell class])];
         [_tableView registerClass:[ZPNurseCell class] forCellReuseIdentifier:NSStringFromClass([ZPNurseCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, ZPHeight(116))];
        
        UIButton *btn = [UIButton new];
        [footView addSubview:btn];
        btn.sd_layout
        .centerYEqualToView(footView)
        .centerXEqualToView(footView)
        .widthIs(ZPWidth(190))
        .heightIs(ZPHeight(16));
        [btn setTitle:@">>点击进入健康小屋详情介绍" forState:UIControlStateNormal];
        [btn setTitleColor:ZPMyOrderDetailValueFontColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(14)];
        [btn addTarget:self action:@selector(cabinIntroductionEvent) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

- (UILabel *)titleNavLabel {
    if (!_titleNavLabel) {
        _titleNavLabel = [UILabel new];
        _titleNavLabel.text = @"";
        _titleNavLabel.textColor = [UIColor whiteColor];
        _titleNavLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(17)];
    }
    return _titleNavLabel;
}

- (NSArray *)data {
    if (!_data) {
        _data =@[@{@"icon":@"me_carbinImg_icon",@"title":@"小屋内景，功能配备"},@{@"icon":@"me_carbinService_icon",@"title":@"小屋特色服务"}];
    }
    return _data;
}
@end
