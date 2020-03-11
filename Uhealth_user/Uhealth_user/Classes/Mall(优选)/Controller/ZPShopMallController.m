//
//  ZPShopMallController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/10/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPShopMallController.h"

/* model */
#import "ZPCommodity.h"
/* view */
#import "ZPShopMallCell.h"
/* controller */
#import "ZPMyShoppingCartController.h"
#import "ZPOrderDetailController.h"
/* 三方 */
#import "WZLBadgeImport.h"
@interface ZPShopMallController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *datas;
@end

@implementation ZPShopMallController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    UILabel *label = [UILabel new];
    label.text = @"微生态健康解决方案";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(18)];
    self.navigationItem.titleView = label;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mall_shoppingcar_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(myshoppingCar)];
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)initData {
    
    __unsafe_unretained UICollectionView *collectionView = self.collectionView;
    // 下拉刷新
    collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getdata];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"store/commodity" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [collectionView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPCommodity mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.datas addObjectsFromArray:arrays];
                    [collectionView reloadData];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
            // 结束刷新
            [collectionView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPShopMallController class]];
    }];
    [self.collectionView.mj_header beginRefreshing];
    self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                 titleStr:@"暂无商品"
                                                                detailStr:@""];
}

- (void)getdata {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"store/commodity" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            self.datas = [ZPCommodity mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer  resetNoMoreData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPShopMallController class]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [self getCartDot];
    }
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
    [self.collectionView.mj_header endRefreshing];
}

/* 刷新界面 */
- (void)refreshPage {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 私有
- (void)myshoppingCar {
    ZPLog(@"我的购物车");
    ZPMyShoppingCartController *myshoppingCarControl = [[ZPMyShoppingCartController alloc] init];
    [self.navigationController pushViewController:myshoppingCarControl animated:YES];
}

- (void)getCartDot {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"redDot" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSString *shoppingCartStatus = [[response objectForKey:@"data"] objectForKey:@"shoppingCartStatus"];
            if ([shoppingCartStatus isEqualToString:@"yes"]) {
                [self.navigationItem.rightBarButtonItem showBadge];
                self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-8, 8);
            } else {
                [self.navigationItem.rightBarButtonItem clearBadge];
            }
            
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPShopMallController class]];
}


#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZPShopMallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZPShopMallCell class]) forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZPOrderDetailController *orderDetail = [[ZPOrderDetailController alloc] init];
    orderDetail.commodity = self.datas[indexPath.row];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸(行距,列距)
        layout.minimumLineSpacing = ZPHeight(15);
        layout.minimumInteritemSpacing = ZPHeight(10);
        layout.sectionInset = UIEdgeInsetsMake(0, ZPWidth(15), 0, ZPWidth(15));
        // 设置cell的宽度
        //ZPWidth(165)
        layout.itemSize = CGSizeMake((kSCREEN_WIDTH-ZPWidth(15)*2-ZPWidth(10))*0.5, ZPHeight(245));
        layout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, ZPHeight(15));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB_242_242_242;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZPShopMallCell class] forCellWithReuseIdentifier:NSStringFromClass([ZPShopMallCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
