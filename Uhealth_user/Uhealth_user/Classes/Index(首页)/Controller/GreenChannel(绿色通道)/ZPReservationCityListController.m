//
//  ZPReservationCityListController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPReservationCityListController.h"
/* model */
#import "ZPReservationCityModel.h"
#import "ZPCityServicesModel.h"
/* view */
#import "ZPReservationCityListCell.h"

@interface ZPReservationCityListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation ZPReservationCityListController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
 
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ZPReservationCityListCell class] forCellReuseIdentifier:NSStringFromClass([ZPReservationCityListCell class])];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    if (self.type == ZPGreenChannelSelEnterStatusTypeService) {
        self.title = @"预约服务";
        self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                titleStr:@"暂无服务"
                                                               detailStr:@""];
    } else {
        self.title = @"预约城市";
        self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                titleStr:@"暂无城市"
                                                               detailStr:@""];
    }
}

- (void)initData {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.type == ZPGreenChannelSelEnterStatusTypeCity) {
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"medicalCity/list" parameters:nil progress:^(NSProgress *progress) {

            } success:^(NSURLSessionDataTask *task, id response) {
                [tableView.mj_header endRefreshing];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    weakSelf.data = [ZPReservationCityModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                    //如果存在已有city的模型
                    if (weakSelf.cityModelSel) {
                        for (ZPReservationCityModel *model in weakSelf.data) {
                            if ([model.ID isEqualToString:weakSelf.cityModelSel.ID]) {
                                model.isSel = YES;
                            }
                        }
                    }
                    [tableView reloadData];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView.mj_header endRefreshing];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPReservationCityListController class]];
        } else {
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/medicalCity/%@",ZPBaseUrl,self.ID] parameters:nil progress:^(NSProgress *progress) {

            } success:^(NSURLSessionDataTask *task, id response) {
                [tableView.mj_header endRefreshing];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    weakSelf.data = [ZPCityServicesModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"cityServices"]];
                    //如果存在已有city的模型
                    if (weakSelf.serviceModelSel) {
                        for (ZPCityServicesModel *model in weakSelf.data) {
                            if ([model.ID isEqualToString:weakSelf.serviceModelSel.ID]) {
                                model.isSel = YES;
                            }
                        }
                    }
                    [tableView reloadData];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView.mj_header endRefreshing];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPReservationCityListController class]];
        }

    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
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
    
    return self.data.count;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
    ZPReservationCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPReservationCityListCell class])];
    if (self.type == ZPGreenChannelSelEnterStatusTypeCity) {
        ZPReservationCityModel *model = self.data[indexPath.section];
        cell.model = model;
        cell.didClickBlock = ^(UIButton *btn) {
            for (ZPReservationCityModel *model in weakSelf.data) {
                model.isSel = NO;
            }
            ZPReservationCityModel *model =  weakSelf.data[indexPath.section];
            model.isSel = YES;
            weakSelf.cityModelSel = model;
            [tableView reloadData];
            
            if (weakSelf.selectedCityBlock) {
                weakSelf.selectedCityBlock(model);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
    } else {
        ZPCityServicesModel *model = self.data[indexPath.section];
        cell.servicesModel = model;
        cell.didClickBlock = ^(UIButton *btn) {
            for (ZPCityServicesModel *model in weakSelf.data) {
                model.isSel = NO;
            }
            ZPCityServicesModel *model =  weakSelf.data[indexPath.section];
            model.isSel = YES;
            weakSelf.serviceModelSel = model;
            [tableView reloadData];
            if (weakSelf.selectedServiceBlock) {
                weakSelf.selectedServiceBlock(model);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == ZPGreenChannelSelEnterStatusTypeCity) {
        for (ZPReservationCityModel *model in self.data) {
            model.isSel = NO;
        }
        ZPReservationCityModel *model =   self.data[indexPath.section];
        model.isSel = YES;
        [tableView reloadData];
        if (self.selectedCityBlock) {
            self.selectedCityBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        for (ZPCityServicesModel *model in self.data) {
            model.isSel = NO;
        }
        ZPCityServicesModel *model =   self.data[indexPath.section];
        model.isSel = YES;
        [tableView reloadData];
        if (self.selectedServiceBlock) {
            self.selectedServiceBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
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
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

@end
