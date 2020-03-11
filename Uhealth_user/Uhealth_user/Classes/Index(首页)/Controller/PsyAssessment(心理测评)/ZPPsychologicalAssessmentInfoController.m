//
//  ZPPsychologicalAssessmentInfoController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentInfoController.h"
#import "ZPPsychologicalAssessmentInfoTFCell.h"
#import "ZPPsychologicalAssessmentInfoSelCell.h"
#import "ZPPsychologicalAssessmentSmokeCell.h"
#import "ZPPsychologicalAssessmentSmokeNOSelCell.h"
#import "ZPPsychologicalAssessmentInfoTimeTFCell.h"
#import "ZPPsychologicalAssessmentDrinkCell.h"
#import "ZPRetireSelCell.h"
#import "ZPPsyModel.h"
#import "ZPUserModel.h"
@interface ZPPsychologicalAssessmentInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) ZPPsyModel *model;

@property (nonatomic,copy) NSString *smokeResult;
@property (nonatomic,copy) NSString *drinkResult;

//提交的数据
@property (nonatomic,strong) NSMutableDictionary *dict;
@end

@implementation ZPPsychologicalAssessmentInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    self.model = [[ZPPsyModel alloc] init];
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
//        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
//        self.model.name = model.nickName;
//        self.model.companyName = model.companyName;
//        if ([model.gender.name isEqualToString:@"男"]) {
//            self.model.genderType = ZPGenderTypeMale;
//        } else if ([model.gender.name isEqualToString:@"女"]) {
//            self.model.genderType = ZPGenderTypeMale;
//        } else {
//            self.model.genderType = ZPGenderTypeNone;
//        }
//
//        self.model.birth = model.birthday;
//    }
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smokeSelEvent:) name:kNotificationSmokeSel object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drinkSelEvent:) name:kNotificationDrinkSel object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResultEvent:) name:kNotificationSendResult object:nil];
}

- (void)initAll {
    self.title = @"身心健康评估系统";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.tableView,self.nextBtn]];
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, 50);
    
    self.nextBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50)
    .bottomSpaceToView(self.view,0);
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
    
    return 7;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        ZPPsychologicalAssessmentInfoTFCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoTFCell class])];
        cell.titleStr = @"姓名";
        cell.name = self.psyModel.name;
        cell.updateNameBlock = ^(NSString *newName) {
            weakSelf.psyModel.name = newName;
        };
         return cell;
    } else if (indexPath.row == 1) {
        ZPPsychologicalAssessmentInfoSelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoSelCell class])];
        cell.titleArray = @[@"男",@"女"];
        cell.titleStr = @"性别";
        cell.psyModel = self.psyModel;
        cell.selGenderBlock = ^(UIButton *btn) {
            if ([btn.titleLabel.text isEqualToString:@"男"]) {
                self.psyModel.gender = @"m";
            } else {
                self.psyModel.gender = @"f";
            }
        };
        return cell;
    } else if (indexPath.row == 2) {
        ZPPsychologicalAssessmentInfoTimeTFCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoTimeTFCell class])];
        cell.titleStr = @"出生日期";
        cell.time = self.psyModel.birthday;
        cell.updateTime = ^(NSString *newTime) {
            weakSelf.psyModel.birthday = newTime;
        };
        return cell;
    } else if (indexPath.row == 3) {
        ZPPsychologicalAssessmentInfoTFCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoTFCell class])];
        cell.titleStr = @"公司名称";
        cell.name = self.psyModel.company;
        return cell;
    }else if (indexPath.row == 4) {
        if (self.psyModel.isExpandRetire) {
            ZPRetireSelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPRetireSelCell class])];
            cell.titleStr = @"是否退休";
            
            cell.selBlock = ^(UIButton *btn) {
                if ([btn.titleLabel.text isEqualToString:@"是"]) {
                    weakSelf.psyModel.isExpandRetire = YES;
                    weakSelf.psyModel.retired = YES;
                } else {
                    weakSelf.psyModel.isExpandRetire = NO;
                     weakSelf.psyModel.retired = NO;
                }
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
             
                [weakSelf.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            cell.psyModel = self.psyModel;
            return cell;
        } else {
            ZPPsychologicalAssessmentInfoSelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoSelCell class])];
            cell.titleArray = @[@"是",@"否"];
            cell.titleStr = @"是否退休";
            cell.selBlock = ^(UIButton *btn) {
                if ([btn.titleLabel.text isEqualToString:@"是"]) {
                    weakSelf.psyModel.isExpandRetire = YES;
                    weakSelf.psyModel.retired = YES;
                } else {
                    weakSelf.psyModel.isExpandRetire = NO;
                    weakSelf.psyModel.retired = NO;
                }
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
              
                [weakSelf.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            cell.retireModel = self.psyModel;
            return cell;
        }
    } else if (indexPath.row == 5) {
        if (self.psyModel.isExpandSmoke) {
            ZPPsychologicalAssessmentSmokeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentSmokeCell class])];
            cell.titleStr = @"您吸烟吗?";
            return cell;
        } else {
            ZPPsychologicalAssessmentSmokeNOSelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentSmokeNOSelCell class])];
            cell.titleStr = @"您吸烟吗?";
            cell.resultStr = self.smokeResult;
            return cell;
        }
       
    }
    if (!self.psyModel.isExpandDrink) {
        ZPPsychologicalAssessmentSmokeNOSelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentSmokeNOSelCell class])];
        cell.titleStr = @"您饮酒吗?";
        cell.resultStr = self.drinkResult;
        return cell;
    }
    ZPPsychologicalAssessmentDrinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsychologicalAssessmentDrinkCell class])];
    cell.titleStr = @"您饮酒吗?";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
         if (!self.psyModel.isExpandRetire) {
              return 49.f;
         }
        return 60.f;
    }
    if (indexPath.row == 5) {
        if (!self.psyModel.isExpandSmoke) {
            return 70.f;
        }
        return 250.f;
    }
    if (indexPath.row == 6) {
        if (!self.psyModel.isExpandDrink) {
            return 70.f;
        }
        return 4*154+40-100;
    }
    
    return 49.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 5) {
        self.psyModel.isExpandSmoke = !self.psyModel.isExpandSmoke;
//        if (!self.model.isExpandSmoke) {
//            ZPPsychologicalAssessmentSmokeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////            [cell getInfo];
//        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (indexPath.row == 6) {
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        self.psyModel.isExpandDrink = !self.psyModel.isExpandDrink;
        [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (indexPath.row == 4) {
       
    }
    
}


#pragma mark - 私有方法
- (void)nextAction {
    if (!self.psyModel.name.length) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if (!self.smokeResult.length) {
        [MBProgressHUD showError:@"请选择吸烟选项"];
        return;
    }
    if (!self.drinkResult.length) {
        [MBProgressHUD showError:@"请选择饮酒选项"];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSmokeResult object:nil];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.psyModel.retired == YES) {
            if (self.psyModel.retiredAge.length== 0) {
                [MBProgressHUD showError:@"请输入退休年龄"];
                return;
            }
            if ([self.psyModel.retiredAge integerValue] == 0) {
                [MBProgressHUD showError:@"退休年龄不能为0岁"];
                return;
            }
        }
        
        NSDictionary *senddict = @{@"name":self.psyModel.name,@"gender":self.psyModel.gender,@"birthday":self.psyModel.birthday,@"retired":[NSNumber numberWithBool:self.psyModel.retired],@"retiredAge":self.psyModel.retiredAge,@"smokingPerDay":self.psyModel.smokingPerDay,@"smokingYears":self.psyModel.smokingYears,@"beerPerDay":self.psyModel.beerPerDay,@"liquorPerDay":self.psyModel.liquorPerDay,@"winePerDay":self.psyModel.winePerDay,@"foreignLiquorPerDay":self.psyModel.foreignLiquorPerDay,@"tel":self.psyModel.tel};
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"" parameters:senddict progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPPsychologicalAssessmentInfoController class]];
        
    });
    
}

- (void)smokeSelEvent:(NSNotification *)noti {
    ZPLog(@"smoke:%@",noti.object);
    NSDictionary *dict = noti.object;
    self.smokeResult = dict[@"name"];
}

- (void)drinkSelEvent:(NSNotification *)noti {
    ZPLog(@"drink:%@",noti.object);
    NSDictionary *dict = noti.object;
    self.drinkResult = dict[@"name"];
}

- (void)getResultEvent:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    ZPLog(@"%@----%@",dict[@"titleName"],dict[@"dataArray"]);
     NSString *titleName = dict[@"titleName"];
    if (self.psyModel.retired == YES) {
        if ([titleName containsString:@"退休"]) {
            self.psyModel.retiredAge = [dict[@"dataArray"] firstObject];
        }
    }
    if ([titleName containsString:@"吸"]) {
        self.psyModel.smokingPerDay = [dict[@"dataArray"] firstObject];
        self.psyModel.smokingYears = [dict[@"dataArray"] lastObject];
    }
    
    if ([titleName containsString:@"喝"]) {
        NSArray *temp = dict[@"dataArray"];
        self.psyModel.beerPerDay = temp[0];
        self.psyModel.liquorPerDay = temp[1];
        self.psyModel.winePerDay = temp[2];
        self.psyModel.foreignLiquorPerDay = temp[3];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZPPsychologicalAssessmentInfoTFCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoTFCell class])];
        [_tableView registerClass:[ZPPsychologicalAssessmentInfoSelCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoSelCell class])];
        [_tableView registerClass:[ZPPsychologicalAssessmentSmokeCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsychologicalAssessmentSmokeCell class])];
         [_tableView registerClass:[ZPPsychologicalAssessmentInfoTimeTFCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsychologicalAssessmentInfoTimeTFCell class])];
        [_tableView registerClass:[ZPPsychologicalAssessmentSmokeNOSelCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsychologicalAssessmentSmokeNOSelCell class])];
        [_tableView registerClass:[ZPPsychologicalAssessmentDrinkCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsychologicalAssessmentDrinkCell class])];
        [_tableView registerClass:[ZPRetireSelCell class] forCellReuseIdentifier:NSStringFromClass([ZPRetireSelCell class])];
    }
    return _tableView;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        _nextBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        [_nextBtn setTitle:@"填好了开始答题" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}
@end
