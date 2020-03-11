//
//  DiseaseGuideViewController.m
//  YYK
//
//  Created by xiexianyu on 5/5/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseGuideViewController.h"
// cell
#import "DiseaseGuideInfoCell.h"
#import "DiseaseGuideNameCell.h"

@interface DiseaseGuideViewController ()

// sample cell
@property (strong, nonatomic) DiseaseGuideInfoCell *sampleCell;

@end

@implementation DiseaseGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"就诊指南";

    self.tableView.estimatedRowHeight = 92.0;
    
    // register cell
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *cellName = @"DiseaseGuideNameCell";
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:bundle] forCellReuseIdentifier:cellName];
    cellName = @"DiseaseGuideInfoCell";
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:bundle] forCellReuseIdentifier:cellName];
    // sample cell
    self.sampleCell = [[bundle loadNibNamed:cellName owner:nil options:nil] firstObject];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _sampleCell.bounds = CGRectMake(0., 0., screenWidth, 92.0);
    
    [self fetchGuideInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - fetch data
- (void)fetchGuideInfo
{
    NSString *idString = [[NSString alloc] initWithFormat:@"%@", [_detailInfo valueForKey:@"ID"]];
    if ([idString length] == 0) {
        //DebugLog(@"ERROR: disease ID is nil");
        return ;
    }
    
    NSDictionary *params = @{@"jbkDiseaseId":idString};
    
    // request
    [SVProgressHUD show];
    NSURLRequest *request = [QISDataManager requestDiseaseGuideWithParameters:params];
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
        
        // good data
        NSDictionary *info = [jsonInfo valueForKey:@"response"];
        if ([info isKindOfClass:[NSDictionary class]] && info.count > 0) {
            NSDictionary *guideInfo = [info valueForKey:@"diseaseGuide"];
            if ([guideInfo isKindOfClass:[NSDictionary class]]) {
                [self adapteDataListWithInfo:guideInfo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }//if
    }];
    
    [dataTask resume];
}

- (void)adapteDataListWithInfo:(NSDictionary*)guideInfo
{
    NSMutableArray *guideInfos = [[NSMutableArray alloc] init];
    
    // disease name
    NSString *name = [_detailInfo valueForKey:@"NAME"];
    [guideInfos addObject:@{@"name":name, @"type":@"tip", @"icon":@"disease_name"}];
    
    // desc list
    NSString *desc;
    // symptom
    desc = [guideInfo valueForKey:@"Symptom"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"典型症状", @"desc":desc}];
    }
    // dept
    desc = [guideInfo valueForKey:@"RefDiseaseDept"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"建议就诊科室", @"desc":desc}];
    }
    //
    desc = [guideInfo valueForKey:@"BestTreatTime"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"最佳就诊时间", @"desc":desc}];
    }
    //
    desc = [guideInfo valueForKey:@"CostTime"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"就诊时长", @"desc":desc}];
    }
    //
    desc = [guideInfo valueForKey:@"TreatCycle"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"复诊频率/诊疗周期", @"desc":desc}];
    }
    //
    desc = [guideInfo valueForKey:@"Prepare"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"就诊前准备", @"desc":desc}];
    }
    //
    NSArray *descList = [guideInfo valueForKey:@"CommonContent"];
    if ([descList isKindOfClass:[NSArray class]] && [descList count] > 0) {
        NSMutableString *allDesc = [[NSMutableString alloc] init];
        NSInteger total = [descList count];
        NSInteger index = 0;
        for (NSString *oneDesc in descList) {
            if (index+1 < total) {
                [allDesc appendFormat:@"%@\n", oneDesc];
            }
            else { // last
                [allDesc appendFormat:@"%@", oneDesc];
            }
            index++;
        } //for
        
        [guideInfos addObject:@{@"name":@"常见问诊内容", @"desc":allDesc}];
    }
    //
    descList = [guideInfo valueForKey:@"ImportantProject"];
    if ([descList isKindOfClass:[NSArray class]] && [descList count] > 0) {
        NSMutableString *allDesc = [[NSMutableString alloc] init];
        NSInteger total = [descList count];
        NSInteger index = 0;
        for (NSString *oneDesc in descList) {
            if (index+1 < total) {
                [allDesc appendFormat:@"%@\n", oneDesc];
            }
            else { // last
                [allDesc appendFormat:@"%@", oneDesc];
            }
            index++;
        } //for
        
        [guideInfos addObject:@{@"name":@"重点检查项目", @"desc":allDesc}];
    }
    //
    desc = [guideInfo valueForKey:@"Standard"];
    if ([desc isKindOfClass:[NSString class]] && desc.length > 0) {
        [guideInfos addObject:@{@"name":@"诊断标准", @"desc":desc}];
    }
    
    [self.items addObjectsFromArray:guideInfos];
}

#pragma mark - table view source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSDictionary *info = nil;
    if (row < [self.items count]) {
        info = [self.items objectAtIndex:row];
    }
    
    if (row > 0 ) { // desc
        DiseaseGuideInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseGuideInfoCell" forIndexPath:indexPath];
        [cell configureWithInfo:info];
        return cell;
    }
    else {
        DiseaseGuideNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseGuideNameCell" forIndexPath:indexPath];
        [cell configureWithInfo:info];
        return cell;
    }
    
}

#pragma mark - table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // deselect animate
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

// for iOS 7.x
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50.0;
    }
    
    NSDictionary *info = nil;
    if (indexPath.row < [self.items count]) {
        info = [self.items objectAtIndex:indexPath.row];
    }
    
    [_sampleCell configureWithInfo:info];

    CGSize size = [_sampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = size.height + 1.0;
    //DebugLog(@"h=%f, row %ld", height, indexPath.row);
    
    return height;
}


@end
