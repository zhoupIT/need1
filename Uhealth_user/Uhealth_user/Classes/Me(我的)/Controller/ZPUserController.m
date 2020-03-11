//
//  ZPUserController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserController.h"
/* model */
#import "ZPUserModel.h"
#import "ZPRedDot.h"
#import "ZPCabinDetailModel.h"
/* view */
#import "ZPUserHeaderView.h"
#import "ZPUserViewFlowLayout.h"
#import "ZPUserViewIconCell.h"
#import "ZPUserViewTopCell.h"
#import "ZPUserViewBottomCell.h"
/* control */
#import "ZPSettingController.h"
#import "ZPPersonalInfoController.h"
#import "ZPAboutUsController.h"
#import "ZPMyOrderMainController.h"
#import "ZPBindingCompanyController.h"
#import "ZPLoginController.h"
#import "ZPBaseNavigationController.h"
#import "ZPCabinController.h"
#import "ZPBaseTabBarViewController.h"
#import "ZPRootWebViewController.h"
#import "ZPMyStepsController.h"
/* 三方 */
#import "WZLBadgeImport.h"

static NSString *topCellId = @"topCellId";
static NSString *iconCellId = @"iconCellId";
static NSString *bottomCellId = @"bottomCellId";
@interface ZPUserController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) ZPUserHeaderView *headerView;
@property (nonatomic, weak) UICollectionView *mineView;
@property (nonatomic, strong) NSArray<NSDictionary *> *orderItems;
@property (nonatomic, strong) NSArray<NSDictionary *> *bottomItems;

@property (nonatomic,strong) NSMutableArray *redDotDatas;

@property (nonatomic,copy) NSString *companyname;
/** 是否要弹出登录页了 */
@property (nonatomic,assign) BOOL showLoginPage;
@end

@implementation ZPUserController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)getData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
       ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.companyname = model.companyName;
        self.headerView.model = model;
        WEAK_SELF(weakSelf);
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"redDot" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [weakSelf.redDotDatas removeAllObjects];
                ZPRedDot *redDot = [ZPRedDot mj_objectWithKeyValues:[response objectForKey:@"data"]];
                [weakSelf.redDotDatas addObject:redDot.nonPayMentNum];
                [weakSelf.redDotDatas addObject:redDot.nonSendNum];
                [weakSelf.redDotDatas addObject:redDot.nonReceiveNum];
                [weakSelf.redDotDatas addObject:redDot.nonEvaluatedNum];
                [UIView performWithoutAnimation:^{
                    [weakSelf.mineView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                }];
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPUserController class]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!self.showLoginPage) {
         [self.navigationController setNavigationBarHidden:false animated:animated];
    }
     [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    self.showLoginPage = NO;
    [self.navigationController setNavigationBarHidden:true animated:animated];
    [super viewWillAppear:animated];
    [self getData];
}

- (void)initAll {
    ZPUserHeaderView *headerView = [ZPUserHeaderView headerView];
    [self.view addSubview:headerView];
    
   headerView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(175)
    .rightEqualToView(self.view);
    self.headerView = headerView;
    __weak typeof(self) weakSelf = self;
    headerView.aboutBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZPSettingController *settingCtrol = [[ZPSettingController alloc] init];
        [strongSelf.navigationController pushViewController:settingCtrol animated:YES];
    };
    headerView.perosonalInfoBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZPPersonalInfoController *perInfoControl = [[ZPPersonalInfoController alloc] init];
        [strongSelf.navigationController pushViewController:perInfoControl animated:YES];
    };
    headerView.loginBlock = ^{
        weakSelf.showLoginPage = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPUserController class]) object:nil];
    };

    ZPUserViewFlowLayout *flowLayout = [[ZPUserViewFlowLayout alloc] init];
    UICollectionView *mineView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 175, kSCREEN_WIDTH, self.view.height - 175) collectionViewLayout:flowLayout];
    mineView.delegate = self;
    mineView.dataSource = self;
    mineView.backgroundColor =RGB(245, 245, 245);
    [self.view addSubview:mineView];
    mineView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.mineView = mineView;

    [mineView registerClass:[ZPUserViewTopCell class] forCellWithReuseIdentifier:topCellId];
    [mineView registerClass:[ZPUserViewIconCell class] forCellWithReuseIdentifier:iconCellId];
    [mineView registerClass:[ZPUserViewBottomCell class] forCellWithReuseIdentifier:bottomCellId];
}

- (NSArray<NSDictionary *> *)orderItems {
    return @[@{@"iconImageName" : @"me_dsk", @"iconTitle" : @"待付款"},
             @{@"iconImageName" : @"me_dfh", @"iconTitle" : @"待发货"},
             @{@"iconImageName" : @"me_dsh", @"iconTitle" : @"待收货"},
             @{@"iconImageName" : @"me_dpj", @"iconTitle" : @"待评价"}];
}

- (NSArray<NSDictionary *> *)bottomItems {
    return @[@{@"iconImageName" : @"me_myCompany_icon", @"iconTitle" : @"我的企业"},
//             @{@"iconImageName" : @"me_mySteps_icon", @"iconTitle" : @"健步走"},
             @{@"iconImageName" : @"me_healthTest_icon", @"iconTitle" : @"健康自测"},
             @{@"iconImageName" : @"me_about_icon", @"iconTitle" : @"关于我们"}];
}

#pragma mark - collectionView数据源和代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(kSCREEN_WIDTH, 44);
        }
        return CGSizeMake(kSCREEN_WIDTH / 4, 70);
    } else if (indexPath.section == 1) {
        return CGSizeMake(kSCREEN_WIDTH, 53);
    }
    return CGSizeMake(kSCREEN_WIDTH / 4, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.bottomItems.count;
    }
    return self.orderItems.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZPUserViewTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellId forIndexPath:indexPath];
            cell.isAccessoryHidden = false;
            cell.title = @"我的订单";
            cell.subTitle = @"查看更多订单";
            return cell;
        }
        ZPUserViewIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCellId forIndexPath:indexPath];
        cell.iconImageName = self.orderItems[indexPath.row - 1][@"iconImageName"];
        cell.iconTitle = self.orderItems[indexPath.row - 1][@"iconTitle"];
        if (self.redDotDatas.count) {
            cell.num = self.redDotDatas[indexPath.row-1];
        } else {
            cell.num = @"0";
        }
        return cell;
    }
    ZPUserViewBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.rightTitle = self.companyname;
        cell.iconImageName = self.bottomItems[indexPath.row][@"iconImageName"];
        cell.iconTitle = self.bottomItems[indexPath.row][@"iconTitle"];
    } else {
        cell.iconImageName = self.bottomItems[indexPath.row][@"iconImageName"];
        cell.iconTitle = self.bottomItems[indexPath.row][@"iconTitle"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZPMyOrderMainController *myOrderControl = [[ZPMyOrderMainController alloc] init];
        myOrderControl.index = indexPath.row;
        [self.navigationController pushViewController:myOrderControl animated:YES];
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
    
            if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPUserController class]) object:nil];
            } else {
                WEAK_SELF(weakSelf);
                ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                if (!model.companyName || !model.companyName.length) {
                    ZPBindingCompanyController *companyControl = [[ZPBindingCompanyController alloc] init];
                    companyControl.updateComBlock = ^{
                        if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                            ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                            weakSelf.companyname = model.companyName;
                            ZPBaseTabBarViewController *tabbar = [[ZPBaseTabBarViewController alloc] init];
                            weakSelf.view.window.rootViewController = tabbar;
                        }
                    };
                    [self.navigationController pushViewController:companyControl animated:YES];
                } else {
                    WEAK_SELF(weakSelf);
                    [MBProgressHUD showMessage:@"加载中..."];
                    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cabin/detail" parameters:nil progress:^(NSProgress *progress) {
                        
                    } success:^(NSURLSessionDataTask *task, id response) {
                        [MBProgressHUD hideHUD];
                        if ([[response objectForKey:@"code"] integerValue]  == 200) {
                            ZPCabinDetailModel *cabinDetailModel = [ZPCabinDetailModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                            ZPCabinController *cabinControl = [[ZPCabinController alloc] init];
                            cabinControl.model = cabinDetailModel;
                            cabinControl.title = cabinDetailModel.healthCabinName;
                            [weakSelf.navigationController pushViewController:cabinControl animated:YES];
                        } else if ([[response objectForKey:@"code"] integerValue]  == 2211) {
                            [LEEAlert alert].config
                            .LeeTitle(@"提醒")
                            .LeeContent([response objectForKey:@"message"])
                            .LeeAction(@"知道了", ^{
                            })
                            .LeeClickBackgroundClose(YES)
                            .LeeShow();
                        } else {
                            [MBProgressHUD showError:[response objectForKey:@"message"]];
                        }
                    } failed:^(NSURLSessionDataTask *task, NSError *error) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:error.localizedDescription];
                    } className:[ZPUserController class]];
                    
                }
            }
             
        }
            break;
//        case 1:
//        {
//            ZPMyStepsController *myStepsControl = [[ZPMyStepsController alloc] init];
//            [self.navigationController pushViewController:myStepsControl animated:YES];
//        }
//            break;
        case 1:
        {
            //健康自测
            if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
//               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPUserController class]) object:nil];
            } else {
                ZPRootWebViewController *testControl = [[ZPRootWebViewController alloc] init];
                testControl.url = uhealthTestUrl;
                testControl.titleString = @"健康自测";
                testControl.initCloseBtn = YES;
                [self.navigationController pushViewController:testControl animated:YES];
            }
        }
            break;
        case 2:
        {
            ZPAboutUsController *aboutUsControl = [[ZPAboutUsController alloc] init];
            [self.navigationController pushViewController:aboutUsControl animated:YES];
        }
              break;
        default:
        
            break;
    }
   
}

- (NSMutableArray *)redDotDatas {
    if (!_redDotDatas) {
        _redDotDatas = [NSMutableArray array];
    }
    return _redDotDatas;
}
@end
