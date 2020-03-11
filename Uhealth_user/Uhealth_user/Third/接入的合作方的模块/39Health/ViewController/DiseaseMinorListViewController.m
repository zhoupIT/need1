//
//  DiseaseMinorListViewController.m
//  YYK
//
//  Created by xiexianyu on 4/24/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseMinorListViewController.h"
#import "DiseaseMajorSelectedCell.h"
#import "DiseaseMinorSymptomCell.h"
#import "MinorSymptom.h"
// next page
#import "DiseaseResultListViewController.h"

@interface DiseaseMinorListViewController ()
@property (nonatomic, strong) NSMutableArray *minorItems;
@end

@implementation DiseaseMinorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择次要症状";
    
    [self addTextRightItemWithTitle:@"提交"];
    
    // register cell
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiseaseMinorSymptomCell" bundle:bundle] forCellReuseIdentifier:@"DiseaseMinorSymptomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiseaseMajorSelectedCell" bundle:bundle] forCellReuseIdentifier:@"DiseaseMajorSelectedCell"];
    
    self.tableView.allowsMultipleSelection = YES;
    
    // request data
    [self fetchMinorSymptomList];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

// override it
- (void)handleTextBarButtonItem:(UIBarButtonItem*)sender
{
    [self openResultPage];
}

- (void)openResultPage
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    DiseaseResultListViewController *vc = [[DiseaseResultListViewController alloc] initWithNibName:@"DiseaseResultListViewController" bundle:bundle];
    
    vc.isFemale = _isFemale;
    vc.ageInfo = _ageInfo;
    vc.workInfo = _workInfo;
    vc.majorInfo = _majorInfo;
    vc.symptomAllIDText = [self buildAllSymptomIDText];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// helper
- (NSString*)buildAllSymptomIDText
{
    NSString *majorIDText = [NSString stringWithFormat:@"%@", [_majorInfo valueForKey:@"ID"]];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:majorIDText];
    
    for (MinorSymptom *item in _minorItems) {
        if (item.didSelect) {
            [text appendFormat:@",%@", item.minorID];
        }
    } //for
    
    return text;
}

- (void)fetchMinorSymptomList
{
    // build params
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:8];
    [params setValue:[_majorInfo valueForKey:@"ID"] forKey:@"idarr"];
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
            NSArray *minorList = [resultInfo valueForKey:@"SList"];
            if ([minorList isKindOfClass:[NSArray class]]) {
                // OK, and exist minor list
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self adapterDataWithMinorInfos:minorList];
                });
            }
        }
    }];
    
    [dataTask resume];
}

// helper
- (void)adapterDataWithMinorInfos:(NSArray*)infos
{
    self.minorItems = [[NSMutableArray alloc] init];
    
    MinorSymptom *item;
    for (NSDictionary *info in infos) {
        item = [[MinorSymptom alloc] initWithInfo:info];
        [_minorItems addObject:item];
    } //for
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:_minorItems];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - table view source delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // major; minor;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section > 0) {
        return [self.items count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        DiseaseMinorSymptomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseMinorSymptomCell" forIndexPath:indexPath];
        
        MinorSymptom *minorItem = [self.items objectAtIndex:indexPath.row];
        [cell configureWithItem:minorItem];
    
        return cell;
    }
    else {
        DiseaseMajorSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseMajorSelectedCell" forIndexPath:indexPath];
        [cell configureWithMajorInfo:self.majorInfo];
        
        return cell;
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) { //not minor
        return ;
    }
    
    // update check state
    MinorSymptom *item = [self.items objectAtIndex:indexPath.row];
    item.didSelect = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) { //not minor
        return ;
    }
    
    // update check state
    MinorSymptom *item = [self.items objectAtIndex:indexPath.row];
    item.didSelect = NO;
}

@end
