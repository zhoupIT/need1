//
//  ZPAuthorityChannelController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAuthorityChannelController.h"
/* model */
#import "ZPAdvisoryChannelModel.h"
/* view */
#import "ZPAuthorityChannelCell.h"
/* controller */
#import "ZPAuthorityCenterController.h"

@interface ZPAuthorityChannelController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *channelDatas;
@end

@implementation ZPAuthorityChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"权威频道";
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)initData {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UICollectionView *collectionView = self.collectionView;
    // 下拉刷新
    collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/channel" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [collectionView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.channelDatas  = [ZPAdvisoryChannelModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [collectionView reloadData];
                [collectionView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [collectionView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPAuthorityChannelController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/channel" parameters:@{@"offset":[NSNumber numberWithInteger:self.channelDatas.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [collectionView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPAdvisoryChannelModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
    
                    [collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.channelDatas addObjectsFromArray:arrays];
                    [collectionView reloadData];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
            // 结束刷新
            [collectionView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPAuthorityChannelController class]];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
    [self.collectionView.mj_header endRefreshing];
}

/* 刷新界面 */
- (void)refreshPage {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZPAuthorityChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZPAuthorityChannelCell class]) forIndexPath:indexPath];
    cell.model = self.channelDatas[indexPath.row];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZPAdvisoryChannelModel *model = self.channelDatas[indexPath.row];
    if ([model.channelStatus.name isEqualToString:@"NORMAL"]) {
        ZPAuthorityCenterController *authorityCenterControl = [[ZPAuthorityCenterController alloc] init];
        authorityCenterControl.channelModel = model;
        [self.navigationController pushViewController:authorityCenterControl animated:YES];
    } else {
        [LEEAlert alert].config
        .LeeTitle(@"提醒")
        .LeeContent(model.channelStatus.text)
        .LeeAction(@"确认", ^{
        })
        .LeeClickBackgroundClose(YES)
        .LeeShow();
    }
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸(行距,列距)
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        // 设置cell的宽度
        //ZPWidth(165)
        layout.itemSize = CGSizeMake((kSCREEN_WIDTH-45)*0.5, ZPHeight(100));
        layout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZPAuthorityChannelCell class] forCellWithReuseIdentifier:NSStringFromClass([ZPAuthorityChannelCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)channelDatas {
    if (!_channelDatas) {
        _channelDatas = [NSMutableArray array];
    }
    return _channelDatas;
}

@end
