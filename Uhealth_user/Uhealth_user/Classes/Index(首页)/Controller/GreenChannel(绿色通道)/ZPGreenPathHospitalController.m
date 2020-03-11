//
//  ZPGreenPathHospitalController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathHospitalController.h"
/* model */
#import "ZPHospitalModel.h"
/* view */
#import "ZPGreenPathHospitalCell.h"
/* controller */

@interface ZPGreenPathHospitalController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
//选中的医院
@property (nonatomic,strong) ZPHospitalModel *selectedHospitalModel;
@end

@implementation ZPGreenPathHospitalController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.title = @"选择医院";
}

- (void)initData {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cityService/hospital" parameters:@{@"cityServiceId":self.cityServiceId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.datas = [ZPHospitalModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (weakSelf.hospitalModelSel) {
                    for (ZPHospitalModel *model in weakSelf.datas) {
                        if ([model.ID isEqualToString:weakSelf.hospitalModelSel.ID]) {
                            model.isSel = YES;
                        }
                    }
                }
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPGreenPathHospitalController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cityService/hospital" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"cityServiceId":self.cityServiceId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPHospitalModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                    
                } else {
                    if (weakSelf.hospitalModelSel) {
                        for (ZPHospitalModel *model in arrays) {
                            if ([model.ID isEqualToString:weakSelf.hospitalModelSel.ID]) {
                                model.isSel = YES;
                            }
                        }
                    }
                    [weakSelf.datas addObjectsFromArray:arrays];
                    [tableView reloadData];
                    
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPGreenPathHospitalController class]];
    }];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"还未有医院"
                                                           detailStr:@""];
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
    
    return self.datas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPGreenPathHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPGreenPathHospitalCell class])];
    WEAK_SELF(weakSelf);
    ZPHospitalModel *model = self.datas[indexPath.row];
    cell.model = model;
    cell.selHospitalBlock = ^(BOOL sel) {
        for (ZPHospitalModel *model in weakSelf.datas) {
            model.isSel = NO;
        }
        model.isSel = YES;
        [weakSelf.tableView reloadData];
        if (weakSelf.selHospitalBlock) {
            weakSelf.selHospitalBlock(model);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:self.datas[indexPath.row] keyPath:@"model" cellClass:[ZPGreenPathHospitalCell class] contentViewWidth:kSCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB_242_242_242;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZPGreenPathHospitalCell class] forCellReuseIdentifier:NSStringFromClass([ZPGreenPathHospitalCell class])];
    }
    return _tableView;
}

@end
