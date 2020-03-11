//
//  ZPGreenPathReservationSerController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPGreenPathReservationSerController.h"
/* view */
#import "ZPGreenPathReservationSerTitleCell.h"
#import "ZPGreenPathReservationSerCell.h"
/* model */
#import "ZPMedicalCityServiceModel.h"
@interface ZPGreenPathReservationSerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
/* 确定按钮 */
@property (nonatomic,strong) UIButton *comfirmBtn;
@end

@implementation ZPGreenPathReservationSerController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"预约服务";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, ZPHeight(50), 0));
    [self.view addSubview:self.comfirmBtn];
    self.comfirmBtn.sd_layout
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(ZPHeight(50));
}

- (void)initData {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/medicalCity/%@",ZPBaseUrl,self.cityID] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.data = [ZPMedicalCityServiceModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"cityServices"]];
                //如果存在已有city的模型
                if (self.serviceModelSel) {
                    for (ZPMedicalCityServiceModel *model in weakSelf.data) {
                        if ([model.ID isEqualToString:weakSelf.serviceModelSel.ID]) {
                            model.isSel = YES;
                            weakSelf.serviceModelSel = model;
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
        } className:[ZPGreenPathReservationSerController class]];
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
    
    return 1;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1+self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZPGreenPathReservationSerTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPGreenPathReservationSerTitleCell class])];
        return cell;
    }
    WEAK_SELF(weakSelf);
    ZPGreenPathReservationSerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPGreenPathReservationSerCell class])];
    ZPMedicalCityServiceModel *model = self.data[indexPath.row-1];
    cell.model = model;
    cell.selServiceBlock = ^(BOOL isSel) {
        weakSelf.comfirmBtn.selected = NO;
        weakSelf.comfirmBtn.userInteractionEnabled = NO;
        for (ZPMedicalCityServiceModel *tempmodel in weakSelf.data) {
            tempmodel.isSel = NO;
            if (isSel) {
                if ([tempmodel.ID isEqualToString:model.ID]) {
                    tempmodel.isSel = YES;
                    weakSelf.serviceModelSel = model;
                    weakSelf.comfirmBtn.selected = YES;
                    weakSelf.comfirmBtn.userInteractionEnabled = YES;
                }
            }
        }
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:tableView];
    }
    ZPMedicalCityServiceModel *model = self.data[indexPath.row-1];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ZPGreenPathReservationSerCell class] contentViewWidth:kSCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        ZPMedicalCityServiceModel *model = self.data[indexPath.row-1];
        if (model.serviceTypeInformationImg != nil && ![model.serviceTypeInformationImg isKindOfClass:[NSNull class]]) {
            model.isExpand = !model.isExpand;
            [tableView reloadData];
        }
    }
}

//确定事件
- (void)comfirmServiceAction {
    if (self.selectedServiceBlock) {
        self.selectedServiceBlock(self.serviceModelSel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPGreenPathReservationSerTitleCell class] forCellReuseIdentifier:NSStringFromClass([ZPGreenPathReservationSerTitleCell class])];
        [_tableView registerClass:[ZPGreenPathReservationSerCell class] forCellReuseIdentifier:NSStringFromClass([ZPGreenPathReservationSerCell class])];
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UIButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [UIButton new];
        [_comfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirmBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(18)];
        _comfirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_comfirmBtn setBackgroundImage:[UIImage imageWithColor:RGB(204,204,204)] forState:UIControlStateNormal];
        [_comfirmBtn setBackgroundImage:[UIImage imageWithColor:RGB_78_178_255] forState:UIControlStateSelected];
        _comfirmBtn.userInteractionEnabled = NO;
        _comfirmBtn.selected = NO;
        [_comfirmBtn addTarget:self action:@selector(comfirmServiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}

@end
