//
//  DiseaseResultListViewController.m
//  YYK
//
//  Created by xiexianyu on 4/27/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseResultListViewController.h"
// next page
#import "DiseaseInfoViewController.h"
#import "ZPConsultDoctorController.h"
#import "ZPReservationServiceController.h"
#import "ZPCabinController.h"
#import "ZPBindingCompanyController.h"
// cell
#import "DiseaseResultSegmentTipCell.h"
#import "DiseaseProbabilityCell.h"
//#import "UHRecommendCell.h"

#import "ZPCabinDetailModel.h"
#import "ZPUserModel.h"
@interface DiseaseResultListViewController ()
@property (nonatomic, strong) NSArray *diseaseInfos;
@property (nonatomic,strong) NSArray *recommendDatas;
@end

@implementation DiseaseResultListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"自查结果";
    
    [self addTextRightItemWithTitle:@"重查"];
    
    // register cell
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *nibName = @"DiseaseResultSegmentTipCell";
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:nibName];
    nibName = @"DiseaseProbabilityCell";
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:nibName];
    nibName = @"UHRecommendCell";
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:nibName];
    

    [self fetchDiseaseResult];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

// override
- (void)handleTextBarButtonItem:(UIBarButtonItem*)sender
{
    // back to disease match vc
    NSArray *vcList = self.navigationController.viewControllers;
    if ([vcList count] >= 2) {
        NSRange range = NSMakeRange(0, 2);
        NSArray *top2 = [vcList subarrayWithRange:range];
        [self.navigationController setViewControllers:top2 animated:YES];
    } //if
    
}

- (void)fetchDiseaseResult
{
    // build params
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:8];
    [params setValue:_symptomAllIDText forKey:@"idarr"];
    if (_isFemale) {
        [params setValue:@"性别_女" forKey:@"sex"];
    }
    else {
        [params setValue:@"性别_男" forKey:@"sex"];
    }
    [params setValue:[_ageInfo valueForKey:@"param"] forKey:@"age"];
    [params setValue:[_workInfo valueForKey:@"id"] forKey:@"jobid"];
    
    // request
    [SVProgressHUD show];
    NSURLRequest *request = [QISDataManager requestDiagnosisResultWithParameters:params];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error != nil) {
            NSString *tip = [QISDataManager netTipWithError:error];
            [SVProgressHUD showErrorWithStatus:tip];
            return ;
        }
        
        // parse json
        NSError* parseError = nil;
        id jsonInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
        
        if (parseError) {
            [SVProgressHUD showErrorWithStatus:kQISDataJsonError];
            return ;
        }
        
        NSString *statusTip = [QISDataManager statusErrorTipWithResponseInfo:jsonInfo];
        if (statusTip != nil) {
            // bad data
            [SVProgressHUD showErrorWithStatus:statusTip];
        }
        
        /**
         DList:可能疾病列表，
         SList:次要症状，
         CList:冲突症状(比如选的男性，症状却选择妇科病症状)
         RelatedDept:推荐就诊科室
         */
        // good data
        NSDictionary *resultInfo = [jsonInfo valueForKey:@"results"];
        if ([resultInfo isKindOfClass:[NSDictionary class]] && resultInfo.count > 0) {
            NSArray *diseaseList = [resultInfo valueForKey:@"DList"];
            if ([diseaseList isKindOfClass:[NSArray class]]) {
                // OK, adapter data to show
                self.diseaseInfos = diseaseList;
                [self buildResultList];
            }
        }
    }];
    
    [dataTask resume];
}

- (void)buildResultList
{
    // tip of disease
    NSDictionary *diseaseTipInfo = @{@"Name":@"可能的疾病", @"icon":@"tip_probability", @"type":@"tip"};
    [self.items removeAllObjects];
    [self.items addObject:diseaseTipInfo];
    // disease list
    [self.items addObjectsFromArray:_diseaseInfos];
    
    NSDictionary *recommendInfo = @{@"Name":@"为您推荐", @"icon":@"tip_recommend", @"type":@"tip"};
    [self.items addObject:recommendInfo];
    _recommendDatas = @[@{@"Name":@"健康咨询",@"subName":@"查看推荐的医生",@"type":@"recommend"},@{@"Name":@"绿色通道",@"type":@"recommend",@"subName":@"就医协助服务"},@{@"Name":@"健康小屋",@"type":@"recommend",@"subName":@"小屋健康助理"}];
    [self.items addObjectsFromArray:_recommendDatas];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - table view source delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.items objectAtIndex:indexPath.row];
    NSString *type = [info valueForKey:@"type"];
    
    if ([type isEqualToString:@"tip"]) {
        // tip cell
        DiseaseResultSegmentTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseResultSegmentTipCell" forIndexPath:indexPath];
        [cell configureWithInfo:info textKey:@"Name"];
        return cell;
    }
//    else if ([type isEqualToString:@"recommend"]) {
//        UHRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UHRecommendCell" forIndexPath:indexPath];
//        [cell configureWithInfo:info textKey:@"Name"];
//        return cell;
//    }
    else {
        // probability cell
        DiseaseProbabilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseProbabilityCell" forIndexPath:indexPath];
        [cell configureWithInfo:info textKey:@"Name"];
        return cell;
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *info = [self.items objectAtIndex:indexPath.row];
    NSString *type = [info valueForKey:@"type"];
    
    if ([type isEqualToString:@"tip"]){
        // tip cell cell
        // TODO nothing
    } else if ([type isEqualToString:@"recommend"]) {
        if ([info[@"Name"] isEqualToString:@"健康咨询"]) {
            ZPConsultDoctorController *control = [[ZPConsultDoctorController alloc] init];
            control.consultDoctorType = ZPConsultDoctorTypeHealthAdvisory;
            [self.navigationController pushViewController:control animated:YES];
        } else if ([info[@"Name"] isEqualToString:@"绿色通道"]) {
            ZPReservationServiceController *reservationControl = [[ZPReservationServiceController alloc] init];
            [self.navigationController pushViewController:reservationControl animated:YES];
        } else {
            //健康小屋
            if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                WEAK_SELF(weakSelf);
                ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                if (!model.companyName || !model.companyName.length) {
                    ZPBindingCompanyController *companyControl = [[ZPBindingCompanyController alloc] init];
                    companyControl.updateComBlock = ^{
                    };
                    [self.navigationController pushViewController:companyControl animated:YES];
                } else {
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
                    } className:[DiseaseResultListViewController class]];

                }
            }
        }
    } else {
        // disease cell
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        DiseaseInfoViewController *vc = [[DiseaseInfoViewController alloc] initWithNibName:@"DiseaseInfoViewController" bundle:bundle];
        vc.diseaseInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // deselect animate
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
