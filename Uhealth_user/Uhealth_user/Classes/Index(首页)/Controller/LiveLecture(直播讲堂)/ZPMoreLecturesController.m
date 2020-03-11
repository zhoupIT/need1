//
//  ZPMoreLecturesController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMoreLecturesController.h"
/* model */
#import "ZPLectureModel.h"
/* view */
#import "ZPLivingBroadcastCell.h"
/* controller */
#import "ZPLivingBroadcastController.h"
@interface ZPMoreLecturesController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation ZPMoreLecturesController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
   
    self.title = self.allLecture?@"直播讲堂":@"TA的其它直播";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    if (self.allLecture) {
        [self setupAllRefresh];
    } else {
        [self setupHistoryRefresh];
    }
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_lecture_icon"
                                                            titleStr:@""
                                                           detailStr:@""];
}

- (void)setupAllRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"lecture/all" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.data = [ZPLectureModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMoreLecturesController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"lecture/all" parameters:@{@"offset":[NSNumber numberWithInteger:self.data.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPLectureModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.data addObjectsFromArray:arrays];
                    [tableView reloadData];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMoreLecturesController class]];
    }];
    
}

- (void)setupHistoryRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"lecture/history" parameters:@{@"doctorId":self.doctorId,@"id":self.toplectureId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.data = [ZPLectureModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
               
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMoreLecturesController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"lecture/history" parameters:@{@"offset":[NSNumber numberWithInteger:self.data.count],@"doctorId":self.doctorId,@"id":self.toplectureId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPLectureModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.data addObjectsFromArray:arrays];
                    [tableView reloadData];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPMoreLecturesController class]];
    }];
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
    
    return self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPLivingBroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPLivingBroadcastCell class])];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:self.data[indexPath.row] keyPath:@"model" cellClass:[ZPLivingBroadcastCell class] contentViewWidth:kSCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZPLivingBroadcastController *control = [[ZPLivingBroadcastController alloc] init];
    ZPLectureModel *model = self.data[indexPath.row];
    control.ID = model.ID;//课程id 
    control.doctorId = model.doctorId;//医生id
    [self.navigationController pushViewController:control animated:YES];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB_242_242_242;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPLivingBroadcastCell class] forCellReuseIdentifier:NSStringFromClass([ZPLivingBroadcastCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
