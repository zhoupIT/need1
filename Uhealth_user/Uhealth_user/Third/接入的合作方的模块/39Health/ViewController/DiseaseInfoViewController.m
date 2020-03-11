//
//  DiseaseInfoViewController.m
//  YYK
//
//  Created by xiexianyu on 12/14/16.
//  Copyright © 2016 39.net. All rights reserved.
//

#import "DiseaseInfoViewController.h"
// next pages
#import "DiseaseGuideViewController.h"
// cells
#import "QISConstEightSpaceCell.h"
#import "DiseaseDetailTextCell.h"
#import "DiseaseInfoGuideCell.h"
#import "DiseaseInfoExpandCell.h"

@interface DiseaseInfoViewController ()
// v5.7, for saving fetch detail info
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *symptom;
@property (copy, nonatomic) NSString *diff;
//
@property (assign, nonatomic) NSInteger expandSection; //begin 0
@property (strong, nonatomic) DiseaseDetailTextCell *descSampleCell;
@property (strong, nonatomic) DiseaseInfoExpandCell *expandSampleCell;
//
@property (weak, nonatomic) IBOutlet UIView *guideContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guideBottomConstraint;
@end

@implementation DiseaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"%@详情", [self diseaseName]];
    
    UIColor *bkColor = [UIColor colorWithRed:246.0/255.0 green:248.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.tableView.backgroundColor = bkColor;
    UIColor *lineColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.tableView.separatorColor = lineColor;
    
    // iOS8 self sizing cells
    const CGFloat expandHeight = 86.0;
    self.tableView.estimatedRowHeight = expandHeight; // default row height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // register cells
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSArray *cellNames = @[@"QISConstEightSpaceCell", @"DiseaseDetailTextCell", @"DiseaseInfoGuideCell", @"DiseaseDetailTipMoreCell", @"DiseaseInfoExpandCell"];
    for (NSString *cellName in cellNames) {
        [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:bundle] forCellReuseIdentifier:cellName];
    }
    
    // sample cells
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    NSString *cellName = @"DiseaseInfoExpandCell";
    self.expandSampleCell = [[bundle loadNibNamed:cellName owner:nil options:nil] firstObject];
    _expandSampleCell.bounds = CGRectMake(0., 0., screenWidth, expandHeight);
    //
    cellName = @"DiseaseDetailTextCell";
    self.descSampleCell = [[bundle loadNibNamed:cellName owner:nil options:nil] firstObject];
    _descSampleCell.bounds = CGRectMake(0., 0., screenWidth, 44.0);
    
    if (_isGuide) {
        CGFloat height = 44.0;
        CGFloat bottom = 0.0;
        if ((screenSize.height > 811.0 && screenHeight > 374.0)
            || (screenSize.height > 374.0 && screenHeight > 811.0)) {
            // iPhoneX
            height += 34.0;
            bottom = 34.0;
        }
        self.guideBottomConstraint.constant = bottom;
        self.guideContainerView.hidden = NO; //show
        [self adjustTableViewWithTop:0.0 bottom:height];
    }
    else {
        self.guideContainerView.hidden = YES; //hide
        [self adjustTableViewWithTop:0.0 bottom:0.0];
    }
    
    [self fetchDiseaseDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleButtonGuide:(UIButton *)sender {
    [self openGuidePage];
}

#pragma mark - open next page

- (void)openGuidePage
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    DiseaseGuideViewController *vc = [[DiseaseGuideViewController alloc] initWithNibName:@"DiseaseGuideViewController" bundle:bundle];
    vc.detailInfo = _detailInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
}

// helper
- (NSString*)diseaseName
{
    NSString *name = [_diseaseInfo valueForKey:@"Name"];
    if ([name isKindOfClass:[NSString class]]
        && [name length] > 0) {
        return name;
    }
    
    name = [_detailInfo valueForKey:@"NAME"];
    if ([name isKindOfClass:[NSString class]]
        && [name length] > 0) {
        return name;
    }

    return @"疾病";
}

#pragma mark - fetch data
- (void)fetchDiseaseDetail
{
    id idValue = [_diseaseInfo valueForKey:@"ID"];
    if (idValue == nil) {
        return ;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:idValue forKey:@"jbkDiseaseId"]; // jbk ID
    
    NSString *name = [_diseaseInfo valueForKey:@"Name"];
    if ([name isKindOfClass:[NSString class]]
        && [name length] > 0) {
        [params setValue:name forKey:@"diseaseName"];
    }

    [SVProgressHUD show];
    NSURLRequest *request = [QISDataManager requestDiseaseDetailWithParameters:params];
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
            NSDictionary *detailInfo = [info valueForKey:@"diseaseDetail"];
            if ([detailInfo isKindOfClass:[NSDictionary class]]) {
                self.detailInfo = detailInfo;
            }
            else {
                self.detailInfo = nil;
            }
            
            // intro. v5.6
            NSString *intro = [info valueForKey:@"diseaseIntro"];
            if ([intro isKindOfClass:[NSString class]] && [intro length] > 0) {
                self.intro = intro;
            }
            else {
                self.intro = intro;
            }
            // diff
            NSString *diff = [info valueForKey:@"diseaseDiagnosis"];
            if ([diff isKindOfClass:[NSString class]] && [diff length] > 0) {
                self.diff = diff;
            }
            else {
                self.diff = diff;
            }
            // symptom
            NSString *symptom = [info valueForKey:@"diseaseSymptom"];
            if ([symptom isKindOfClass:[NSString class]] && [symptom length] > 0) {
                self.symptom = symptom;
            }
            else {
                self.symptom = symptom;
            }
        }
        else {
            self.detailInfo = nil;

            self.intro = nil;
            self.diff = nil;
            self.symptom = nil;
        }
        
        // adapt data
        [self buildDiseaseDesc];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isFromChatAsk) { //update title
                self.title = [NSString stringWithFormat:@"%@详情", [self diseaseName]];
            }

            //[self updateGuideState]; //not show guide at bottom

            [self.tableView reloadData];
        });
    }];
    
    [dataTask resume];
}

// helper
- (void)updateGuideState
{
    if ([[_detailInfo valueForKey:@"IS_GUIDE"] isEqualToString:@"Y"]) {
        // exist guide of disease
        self.isGuide = YES;
    }
    else {
        self.isGuide = NO;
    }
    
    if (_isGuide) {
        self.guideContainerView.hidden = NO; //show
        [self adjustTableViewWithTop:0.0 bottom:44.0];
    }
    else {
        self.guideContainerView.hidden = YES; //hide
        [self adjustTableViewWithTop:0.0 bottom:0.0];
    }
}

// helper
- (void)buildDiseaseDesc
{
    // build desc
    // 别名、多发人群、是否属于医保、治疗费用、治愈率共五项数据
    NSMutableString *allDesc = [[NSMutableString alloc] init];
    NSArray *descKeys = @[@"ALIAS_CN", @"MUTIPLE_CROWD", @"IS_MEDICARE", @"GENERALLY_COST", @"CURERATE"];
    NSArray *descTips = @[@"别名:", @"多发人群:", @"是否属于医保:", @"治疗费用:", @"治愈率:"];
    NSString *desc = nil;
    
    NSInteger descIndex = 0;
    for (NSString *key in descKeys) {
        desc = [_detailInfo valueForKey:key];
        if ([desc length] > 0) {
            desc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([desc length] > 0) {
            if ([allDesc length] > 0) {
                [allDesc appendFormat:@"\n"];
            }
            NSString *tip = descTips[descIndex];
            [allDesc appendFormat:@"%@ %@", tip, desc];
        }
        descIndex++;
    } //for
    if ([allDesc length] == 0) {
        [allDesc appendString:@""];
    }
    
    // save
    self.descTips = descTips;
    self.desc = allDesc;
    
    NSString *intro = [_intro length] > 0 ? _intro : @"";
    NSDictionary *introInfo = @{@"name":@"疾病简介", @"content":intro};
    self.introInfo = introInfo;
    //
    NSString *symptom = [_symptom length] > 0 ? _symptom : @"";
    NSDictionary *symptomInfo = @{@"name":@"典型症状", @"content":symptom};;
    self.symptomInfo = symptomInfo;
    //
    NSString *diff = [_diff length] > 0 ? _diff : @"";
    NSDictionary *diffInfo = @{@"name":@"鉴别诊断", @"content":diff};
    self.diffInfo = diffInfo;
}

#pragma mark - table view source delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    switch (section) {
        case 0: // intro info;space;
        {
            count  = 2;
        }
            break;
        case 1: // summary info;space;
        {
            count = 2;
        }
            break;
        case 2: // symptom;space;
        {
            NSString *content = [_symptomInfo valueForKey:@"content"];
            if ([content length] > 0) {
                count = 2;
            }
            else {
                count = 0; // no show
            }
        }
            break;
        case 3: // propability;
        {
            NSString *content = [_diffInfo valueForKey:@"content"];
            if ([content length] > 0) {
                count = 1;
            }
            else {
                count = 0; // no show
            }
        }
            break;
        case 4: // guide;
        {
            if (_isGuide) {
                count = 0;
            }
            else {
                count = 0;
            }
        }
            break;
        
        default:
            break;
    } //switch
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    // space cell
    QISConstEightSpaceCell *spaceCell = [tableView dequeueReusableCellWithIdentifier:@"QISConstEightSpaceCell"];
    
    switch (section) {
        case 0:
        {
            if (row == 0) { //intro info
                DiseaseInfoExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseInfoExpandCell" forIndexPath:indexPath];
                
                [cell configureWithInfo:_introInfo hideExpand:YES didExpand:YES];
                return cell;
            }
        }
            break;
        case 1:
        {
            if (row == 0) { //summary info
                DiseaseDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseDetailTextCell" forIndexPath:indexPath];
                
                [cell configureWithDesc:_desc tips:_descTips];
                return cell;
            }
        }
            break;
        case 2:
        {
            //symptom
            if (row == 0) {
                DiseaseInfoExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseInfoExpandCell" forIndexPath:indexPath];
                
                BOOL didExpand = _expandSection == 2 ? YES : NO;
                [cell configureWithInfo:_symptomInfo hideExpand:NO didExpand:didExpand];
                
                return cell;
            }
        }
            break;
        case 3:
        {
            // propability
            DiseaseInfoExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseInfoExpandCell" forIndexPath:indexPath];
            
            BOOL didExpand = _expandSection == 3 ? YES : NO;
            [cell configureWithInfo:_diffInfo hideExpand:NO didExpand:didExpand];
            
            return cell;
        }
            break;
        case 4:
        {
            //guide
            DiseaseInfoGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiseaseInfoGuideCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        default:
            break;
    } //switch
    
    return spaceCell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselect animate
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 2:
        case 3:
        {
            if (row == 0) {
                if (_expandSection > 0
                    && _expandSection == section) {
                    self.expandSection = 0; //reset
                }
                else {
                    self.expandSection = section;
                }
                
                [tableView reloadData];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
            break;
        
        default:
            break;
    } //switch
}

// for iOS 7.x
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    
//    CGFloat height = 8.0; //space height
//    
//    switch (section) {
//        case 0:
//        {
//            if (row == 0) {
//                [_expandSampleCell configureWithInfo:_introInfo hideExpand:YES didExpand:YES];
//                [_expandSampleCell setNeedsLayout]; //for ios 7.x
//                [_expandSampleCell layoutIfNeeded];
//                CGSize size = [_expandSampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//                height = ceil(size.height) + 1.0;
//            }
//        }
//            break;
//        case 1:
//        {
//            if (row == 0) {
//                [_descSampleCell configureWithDesc:_desc tips:_descTips];
//                [_descSampleCell setNeedsLayout]; //for ios 7.x
//                [_descSampleCell layoutIfNeeded];
//                CGSize size = [_descSampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//                height = ceil(size.height) + 1.0;
//            }
//        }
//            break;
//        case 2:
//        {
//            if (row == 0) {
//                BOOL didExpand = NO;
//                if (_expandSection == 2) {
//                    didExpand = YES;
//                }
//                [_expandSampleCell configureWithInfo:_symptomInfo hideExpand:NO didExpand:didExpand];
//                [_expandSampleCell setNeedsLayout]; //for ios 7.x
//                [_expandSampleCell layoutIfNeeded];
//                CGSize size = [_expandSampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//                height = ceil(size.height) + 1.0;
//            }
//        }
//            break;
//        case 3:
//        {
//            if (row == 0) {
//                BOOL didExpand = NO;
//                if (_expandSection == 3) {
//                    didExpand = YES;
//                }
//                [_expandSampleCell configureWithInfo:_diffInfo hideExpand:NO didExpand:didExpand];
//                [_expandSampleCell setNeedsLayout]; //for ios 7.x
//                [_expandSampleCell layoutIfNeeded];
//                CGSize size = [_expandSampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//                height = ceil(size.height) + 1.0;
//            }
//        }
//            break;
//        case 4:
//        {
//            height = 44.0;
//        }
//            break;
//            
//        default:
//            break;
//    } //switch
//    
//    return height;
//}

@end
