//
//  ZPIndexViewController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPIndexViewController.h"
/* model */
#import "ZPCommonBannerModel.h"
#import "ZPHealthNewsModel.h"
#import "ZPHealthWindModel.h"
#import "ZPHealthDynamicModel.h"
#import "ZPAdvisoryChannelModel.h"
#import "ZPCommodity.h"
#import "ZPCabinDetailModel.h"
#import "ZPPsyAssessmentModel.h"

/* view */
#import "ZPIndexCenterCell.h"
#import "ZPIndexFunctionCell.h"
#import "ZPIndexMarqueeCell.h"
#import "ZPHealthWindCell.h"
#import "ZPHealthWindOneImageCell.h"
#import "ZPIndexCycleHeadViewCell.h"

/* control */
#import "ZPRootWebViewController.h"
#import "ZPRootArticleWebViewController.h"
#import "ZPGreenPathController.h"
#import "DiseaseMatchViewController.h"
#import "ZPAdvisoryController.h"
#import "ZPMoreLecturesController.h"
#import "ZPAuthorityCenterController.h"
#import "ZPLivingBroadcastFromBannerController.h"
#import "ZPOrderDetailController.h"
#import "ZPHealthNewsMainController.h"
#import "ZPCabinController.h"
#import "ZPPsychologicalAssessmentController.h"
#import "ZPMyStepsController.h"
/* 第三方 */
#import "WZLBadgeImport.h"

@interface ZPIndexViewController ()<UITableViewDelegate,UITableViewDataSource>
/* view */
@property (nonatomic,strong) UITableView *tableView;
/* 标题label */
@property (nonatomic,strong) UILabel *titleNavLabel;

/* 滚动距离 */
//@property (nonatomic, assign) CGFloat scrollOffsetY;

/* 数据banner数据 */
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *bannerModelArray;
/* 优医动态数据 */
@property (nonatomic,strong) NSMutableArray *dynamicDatas;
/* 优医动态资讯数据 */
@property (nonatomic,strong) NSMutableArray *newsDatas;
@end

@implementation ZPIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/* 初始化界面UI */
- (void)initAll {
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(IS_IPhoneX?-88:-64, 0, 0, 0));
    self.navigationItem.titleView = self.titleNavLabel;
}

/* 初始化数据 */
- (void)initData {
    //获取app版本号
    [self getAppVersion];
    //获取banner数据
    [self getHeadBanner];
    //获取健康文章数据
    [self getHealthDynamic];
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getHotHealthInformation:YES];
    }];
    //通知监听RegistrationID
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadJPushID) name:kJPFNetworkDidLoginNotification object:nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        if (![model.welcomeMessage isKindOfClass:[NSNull class]]) {
            if (model.companyName.length  &&  model.welcomeMessage.length && (![kUSER_DEFAULT objectForKey:model.ID] || [kUSER_DEFAULT objectForKey:model.ID] == NO)) {
                //弹出 欢迎窗
                [self popImgWithUrl:model.welcomeMessage];
                //保存个人id为Yes 说明弹过了
                [kUSER_DEFAULT setBool:YES forKey:model.ID];
                [kUSER_DEFAULT synchronize];
            }
        }
        if (model.companyName && model.companyName.length) {
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cabin/detail" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    ZPCabinDetailModel *cabinDetailModel = [ZPCabinDetailModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                    ZPCabinController *cabinControl = [[ZPCabinController alloc] init];
                    cabinControl.model = cabinDetailModel;
                    cabinControl.title = cabinDetailModel.healthCabinName;
                    [weakSelf.navigationController pushViewController:cabinControl animated:YES];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPIndexViewController class]];
        }
    }
}

- (void)wxloginSuccess {
    [self initData];
}

- (void)refreshPage {
    [self initData];
}

#pragma mark - -私有方法
/* 获取首页banner数据 */
- (void)getHeadBanner {
    ZPLog(@"---------->开始获取首页banner数据");
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"banner" parameters:@{@"position":@"HEAD",@"launchPlatform":@"IOS"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        ZPLog(@"首页banner数据:%@",response);
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [weakSelf.bannerArray removeAllObjects];
            weakSelf.bannerModelArray = [ZPCommonBannerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            for (ZPCommonBannerModel *model in weakSelf.bannerModelArray) {
                [weakSelf.bannerArray addObject:model.banner];
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        ZPLog(@"获取首页banner数据失败:%@",error);
    } className:[ZPIndexViewController class]];
}

/* 获取优医动态 标题 */
- (void)getHealthDynamic {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"dynamic" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.dynamicDatas = [ZPHealthDynamicModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPIndexViewController class]];
}

/* 获取优医动态 资讯列表 */
- (void)getHotHealthInformation:(BOOL)isFootRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthDirection/list" parameters:@{@"offset":[NSNumber numberWithInteger:self.newsDatas.count],@"position":@"HOMEPAGE"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        // 结束刷新
        if (isFootRefresh) {
            [tableView.mj_footer endRefreshing];
        }
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSArray *arrays = [ZPHealthWindModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            if (!arrays.count) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.newsDatas addObjectsFromArray:arrays];
                [tableView reloadData];
            }
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        if (isFootRefresh) {
            [tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPIndexViewController class]];
}

/* 弹出欢迎图片 */
- (void)popImgWithUrl:(NSString *)urlStr {
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IS_IPHONE5?280:ZPWidth(280), 381)];
    
    //435
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, IS_IPHONE5?276:ZPWidth(276), 350)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [temp addSubview:iconView];
    
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 31, 31)];
    [closeBtn setImage:[UIImage imageNamed:@"close_pop_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [temp addSubview:closeBtn];
    
    closeBtn.sd_layout
    .centerXEqualToView(iconView);
    
    [LEEAlert alert].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = temp;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeBackGroundColor([UIColor clearColor])
    .LeeHeaderColor([UIColor clearColor])
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            animatingBlock(); //调用动画中Block
            
        } completion:^(BOOL finished) {
            
            animatedBlock(); //调用动画结束Block
        }];
        
    })
    .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            animatingBlock();
            
        } completion:^(BOOL finished) {
            
            animatedBlock();
        }];
        
    })
    .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type) {
        if (IS_IPHONE5) {
            return 280;
        }
        return ZPWidth(280);
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}


/* 获取版本号 判断app是否需要更新 */
- (void)getAppVersion {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"version" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSString *data = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"versionCode"]];
            ZPLog(@"服务器版本号:%@  app版本号:%@ ",data,PRODUCT_VERSION);
            NSString *pV = [NSString stringWithFormat:@"%@",PRODUCT_VERSION];
            if ([pV compare:data options:NSNumericSearch] == NSOrderedAscending) {
                [LEEAlert alert].config
                .LeeTitle(@"提醒")
                .LeeContent(@"App有新的版本可以下载,前去下载")
                .LeeCancelAction(@"取消", ^{
                    
                })
                .LeeAction(@"确认", ^{
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AppStoreUrl]];
                    [[UIApplication sharedApplication] openURL:url];
                })
                .LeeClickBackgroundClose(YES)
                .LeeShow();
            }
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPIndexViewController class]];
}

/* 获取未读消息数量 */
- (void)getUnreadMessage {
    __weak typeof(self) weakSelf = self;
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/message" parameters:@{@"messageStatus":@"UNREAD"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSInteger num = [[[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"] integerValue];
            //设置未读数量
//            [weakSelf.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPIndexViewController class]];
}

/* 上传jpush的registrationID */
- (void)uploadJPushID {
    WEAK_SELF(weakSelf);
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        ZPLog(@"------>registrationID: %@",[JPUSHService registrationID]);
        //上传极光registrationID给服务器
        [weakSelf uploadRegistrationID];
    }];
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"customer/tags" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSSet *set = [NSSet setWithArray:[response objectForKey:@"data"]];
            // 0 为成功
            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                if (!iResCode) {
                    ZPLog(@"设置标签%@成功",[response objectForKey:@"data"]);
                } else {
                    ZPLog(@"设置标签%@失败",[response objectForKey:@"data"]);
                }
            } seq:0];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPIndexViewController class]];
}

- (void)uploadRegistrationID {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH] && [JPUSHService registrationID]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/message/jpush/information",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        NSDictionary *msg = @{@"registrationId":[JPUSHService registrationID]};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            ZPLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        ZPLog(@"上传极光registrationID:%@给服务器成功",[JPUSHService registrationID]);
                        [kUSER_DEFAULT setValue:[JPUSHService registrationID] forKey:@"registrationID"];
                        [kUSER_DEFAULT synchronize];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 401){
                        //未登录页面
                        [self logout];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 402){
                        //清除登录信息
                        [self clearLoginInfo];
                        [LEEAlert alert].config
                        .LeeContent([dict objectForKey:@"message"])
                        .LeeAction(@"确认", ^{
//                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPIndexViewController class]) object:nil];
                        })
                        .LeeShow();
                        
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
        }] resume];
    }
}

//退出登录
- (void)logout {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPIndexViewController class]) object:nil];
}

//清除登录信息
- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
}

#pragma mark - -跳转页面
//跳转->消息列表
- (void)chatInfoList {
//    SessionListViewController *chatList = [[SessionListViewController alloc] init];
//    [self.navigationController pushViewController:chatList animated:YES];
}

//跳转-banner点击跳转处理
- (void)handleBannerClick:(NSInteger)index {
    /*
     bannerType的类型
     UHEALTH_DIRECTION     健康风向
     UHEALTH_INFORMATION   健康资讯
     COMMONDITY            商品
     LINK                  链接
     null                  单纯图片
     */
    
    ZPCommonBannerModel *model = self.bannerModelArray[index];
    if ([model.bannerType.name isEqualToString:@"UHEALTH_INFORMATION"]) {
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
        //跳转链接
        ZPRootWebViewController *htmlWebControl = [[ZPRootWebViewController alloc]init];
        htmlWebControl.url = model.bannerAim;
        htmlWebControl.titleString = model.bannerName;
        htmlWebControl.initCloseBtn = YES;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LONG_IMAGE"]) {
        //长图
        ZPRootWebViewController *htmlWebControl = [[ZPRootWebViewController alloc]init];
        htmlWebControl.url = urlLongImage(model.bannerAim);
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LECTURE_ROOM"]) {
        ZPLivingBroadcastFromBannerController *livinglectureControl = [[ZPLivingBroadcastFromBannerController alloc] init];
        livinglectureControl.ID = model.bannerAim;
        [self.navigationController pushViewController:livinglectureControl animated:YES];
    }
    
}


//跳转->功能点击处理
- (void)functionDidClickAction:(NSInteger)tag {
    
    switch (tag) {
        case 10001:
        {
            //绿色通道
            ZPGreenPathController *greenPathControl = [[ZPGreenPathController alloc] init];
            [self.navigationController pushViewController:greenPathControl animated:YES];
        }
            break;
        case 10002:
        {
            //症状自查
            [MBProgressHUD showMessage:@"加载中..."];
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"selftest" parameters:nil progress:^(NSProgress *progress) {

            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    NSBundle *bundle = [NSBundle bundleForClass:[DiseaseMatchViewController class]];
                    DiseaseMatchViewController *vc = [[DiseaseMatchViewController alloc] initWithNibName:@"DiseaseMatchViewController" bundle:bundle];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPIndexViewController class]];
        }
            break;
        case 10003:
        {
            //身心咨询
            ZPAdvisoryController *consultControl = [[ZPAdvisoryController alloc] init];
            [self.navigationController pushViewController:consultControl animated:YES];
        }
            break;
        case 10004:
        {
            //在线讲堂
            /*
            ZPMoreLecturesController *alllectureControl = [[ZPMoreLecturesController alloc] init];
            alllectureControl.allLecture = YES;
            [self.navigationController pushViewController:alllectureControl animated:YES];
            */
            
            ZPMyStepsController *myStepsControl = [[ZPMyStepsController alloc] init];
            [self.navigationController pushViewController:myStepsControl animated:YES];
            //心理测评
            /*
            [MBProgressHUD showMessage:@"加载中..."];
            WEAK_SELF(weakSelf);
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"psychologicalAssessment/register" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    ZPPsyAssessmentModel *psyModel = [ZPPsyAssessmentModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                    if (psyModel.infoFilled) {
                        //信息已填
                        ZPRootWebViewController *webViewController = [[ZPRootWebViewController alloc] init];
                        webViewController.titleString = @"身心健康评估";
                        webViewController.url = psyModel.ticketEntry;
                        webViewController.initCloseBtn = YES;
                        webViewController.infoFilled = YES;
                        webViewController.isPsyAssessPage = YES;
                        [weakSelf.navigationController pushViewController:webViewController animated:YES];
                    } else {
                        ZPPsychologicalAssessmentController *psyControl = [[ZPPsychologicalAssessmentController alloc] init];
                        psyControl.psyModel = psyModel;
                        [weakSelf.navigationController pushViewController:psyControl animated:YES];
                    }
                } else {
                    
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[ZPIndexViewController class]];
             */
        }
            break;
        case 10005:
        {
            //健康资讯
            ZPHealthNewsMainController *healthNewsMainControl = [[ZPHealthNewsMainController alloc] init];
            [self.navigationController pushViewController:healthNewsMainControl animated:YES];
        }
            break;
        default:
            break;
    }
    
}

//跳转->微生态中心
- (void)didClickAction {
    //微生态中心
    ZPAuthorityCenterController *authorityCenterControl = [[ZPAuthorityCenterController alloc] init];
    ZPAdvisoryChannelModel *model = [[ZPAdvisoryChannelModel alloc] init];;
    model.ID = @"1";
    ZPCommonEnumType *type = [[ZPCommonEnumType alloc] init];
    type.text = @"微生态中心";
    model.channelType = type;
    authorityCenterControl.channelModel = model;
    [self.navigationController pushViewController:authorityCenterControl animated:YES];
}

//跳转->优医动态
- (void)handleDynamicArticle:(NSInteger)index {
    ZPHealthDynamicModel *model = self.dynamicDatas[index];
    if ([model.articleSort.name isEqualToString:@"HEALTH_DIRECTION"]) {
        //风向
        ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
        webView.url = windArticleUrl(model.articleId);
        webView.titleString = @"优医健康";
        ZPHealthWindModel *windModel =  [[ZPHealthWindModel alloc] init];
        windModel.directionId = model.articleId;;
        webView.healthWindModel = windModel;
        webView.bannerAim = model.articleId;
        //设置文章类型
        webView.articelType = ZPArticleTypeWind;
        //设置入口
        webView.enterStatusType = ZPArticleEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([model.articleSort.name isEqualToString:@"HEALTH_INFORMATION"]) {
        //资讯
        ZPRootArticleWebViewController *webView = [[ZPRootArticleWebViewController alloc] init];
        webView.url = newsArticleUrl(model.articleId);
        webView.titleString = @"健康资讯";
        ZPHealthNewsModel *healthNewsModel = [[ZPHealthNewsModel alloc] init];
        healthNewsModel.informationId = model.articleId;;
        webView.healthNewsModel = healthNewsModel;
        webView.bannerAim = model.articleId;
        //设置文章类型
        webView.articelType = ZPArticleTypeNews;
        //设置入口
        webView.enterStatusType = ZPArticleEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

//关闭弹窗
- (void)closePop {
    [LEEAlert closeWithCompletionBlock:nil];
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 2) {
        return self.newsDatas.count+1;
    }
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZPIndexCycleHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPIndexCycleHeadViewCell class])];
            cell.data = self.bannerArray;
            cell.bannerImgClickBlock = ^(NSInteger index) {
                //首页banner点击处理
                [weakSelf handleBannerClick:index];
            };
            return cell;
        }
        ZPIndexFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPIndexFunctionCell class])];
        cell.didClickBlock = ^(NSInteger tag) {
            //功能 点击处理
            [weakSelf functionDidClickAction:tag];
        };
        return cell;
    } else if (indexPath.section == 1) {
        ZPIndexCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPIndexCenterCell class])];
        cell.didClickBlock = ^{
            //微生态中心 跳转处理
            [weakSelf didClickAction];
        };
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            ZPIndexMarqueeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPIndexMarqueeCell class])];
            cell.data = self.dynamicDatas;
            cell.didClickBlock = ^(NSInteger index) {
                //优医 跳转文章
                [weakSelf handleDynamicArticle:index];
            };
            return cell;
        }
    }
    ZPHealthWindModel *model = self.newsDatas[indexPath.row-1];
    if (model.titleImgList.count == 1) {
        ZPHealthWindOneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPHealthWindOneImageCell class])];
        cell.model = model;
        return cell;
    }
    ZPHealthWindCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPHealthWindCell class])];
    cell.model = model;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return ZPHeight(180);
        }
        return ZPHeight(106);
    } else if (indexPath.section == 1) {
        return ZPHeight(170);
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return ZPHeight(40);
        }
    }
    ZPHealthWindModel *model = self.newsDatas[indexPath.row-1];
    if (model.titleImgList.count==1) {
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ZPHealthWindOneImageCell class] contentViewWidth:kSCREEN_WIDTH];
    }

    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ZPHealthWindCell class] contentViewWidth:kSCREEN_WIDTH];
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
    return 10.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row >0) {
        ZPHealthWindModel *model = self.newsDatas[indexPath.row-1];
        ZPRootArticleWebViewController *windWebViewControl = [[ZPRootArticleWebViewController alloc] init];
        windWebViewControl.articelType = ZPArticleTypeWind;
        windWebViewControl.url = windArticleUrl(model.directionId);
        windWebViewControl.healthWindModel = model;
        windWebViewControl.titleString = @"优医健康";
        [self.navigationController pushViewController:windWebViewControl animated:YES];
    }
}

#pragma mark - -界面加载时机
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //改变导航栏的颜色
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    [self setNavItem];
    //获取优医动态
    [self getHotHealthInformation:NO];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        //获取未读消息数量
        [self getUnreadMessage];
        if (![kUSER_DEFAULT objectForKey:@"registrationID"]) {
            //上传jpush的regId
//            [self uploadJPushID];
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //改变导航栏的颜色
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    [self setNavItem];
}


#pragma mark - 导航栏上的item设置
/* 当scrollView滚动的时候，不停调用 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.scrollOffsetY = offsetY;
    [self changeNavigationBarStyleWhenScroll:offsetY];
    [self setNavItem];
}

/* 设置导航栏上的item */
- (void)setNavItem {
    if (self.navigationBarAlpha < 0.3) {
        self.titleNavLabel.text = @"";
    } else {
        self.titleNavLabel.text = @"小优健康";
    }
//    if (self.navigationBarAlpha >= 1) {
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem zp_barButtonItemWithTarget:self action:@selector(chatInfoList) icon:@"common_noti_icon" highlighticon:@"common_noti_icon" backgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
//    } else if (self.navigationBarAlpha >= 0) {
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem zp_barButtonItemWithTarget:self action:@selector(chatInfoList) icon:@"common_noti_icon" highlighticon:@"common_noti_icon" backgroundImage:self.itemBackgroundImage];
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
}

#pragma mark - 懒加载
- (UILabel *)titleNavLabel {
    if (!_titleNavLabel) {
        _titleNavLabel = [UILabel new];
        _titleNavLabel.text = @"小优健康";
        _titleNavLabel.textColor = [UIColor whiteColor];
        _titleNavLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(17)];
    }
    return _titleNavLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB_242_242_242;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPIndexCenterCell class] forCellReuseIdentifier:NSStringFromClass([ZPIndexCenterCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZPIndexFunctionCell class] forCellReuseIdentifier:NSStringFromClass([ZPIndexFunctionCell class])];
        [_tableView registerClass:[ZPIndexMarqueeCell class] forCellReuseIdentifier:NSStringFromClass([ZPIndexMarqueeCell class])];
        [_tableView registerClass:[ZPHealthWindCell class] forCellReuseIdentifier:NSStringFromClass([ZPHealthWindCell class])];
        [_tableView registerClass:[ZPHealthWindOneImageCell class] forCellReuseIdentifier:NSStringFromClass([ZPHealthWindOneImageCell class])];
        [_tableView registerClass:[ZPIndexCycleHeadViewCell class] forCellReuseIdentifier:NSStringFromClass([ZPIndexCycleHeadViewCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)bannerModelArray {
    if (!_bannerModelArray) {
        _bannerModelArray = [NSMutableArray array];
    }
    return _bannerModelArray;
}

- (NSMutableArray *)newsDatas {
    if (!_newsDatas) {
        _newsDatas = [NSMutableArray array];
    }
    return _newsDatas;
}

- (NSMutableArray *)dynamicDatas {
    if (!_dynamicDatas) {
        _dynamicDatas = [NSMutableArray array];
    }
    return _dynamicDatas;
}
@end
