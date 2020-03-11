//
//  ZPAuthorityCenterController.m
//  UHealth
//
//  Created by Biao Geng on 2018/8/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAuthorityCenterController.h"
/* model */
#import "ZPChannelDoctorModel.h"
#import "ZPCommonBannerModel.h"
#import "ZPAdvisoryChannelModel.h"
#import "ZPHealthNewsModel.h"
#import "ZPHealthWindModel.h"
#import "ZPCommodity.h"
/* view */
#import "ZPAuthorityCenterCell.h"
/* controller */
#import "ZPRootArticleWebViewController.h"
#import "ZPAuthorityDoctorController.h"
#import "ZPLivingBroadcastFromBannerController.h"
#import "ZPOrderDetailController.h"
/* 第三方 */
#import "SDCycleScrollView.h"


@interface ZPAuthorityCenterController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *bannerDatas;
@property (nonatomic,strong) NSMutableArray *doctorDatas;
@end

@implementation ZPAuthorityCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = self.channelModel.channelType.text;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.tableHeaderView = self.cycleScrollView;
}

- (void)initData {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"channel/detail" parameters:@{@"channelId":self.channelModel.ID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.bannerDatas = [ZPCommonBannerModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"banner"]];
                weakSelf.doctorDatas  = [ZPChannelDoctorModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"doctor"]];
                NSMutableArray *tempArray = [NSMutableArray array];
                for (ZPCommonBannerModel *bannerModel in weakSelf.bannerDatas) {
                    [tempArray addObject:bannerModel.banner];
                }
                weakSelf.cycleScrollView.imageURLStringsGroup = tempArray;
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPAuthorityCenterController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"channel/detail" parameters:@{@"offset":[NSNumber numberWithInteger:self.doctorDatas.count],@"channelId":self.channelModel.ID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPChannelDoctorModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"doctor"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.doctorDatas addObjectsFromArray:arrays];
                    [tableView reloadData];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPAuthorityCenterController class]];
    }];
    [self.tableView.mj_header beginRefreshing];
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
    [self.tableView.mj_header endRefreshing];
}

/* 刷新界面 */
- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
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
    
    return self.doctorDatas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPAuthorityCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPAuthorityCenterCell class])];
    cell.model = self.doctorDatas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      return [tableView cellHeightForIndexPath:indexPath model:self.doctorDatas[indexPath.row] keyPath:@"model" cellClass:[ZPAuthorityCenterCell class] contentViewWidth:kSCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZPAuthorityDoctorController *control = [[ZPAuthorityDoctorController alloc] init];
    control.doctorModel = self.doctorDatas[indexPath.row];
    [self.navigationController pushViewController:control animated:YES];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    /*
     bannerType的类型
     ZPEALTH_DIRECTION     健康风向
     ZPEALTH_INFORMATION   健康资讯
     COMMONDITY            商品
     LINK                  链接
     null                  单纯图片
     */
    ZPCommonBannerModel *model = self.bannerDatas[index];
    if ([model.bannerType.name isEqualToString:@"UHLEEALTH_INFORMATION"]) {
        
        //健康资讯
        ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
        ZPHealthNewsModel *healthNewsModel = [[ZPHealthNewsModel alloc] init];
        healthNewsModel.informationId = model.bannerAim;;
        webView.healthNewsModel = healthNewsModel;
        webView.bannerAim = model.bannerAim;
        webView.url = newsArticleUrl(model.bannerAim);
        webView.titleString = @"健康资讯";
        //设置文章类型
        webView.articelType = ZPArticleTypeNews;
        //从banner跳转来的
        webView.enterStatusType = ZPArticleEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"UHEALTH_DIRECTION"]) {
        //健康风向
        ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
        ZPHealthWindModel *windModel =  [[ZPHealthWindModel alloc] init];
        windModel.directionId = model.bannerAim;
        webView.url = windArticleUrl(model.bannerAim);
        webView.titleString = @"优医健康";
        webView.healthWindModel = windModel;
        webView.bannerAim = model.bannerAim;
        //设置文章类型
        webView.articelType = ZPArticleTypeWind;
        //从banner跳转来的
        webView.enterStatusType = ZPArticleEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"COMMONDITY"]) {
        ZPLog(@"跳转商品ID:%@",model.bannerAim);
        ZPOrderDetailController *orderDetailControl = [[ZPOrderDetailController alloc] init];
        ZPCommodity *commodity = [[ZPCommodity alloc] init];
        commodity.commodityId = [model.bannerAim integerValue];
        orderDetailControl.commodity = commodity;
        orderDetailControl.enterStatusType = ZPOrderEnterStatusTypeBanner;
        [self.navigationController pushViewController:orderDetailControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LINK"]) {
        ZPLog(@"跳转链接:%@",model.bannerAim);
        ZPRootWebViewController *htmlWebControl = [[ZPRootWebViewController alloc]init];
        htmlWebControl.url = model.bannerAim;
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LONG_IMAGE"]) {
        ZPLog(@"跳转长图:%@",[NSString stringWithFormat:@"%@/ios/html/index.html?type=HUTDETAIL&imgUrl=%@",ZPBaseUrl,model.bannerAim]);
        ZPRootWebViewController *htmlWebControl = [[ZPRootWebViewController alloc]init];
        htmlWebControl.url = urlLongImage(model.bannerAim);
        htmlWebControl.titleString = model.bannerName;
        htmlWebControl.initCloseBtn = YES;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LECTURE_ROOM"]) {
        ZPLivingBroadcastFromBannerController *livinglectureControl = [[ZPLivingBroadcastFromBannerController alloc] init];
        livinglectureControl.ID = model.bannerAim;
        [self.navigationController pushViewController:livinglectureControl animated:YES];
    }
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, ZPHeight(200)) imageURLStringsGroup:@[]];
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.delegate = self;
        _cycleScrollView.currentPageDotImage = [UIImage imageWithColor:ZPMyOrderDetailValueFontColor size:CGSizeMake(15, 5) cornerRadius:3];
        _cycleScrollView.pageDotImage = [UIImage imageWithColor:RGBA(0, 0, 0, 0.34) size:CGSizeMake(15, 5) cornerRadius:3];
    }
    return _cycleScrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPAuthorityCenterCell class] forCellReuseIdentifier:NSStringFromClass([ZPAuthorityCenterCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
