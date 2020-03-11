//
//  ZPAuthorityDoctorController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAuthorityDoctorController.h"
/* model */
#import "ZPChannelDoctorModel.h"

/* view */
#import "ZPAuthorityDoctorTitleCell.h"
#import "ZPAuthorityDoctorSubCell.h"

/* control */
#import "ZPLivingBroadcastController.h"
#import "ZPMoreLecturesController.h"

@interface ZPAuthorityDoctorController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//商品id
@property (nonatomic,copy) NSString *orderId;
@end

@implementation ZPAuthorityDoctorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = [NSString stringWithFormat:@"%@医生",self.doctorModel.doctorName];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
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
    if (indexPath.section == 0) {
        ZPAuthorityDoctorTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPAuthorityDoctorTitleCell class])];
        ZPChannelDoctorModel *model = self.doctorModel;
        cell.model = model;
        cell.imgClickBlock = ^(UIButton *btn) {
            switch (btn.tag) {
                case 10000:
                    {
                        if (model.lectureCount > 0) {
                            //有讲座的话
                            ZPLivingBroadcastController *livingBroadcastConrol = [[ZPLivingBroadcastController alloc] init];
                            livingBroadcastConrol.doctorId = self.doctorModel.ID;
                            [self.navigationController pushViewController:livingBroadcastConrol animated:YES];
                        } else {
                            //没有讲座
                            [LEEAlert alert].config
                            .LeeContent(@"该医生暂无直播哦，\n快去看看其他医生的直播吧")
                            .LeeAction(@"我知道了", ^{
                                
                            })
                            .LeeShow();
                        }
                        
                    }
                    break;
                default:
                    {
                        [LEEAlert alert].config
                        .LeeTitle(@"提醒")
                        .LeeContent(@"暂不开放")
                        .LeeAction(@"确认", ^{
                        })
                        .LeeClickBackgroundClose(YES)
                        .LeeShow();
                    }
                    break;
            }
        };
        return cell;
    }
    ZPAuthorityDoctorSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPAuthorityDoctorSubCell class])];
    ZPChannelDoctorModel *model = self.doctorModel;
    model.index = indexPath.section;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         return [tableView cellHeightForIndexPath:indexPath model:self.doctorModel keyPath:@"model" cellClass:[ZPAuthorityDoctorTitleCell class] contentViewWidth:kSCREEN_WIDTH];
    }
    return [tableView cellHeightForIndexPath:indexPath model:self.doctorModel keyPath:@"model" cellClass:[ZPAuthorityDoctorSubCell class] contentViewWidth:kSCREEN_WIDTH];
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
    return 8.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZPAuthorityDoctorTitleCell class] forCellReuseIdentifier:NSStringFromClass([ZPAuthorityDoctorTitleCell class])];
        [_tableView registerClass:[ZPAuthorityDoctorSubCell class] forCellReuseIdentifier:NSStringFromClass([ZPAuthorityDoctorSubCell class])];
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

@end
