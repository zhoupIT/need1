//
//  ZPLivingBroadcastFromBannerController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLivingBroadcastFromBannerController.h"
/* model */
#import "ZPLectureModel.h"
#import "ZPChannelDoctorModel.h"
/* view */
#import "ZPLivingBroadcastTopCell.h"
#import "ZPLivingBroadcastCell.h"
#import "ZPAllLectureHistoryCell.h"
/* controller */
#import "ZPLoginController.h"
#import "ZPNavigationController.h"
#import "ZPMoreLecturesController.h"
#import "ZPLectureWebController.h"
/* 三方 */
#import "DateTools.h"
#import "XBTimerManager.h"
@interface ZPLivingBroadcastFromBannerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ZPLectureModel *topLectureModel;
@property (nonatomic,strong) NSMutableArray *histroyData;
@property (nonatomic,strong) NSMutableArray *allData;

@property (nonatomic,strong) UIButton *enterBtn;
@property (nonatomic,strong) NSMutableArray *twoArray;
@property (nonatomic,strong) dispatch_source_t timer;
@end

@implementation ZPLivingBroadcastFromBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"直播名称";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.view addSubview:self.enterBtn];
    self.enterBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50);
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_lecture_icon"
                                                            titleStr:@""
                                                           detailStr:@""];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}

- (void)backAction {
    //    self.closeTime = YES;
    [[XBTimerManager sharedXBTimerManager] stopGcdTimer];
    //    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setButtonAttribute:(UIButton *)btn {
    NSString *lectureDate = self.topLectureModel.lectureDate;
    NSDate *lectureDateTime = [NSDate dateWithString:lectureDate formatString:@"yyyy-MM-dd HH:mm"];
    BOOL canLecture = [[NSDate date] isLaterThanOrEqualTo:lectureDateTime];
    if (canLecture) {
        //进入讲堂
        self.topLectureModel.timeout = 0;
        [self.tableView reloadData];
    } else {
        __block NSInteger timeout = [[NSDate date] secondsEarlierThan:lectureDateTime]; // 倒计时时间
        
        if (timeout!=0) {
            self.topLectureModel.timeout = timeout;
            [self.tableView reloadData];
        }
    }
}

- (void)initData {
    WEAK_SELF(weakSelf);
    if (self.ID && self.ID.length) {
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"api/advisory/channel/doctor/lecture/detail/%@",self.ID] parameters:nil progress:^(NSProgress *progress) {

        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPLog(@"%@",response);
                weakSelf.topLectureModel = [ZPLectureModel mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"detail"]];
                weakSelf.title = weakSelf.topLectureModel.lectureName;
                [weakSelf setButtonAttribute:weakSelf.enterBtn];
                if (weakSelf.topLectureModel.ID.length== 0) {
                    weakSelf.enterBtn.hidden = YES;
                }
                weakSelf.topLectureModel.isBannerEnter = YES;
                [weakSelf.tableView reloadData];
            } else {

                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
             [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPLivingBroadcastFromBannerController class]];
    }
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
    
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
        ZPLivingBroadcastTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPLivingBroadcastTopCell class])];
        self.topLectureModel.isBannerEnter = YES;
        cell.model = self.topLectureModel;
        cell.enterLectureBlock = ^{
            [weakSelf enterLectureAction];
        };
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
        return [tableView cellHeightForIndexPath:indexPath model:self.topLectureModel keyPath:@"model" cellClass:[ZPLivingBroadcastTopCell class] contentViewWidth:kSCREEN_WIDTH];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - private
- (void)enterLectureAction {
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
            
        } failed:^(NSError *error) {
            
        } withClassName:NSStringFromClass([ZPLivingBroadcastFromBannerController class])];
        NSString *token = [kUSER_DEFAULT objectForKey:@"lectureToken"];
        NSString *baseString = [Utils base64StringFromText:token];
        ZPLectureWebController *webControl = [[ZPLectureWebController alloc] init];
        webControl.titleString = self.topLectureModel.lectureName;
        webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@&token=%@",ZPBaseUrl,self.topLectureModel.roomid,baseString];
        ZPLog(@"聊天室的地址:%@",webControl.url);
        [self.navigationController pushViewController:webControl animated:YES];
    } else {
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
            
        } failed:^(NSError *error) {
            
        } withClassName:NSStringFromClass([ZPLivingBroadcastFromBannerController class])];
        ZPLectureWebController *webControl = [[ZPLectureWebController alloc] init];
        webControl.titleString = self.topLectureModel.lectureName;
        webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@",ZPBaseUrl,self.topLectureModel.roomid];
        [self.navigationController pushViewController:webControl animated:YES];
    }
}

- (void)enterAction {
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
            
        } failed:^(NSError *error) {
            
        } withClassName:NSStringFromClass([ZPLivingBroadcastFromBannerController class])];
        NSString *token = [kUSER_DEFAULT objectForKey:@"lectureToken"];
        NSString *baseString = [Utils base64StringFromText:token];
        ZPLectureWebController *webControl = [[ZPLectureWebController alloc] init];
        webControl.titleString = self.topLectureModel.lectureName;
        webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@&token=%@",ZPBaseUrl,self.topLectureModel.roomid,baseString];
        ZPLog(@"聊天室的地址:%@",webControl.url);
        [self.navigationController pushViewController:webControl animated:YES];
    } else {
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
            
        } failed:^(NSError *error) {
            
        } withClassName:NSStringFromClass([ZPLivingBroadcastFromBannerController class])];
        ZPLectureWebController *webControl = [[ZPLectureWebController alloc] init];
        webControl.titleString = self.topLectureModel.lectureName;
        webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@",ZPBaseUrl,self.topLectureModel.roomid];
        [self.navigationController pushViewController:webControl animated:YES];
    }
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSMutableArray *)histroyData {
    if (!_histroyData) {
        _histroyData = [NSMutableArray array];
    }
    return _histroyData;
}

- (NSMutableArray *)allData {
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZPLivingBroadcastTopCell class] forCellReuseIdentifier:NSStringFromClass([ZPLivingBroadcastTopCell class])];
        [_tableView registerClass:[ZPLivingBroadcastCell class] forCellReuseIdentifier:NSStringFromClass([ZPLivingBroadcastCell class])];
        [_tableView registerClass:[ZPAllLectureHistoryCell class] forCellReuseIdentifier:NSStringFromClass([ZPAllLectureHistoryCell class])];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, ZPHeight(60))];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"lecture_foot_icon"];
        [view addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(view)
        .heightIs(ZPHeight(23*0.5))
        .widthIs(ZPWidth(637*0.5))
        .centerXEqualToView(view);
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton new];
        [_enterBtn setTitle:@"进入讲堂" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn setBackgroundColor:ZPMyOrderDetailValueFontColor];
        _enterBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:16];
        _enterBtn.titleLabel.numberOfLines = 2;
        _enterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (NSMutableArray *)twoArray {
    if (!_twoArray) {
        _twoArray = [NSMutableArray array];
        [_twoArray addObject:@1];
        [_twoArray addObject:@1];
    }
    return _twoArray;
}

- (ZPLectureModel *)topLectureModel {
    if (!_topLectureModel) {
        _topLectureModel = [[ZPLectureModel alloc] init];
        _topLectureModel.isBannerEnter = YES;
        _topLectureModel.lectureSpeaker = @"";
        _topLectureModel.lectureDoctorIntroduction = @"";
        _topLectureModel.lectureIntroduction = @"";
    }
    return _topLectureModel;
}
@end
