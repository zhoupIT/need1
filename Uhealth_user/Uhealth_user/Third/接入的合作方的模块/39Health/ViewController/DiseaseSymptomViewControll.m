//
//  DiseaseSymptomViewControll.m
//  YYK
//
//  Created by xiexianyu on 5/18/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseSymptomViewControll.h"
// next page
#import "DiseaseMinorListViewController.h"
#import "DiseaseResultListViewController.h"


@implementation DiseaseSymptomViewControll

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)fetchMinorSymptomListWithMajorInfo:(NSDictionary*)majorInfo
{
    // build params
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:8];
    [params setValue:[majorInfo valueForKey:@"ID"] forKey:@"idarr"];
    if (_isFemale) {
        [params setValue:@"性别_女" forKey:@"sex"];
    }
    else {
        [params setValue:@"性别_男" forKey:@"sex"];
    }
    [params setValue:[_ageInfo valueForKey:@"param"] forKey:@"age"];
    [params setValue:[_workInfo valueForKey:@"id"] forKey:@"jobid"];
    
    // check network status
    if(![QISDataManager checkNetworkStatus]) {
        // network error
        [SVProgressHUD showErrorWithStatus:kQISNetNotReachableError];
        return ;
    }
    
    // request data
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
            NSArray *minorList = [resultInfo valueForKey:@"SList"];
            if ([minorList isKindOfClass:[NSArray class]]) {
                // OK, and exist minor list
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([minorList count] > 0) {
                        [self openMinorListPageWithMajorInfo:majorInfo];
                    }
                    else {
                        // non minor list, skip minor list pag
                        [self openResultPageWithMajorInfo:majorInfo];
                    }
                });
            }
        }
    }];
    
    [dataTask resume];
}

- (void)openMinorListPageWithMajorInfo:(NSDictionary*)info
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    DiseaseMinorListViewController *vc = [[DiseaseMinorListViewController alloc] initWithNibName:@"DiseaseMinorListViewController" bundle:bundle];
    vc.majorInfo = info;
    vc.isFemale = _isFemale;
    vc.ageInfo = _ageInfo;
    vc.workInfo = _workInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openResultPageWithMajorInfo:(NSDictionary*)info
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    DiseaseResultListViewController *vc = [[DiseaseResultListViewController alloc] initWithNibName:@"DiseaseResultListViewController" bundle:bundle];
    vc.isFemale = _isFemale;
    vc.ageInfo = _ageInfo;
    vc.workInfo = _workInfo;
    vc.majorInfo = info;
    NSString *majorIDText = [NSString stringWithFormat:@"%@", [info valueForKey:@"ID"]];
    vc.symptomAllIDText = majorIDText;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
