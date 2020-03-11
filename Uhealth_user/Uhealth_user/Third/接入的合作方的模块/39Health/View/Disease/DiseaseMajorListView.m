//
//  DiseaseMajorListView.m
//  YYK
//
//  Created by xiexianyu on 4/27/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseMajorListView.h"
#import "Reachability.h"
#import "QISDataManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface DiseaseMajorListView () <QISTwoMenuViewDelegate>

@property (nonatomic, strong) NSMutableArray *maleMajorList;
@property (nonatomic, strong) NSMutableArray *femaleMajorList;
// for skip minor list page if non
@property (nonatomic, strong, readwrite) NSArray *minorList;

@end

@implementation DiseaseMajorListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDiseaseMajorListView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDiseaseMajorListView];
    }
    return self;
}

- (void)setupDiseaseMajorListView
{
    self.delegate = self;
    
    NSInteger leftWidth = ([UIScreen mainScreen].bounds.size.width-48)/3+8;
    [self adjustWidthOfLeftTableView:leftWidth];
    
    // name for show, param for request.
    // male
    NSArray *malePartInfos = @[@{@"name":@"头",@"param":@"头部"}, @{@"name":@"脑",@"param":@"颅脑"}, @{@"name":@"眼",@"param":@"眼"}, @{@"name":@"咽喉",@"param":@"咽喉"}, @{@"name":@"鼻",@"param":@"鼻"}, @{@"name":@"耳",@"param":@"耳"}, @{@"name":@"口",@"param":@"口"}, @{@"name":@"面部",@"param":@"面部"}, @{@"name":@"颈",@"param":@"颈部"}, @{@"name":@"胸",@"param":@"胸部"}, @{@"name":@"腹",@"param":@"腹部"}, @{@"name":@"腰",@"param":@"腰部"}, @{@"name":@"臀",@"param":@"臀部"}, @{@"name":@"上肢",@"param":@"上肢"}, @{@"name":@"手部",@"param":@"手部"}, @{@"name":@"肩部",@"param":@"肩部"}, @{@"name":@"下肢",@"param":@"下肢"}, @{@"name":@"大腿",@"param":@"大腿"}, @{@"name":@"膝部",@"param":@"膝部"}, @{@"name":@"小腿",@"param":@"小腿"}, @{@"name":@"足部",@"param":@"足部"}, @{@"name":@"骨",@"param":@"骨"}, @{@"name":@"男性生殖",@"param":@"男性生殖"}, @{@"name":@"盆腔",@"param":@"盆腔"}, @{@"name":@"全身",@"param":@"全身"}, @{@"name":@"肌肉",@"param":@"肌肉"}, @{@"name":@"淋巴",@"param":@"淋巴"}, @{@"name":@"血液血管",@"param":@"血液血管"}, @{@"name":@"皮肤",@"param":@"皮肤"}, @{@"name":@"心理",@"param":@"心理"}, @{@"name":@"背部",@"param":@"背部"}];
    
    self.maleMajorList = [[NSMutableArray alloc] initWithCapacity:32];
    NSMutableDictionary *partInfo;
    for (NSDictionary *info in malePartInfos) {
        partInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
        [_maleMajorList addObject:partInfo];
    } //for
    
    // female
    NSArray *femalePartInfos = @[@{@"name":@"头",@"param":@"头部"}, @{@"name":@"脑",@"param":@"颅脑"}, @{@"name":@"眼",@"param":@"眼"}, @{@"name":@"咽喉",@"param":@"咽喉"}, @{@"name":@"鼻",@"param":@"鼻"}, @{@"name":@"耳",@"param":@"耳"}, @{@"name":@"口",@"param":@"口"}, @{@"name":@"面部",@"param":@"面部"}, @{@"name":@"颈",@"param":@"颈部"}, @{@"name":@"胸",@"param":@"胸部"}, @{@"name":@"腹",@"param":@"腹部"}, @{@"name":@"腰",@"param":@"腰部"}, @{@"name":@"臀",@"param":@"臀部"}, @{@"name":@"上肢",@"param":@"上肢"}, @{@"name":@"手部",@"param":@"手部"}, @{@"name":@"肩部",@"param":@"肩部"}, @{@"name":@"下肢",@"param":@"下肢"}, @{@"name":@"大腿",@"param":@"大腿"}, @{@"name":@"膝部",@"param":@"膝部"}, @{@"name":@"小腿",@"param":@"小腿"}, @{@"name":@"足部",@"param":@"足部"}, @{@"name":@"骨",@"param":@"骨"}, @{@"name":@"女性生殖",@"param":@"女性生殖"}, @{@"name":@"盆腔",@"param":@"盆腔"}, @{@"name":@"全身",@"param":@"全身"}, @{@"name":@"肌肉",@"param":@"肌肉"}, @{@"name":@"淋巴",@"param":@"淋巴"}, @{@"name":@"血液血管",@"param":@"血液血管"}, @{@"name":@"皮肤",@"param":@"皮肤"}, @{@"name":@"心理",@"param":@"心理"}, @{@"name":@"背部",@"param":@"背部"}];
    
    self.femaleMajorList = [[NSMutableArray alloc] initWithCapacity:32];
    for (NSDictionary *info in femalePartInfos) {
        partInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
        [_femaleMajorList addObject:partInfo];
    } //for
    
    self.isOneScroll = YES;
}

// setter
- (void)setFemale:(BOOL)isFemale
{
    _isFemale = isFemale;
    
    NSArray *majorList = _isFemale? _femaleMajorList : _maleMajorList;
    [self setupWithInfos:majorList twoLevelKey:@"diseaseList" oneTextKey:@"name" twoTextKey:@"Name"];
}

// first body
- (void)fetchFirstBodyMajorSymptoms
{
    NSArray *majorList = _isFemale? _femaleMajorList : _maleMajorList;
    NSDictionary *firstPartInfo = [majorList firstObject];
    NSString *bodyName = [firstPartInfo valueForKey:@"name"];
    
    // check major infos exist or not
    if ([firstPartInfo valueForKey:@"diseaseList"] == nil) {
        // not exist major symptom infos
        [self fetchMajorSymptomsWithBodyName:bodyName];
    }
}

// fetch by body name
- (void)fetchMajorSymptomsWithBodyName:(NSString*)bodyName
{
    NSArray *majorList = _isFemale? _femaleMajorList : _maleMajorList;
    NSString *name = nil;
    NSInteger index = 0;
    
    for (NSDictionary *info in majorList) {
        name = [info valueForKey:@"name"];
        if ([bodyName isEqualToString:name]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:index];
            [self setupWithInfos:majorList twoLevelKey:@"diseaseList" oneTextKey:@"name" twoTextKey:@"Name" selectedIndexPath:indexPath];
            
            [self fetchMajorSymptomListWithPartInfo:info];
            break ;
        }
        ++index;
    } //for
}

- (void)clearMajorSymptomsAndNeedUpdate:(BOOL)isNeed
{
    // clear male and female disease list
    
    for (NSMutableDictionary *info in _femaleMajorList) {
        [info removeObjectForKey:@"diseaseList"]; //reset
    } //for
    
    for (NSMutableDictionary *info in _maleMajorList) {
        [info removeObjectForKey:@"diseaseList"]; //reset
    } //for
    
    // udpate UI
    NSArray *majorList = _isFemale? _femaleMajorList : _maleMajorList;
    [self setupWithInfos:majorList twoLevelKey:@"diseaseList" oneTextKey:@"name" twoTextKey:@"Name"];
    
    // fetch symptom of first part
    if (isNeed) {
        NSDictionary *firstPartInfo = [majorList firstObject];
        [self fetchMajorSymptomListWithPartInfo:firstPartInfo];
    }
}

#pragma mark - QISTwoMenuViewDelegate

- (void)didSelecteOneLevelItem:(NSDictionary*)info
{
    // check major infos exist or not
    if ([info valueForKey:@"diseaseList"] != nil) {
        // exist major symptom infos
        return ;
    }
    
    [self fetchMajorSymptomListWithPartInfo:info];
    
    // delegate
    if (_symptomDelegate != nil && [_symptomDelegate respondsToSelector:@selector(didSelectOneBodyPart:)]) {
        [_symptomDelegate didSelectOneBodyPart:info];
    }
}

- (void)didSelecteTwoLevelItem:(NSDictionary*)info
{
    // delegate
    if (_symptomDelegate != nil && [_symptomDelegate respondsToSelector:@selector(didSelectOneMajorSymptom:)]) {
        [_symptomDelegate didSelectOneMajorSymptom:info];
    }
}

// helper
- (void)fetchMajorSymptomListWithPartInfo:(NSDictionary*)info
{
    // build params
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:8];
    [params setValue:[info valueForKey:@"param"] forKey:@"body"];
    if (_isFemale) {
        [params setValue:@"性别_女" forKey:@"sex"];
    }
    else {
        [params setValue:@"性别_男" forKey:@"sex"];
    }
    [params setValue:[_ageInfo valueForKey:@"param"] forKey:@"age"];
    
    // request
    __block __strong NSDictionary *currentPartInfo = info;
    
    // check network status
    if(![QISDataManager checkNetworkStatus]) {
        // network error
        [SVProgressHUD showErrorWithStatus:kQISNetNotReachableError];
        return ;
    }
    
    // request data
    [SVProgressHUD show];
    NSURLRequest *request = [QISDataManager requestSymptomsByBodyWithParameters:params];
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
        NSArray *results = [jsonInfo valueForKey:@"results"];
        if ([results isKindOfClass:[NSArray class]] && results.count > 0) {
            [self updateOnePartMajorInfos:results selectedPartInfo:currentPartInfo];
        }
    }];
    
    [dataTask resume];
}

// helper
- (void)updateOnePartMajorInfos:(NSArray*)majorInfos selectedPartInfo:(NSDictionary*)partInfo
{
    // update major list for current part
    NSString *currentPartParam = [partInfo valueForKey:@"param"];
    NSString *partParam;
    
    NSMutableArray *currentMajorList = _isFemale? _femaleMajorList : _maleMajorList;
    for (NSMutableDictionary *info in currentMajorList) {
        partParam = [info valueForKey:@"param"];
        
        if ([partParam isEqualToString:currentPartParam]) {
            // find out, update
            [info setValue:majorInfos forKey:@"diseaseList"];
        }
    } //for
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshRightTableView];
    });
}


@end
