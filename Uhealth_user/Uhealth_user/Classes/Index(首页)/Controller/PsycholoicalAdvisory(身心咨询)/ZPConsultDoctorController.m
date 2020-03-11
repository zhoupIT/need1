//
//  ZPConsultDoctorController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPConsultDoctorController.h"
/* model */
#import "ZPConsultDoctorModel.h"
/* cell */
#import "ZPConsultDoctorCell.h"

/* other */
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface ZPConsultDoctorController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic, strong) CTCallCenter *callCenter;
@end

@implementation ZPConsultDoctorController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)initAll {
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.title = self.consultDoctorType==ZPConsultDoctorTypeConsulting?@"心理咨询":@"健康咨询";
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无医生"
                                                           detailStr:@""];
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            ZPLog(@"挂断电话Call has been disconnected");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            ZPLog(@"电话通了Call has just been connected");
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            ZPLog(@"来电话了Call is incoming");
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            ZPLog(@"正在拨出电话call is dialing");
            if (self.consultDoctorType == ZPConsultDoctorTypeConsulting) {
                //心理咨询界面
                [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/psycholoical/touch/log" andHTTPMethod:@"PUT" andDict:@{} success:^(NSDictionary *response) {
                    ZPLog(@"心理咨询埋点成功:%@",response);
                } failed:^(NSError *error) {
                    ZPLog(@"心理咨询埋点失败:%@",error);
                } withClassName:NSStringFromClass([ZPConsultDoctorController class])];
            }
        }
        else
        {
            ZPLog(@"什么没做Nothing is done");
        }
    };
   
}

- (void)initData {
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/doctor" parameters:@{@"doctorType":self.consultDoctorType == ZPConsultDoctorTypeConsulting?@"PSYCHOLOGIST":@"PHYSIOLOGY_DOCTOR"} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.datas = [ZPConsultDoctorModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPConsultDoctorController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/doctor" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"doctorType":self.consultDoctorType == ZPConsultDoctorTypeConsulting?@"PSYCHOLOGIST":@"PHYSIOLOGY_DOCTOR"} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPConsultDoctorModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                    
                } else {
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
        } className:[ZPConsultDoctorController class]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPConsultDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPConsultDoctorCell class]) forIndexPath:indexPath];
    
    ZPConsultDoctorModel *model = self.datas[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.consultDoctorType = self.consultDoctorType;
    cell.model = model;
    cell.consultBlock = ^{
        if (self.consultDoctorType == ZPConsultDoctorTypeConsulting) {
            //调用接口判断次数是否够用
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"consult/remain" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    if ([[response objectForKey:@"data"] integerValue] != 0) {
                        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",hotLineNumber];
                        UIWebView * callWebview = [[UIWebView alloc] init];
                        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                        [weakSelf.view addSubview:callWebview];
                    } else {
                        [LEEAlert alert].config
                        .LeeTitle(@"提醒")
                        .LeeContent([response objectForKey:@"message"])
                        .LeeAction(@"确认", ^{
                        })
                        .LeeClickBackgroundClose(YES)
                        .LeeShow();
                    }
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                
            } className:[ZPConsultDoctorController class]];
        } else {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",hotLineNumber];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [weakSelf.view addSubview:callWebview];
        }
    };
    cell.modalInfoBlock = ^(ZPConsultDoctorModel *model) {
        __weak typeof(self) weakSelf = self;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 115, 16)];
        titleLabel.textColor = RGB_74_74_74;
        titleLabel.text = self.consultDoctorType==ZPConsultDoctorTypeConsulting?@"咨询师介绍":@"医生介绍";
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 115, 13)];
        nameLabel.textColor = RGB_74_74_74;
        nameLabel.text = model.name;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        iconView.layer.cornerRadius = 30;
        iconView.layer.masksToBounds = YES;
        [iconView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"doctor_male"]];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240,  [weakSelf getHeightLineWithString:model.doctorType.text withWidth:240 withFont:[UIFont systemFontOfSize:14]])];
        contentLabel.textColor = RGB_78_178_255;
        contentLabel.text = model.doctorType.text;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
        
        
        
        NSString *contentSubStr = [NSString stringWithFormat:@"%@、%@",model.doctorTitle,model.expertiseField];
        if (!model.doctorTitle.length && model.expertiseField.length) {
            contentSubStr = model.expertiseField;
        } else if (model.doctorTitle.length && !model.expertiseField.length) {
            contentSubStr = model.doctorTitle;
        } else if (!model.doctorTitle.length && !model.expertiseField.length) {
            contentSubStr = @"";
        }
        
        UILabel *contentsubLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240,  [weakSelf getHeightLineWithString:contentSubStr withWidth:240 withFont:[UIFont systemFontOfSize:14]])];
        contentsubLabel.textColor = RGB_78_178_255;
        contentsubLabel.text = contentSubStr;
        contentsubLabel.font = [UIFont systemFontOfSize:14];
        contentsubLabel.textAlignment = NSTextAlignmentCenter;
        contentsubLabel.numberOfLines = 0;
        [contentsubLabel sizeToFit];
        
        UILabel *introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240,  [weakSelf getHeightLineWithString:model.introduction withWidth:240 withFont:[UIFont systemFontOfSize:12]])];
        introductionLabel.textColor = RGB_74_74_74;
        introductionLabel.text = model.introduction;
        introductionLabel.font = [UIFont systemFontOfSize:12];
        introductionLabel.numberOfLines = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:introductionLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [introductionLabel.text length])];
        introductionLabel.attributedText = attributedString;
        [introductionLabel sizeToFit];
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 115, 12)];
        subtitleLabel.textColor = RGB_74_74_74;
        subtitleLabel.text = @"擅长方向:";
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *subintroductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240,  [weakSelf getHeightLineWithString:model.researchDirection withWidth:240 withFont:[UIFont systemFontOfSize:12]])];
        subintroductionLabel.textColor = RGB_74_74_74;
        subintroductionLabel.text = model.researchDirection;
        subintroductionLabel.font = [UIFont systemFontOfSize:12];
        subintroductionLabel.numberOfLines = 0;
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:subintroductionLabel.text];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subintroductionLabel.text length])];
        if (model.researchDirectionControlArray.count) {
            for (NSArray *tempArray in model.researchDirectionControlArray) {
                ZPLog(@"%@",tempArray);
                [attributedString1 addAttribute:NSForegroundColorAttributeName value:RGB(78,178,255) range:NSMakeRange([tempArray.firstObject integerValue], [tempArray.lastObject integerValue])];
            }
        }
        subintroductionLabel.attributedText = attributedString1;
        
        [subintroductionLabel sizeToFit];
        
        [LEEAlert alert].config
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = titleLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = iconView;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(15, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = nameLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(10, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = contentLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(15, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = contentsubLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(15, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = introductionLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(15, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = subtitleLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(21, 0, 0, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = subintroductionLabel;
            custom.positionType = LEECustomViewPositionTypeCenter;
        })
        .LeeItemInsets(UIEdgeInsetsMake(15, 0, 0, 0))
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
        .LeeClickBackgroundClose(YES)
        .LeeShow();
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}

#pragma mark - -懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB_242_242_242;
        [_tableView registerClass:[ZPConsultDoctorCell class] forCellReuseIdentifier:NSStringFromClass([ZPConsultDoctorCell class])];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
