//
//  ZPGreenPathController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathController.h"

/* 控制器 */
#import "ZPHelpCenterController.h"
#import "ZPReservationServiceController.h"
/* model */
#import "ZPCommonBannerModel.h"
/* cell */
#import "ZPGreenPathCell.h"
/* 第三方 */
#import "SDCycleScrollView.h"
@interface ZPGreenPathController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *bannerDatas;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *items;

@property (nonatomic,strong) ZPImg *introductionImg;//服务介绍
@property (nonatomic,strong) ZPImg *processImg;
@end

@implementation ZPGreenPathController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"绿色通道";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleDone target:self action:@selector(helpCenter)];
}

- (void)initData {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/information",ZPBaseUrl] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.bannerDatas = [ZPCommonBannerModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"bannerList"]];
                weakSelf.introductionImg = [ZPImg mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"introductionImg"]];
                weakSelf.processImg = [ZPImg mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"processImg"]];
                NSMutableArray *tempArray = [NSMutableArray array];
                for (ZPCommonBannerModel *bannerModel in weakSelf.bannerDatas) {
                    [tempArray addObject:bannerModel.banner];
                }
                weakSelf.cycleScrollView.imageURLStringsGroup = tempArray;
                [tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPGreenPathController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
     [self.tableView.mj_header beginRefreshing];
}


- (void)helpCenter {
    ZPHelpCenterController *helpControl = [[ZPHelpCenterController alloc] init];
    [self.navigationController pushViewController:helpControl animated:YES];
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
    
    return 2;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPGreenPathCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPGreenPathCell class])];
    cell.titleStr = self.items[indexPath.row][@"titleStr"];
    cell.titleBtnStr = self.items[indexPath.row][@"titleBtnStr"];
    cell.titleBtnImgStr = self.items[indexPath.row][@"titleBtnImgStr"];
    WEAK_SELF(weakSelf);
    cell.btnDidClickBlock = ^(UIButton * _Nonnull btn) {
        if ([btn.titleLabel.text containsString:@"电话"]) {
            [weakSelf callAction];
        } else {
            ZPReservationServiceController *control = [[ZPReservationServiceController alloc] init];
            control.processImg = weakSelf.processImg;
            [weakSelf.navigationController pushViewController:control animated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)callAction {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",hotLineNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZPHeight(50.f);
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat w = kSCREEN_WIDTH;
    CGFloat height = 0;
    if ( w <= self.introductionImg.width) {
        height = (w / self.introductionImg.width) * self.introductionImg.height;
    } else{
        height = self.introductionImg.height;
    }
    return ZPHeight(height+10);
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    contentView.backgroundColor = RGB_242_242_242;
    UIImageView *view=[UIImageView new];
    [contentView addSubview:view];
    view.sd_layout.spaceToSuperView(UIEdgeInsetsMake(ZPHeight(10), 0, 0, 0));
    view.backgroundColor = [UIColor clearColor];
    [view sd_setImageWithURL:[NSURL URLWithString:self.introductionImg.url] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    return contentView;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPGreenPathCell class] forCellReuseIdentifier:NSStringFromClass([ZPGreenPathCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, ZPHeight(150)) imageURLStringsGroup:@[]];
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.delegate = self;
        _cycleScrollView.currentPageDotImage = [UIImage imageWithColor:RGB_78_178_255 size:CGSizeMake(15, 5) cornerRadius:3];
        _cycleScrollView.pageDotImage = [UIImage imageWithColor:RGBA(0, 0, 0, 0.34) size:CGSizeMake(15, 5) cornerRadius:3];
    }
    return _cycleScrollView;
}

- (NSMutableArray *)bannerDatas {
    if (!_bannerDatas) {
        _bannerDatas = [NSMutableArray array];
    }
    return _bannerDatas;
}

- (NSArray<NSDictionary *> *)items {
    return @[@{@"titleStr" : @"绿通电话预约", @"titleBtnStr" : @"电话预约", @"titleBtnImgStr" : @"greenPath_phone_icon"},
             @{@"titleStr" : @"绿通在线预约", @"titleBtnStr" : @"在线预约", @"titleBtnImgStr" : @"greenPath_reser_icon"}];
}

@end
