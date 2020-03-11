//
//  DiseaseMatchViewController.m
//  YYK
//
//  Created by xiexianyu on 4/22/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseMatchViewController.h"
#import "DiseaseMajorListView.h"
#import "DiseaseAgeWorkListView.h"
#import "DiseaseUserInfoManager.h"
#import "UIView+QISAutolayout.h"
// next page
#import "DiseaseMinorListViewController.h"
//
#import "MaleFrontView.h"
#import "MaleBackView.h"
#import "FemaleFrontView.h"
#import "FemaleBackView.h"
#import "NSString+QISBundleName.h"

@interface DiseaseMatchViewController () <DiseaseAgeWorkListViewDelegate, ImageCheckHitViewDelegate, DiseaseMajorListViewDelegate>

@property (nonatomic, assign) BOOL isList; // show disease list or not.
@property (nonatomic, strong) NSMutableArray *diseaseInfos;

@property (nonatomic, strong) NSArray *genderInfos;
@property (nonatomic, strong) NSArray *ageInfos;
@property (nonatomic ,strong) NSArray *workInfos;
@property (nonatomic, strong) DiseaseUserInfoManager *userInfoManager;

@property (nonatomic, assign) BOOL isBackSide; // front or back
// major list
@property (strong, nonatomic) NSMutableArray *maleMajorList;
@property (strong, nonatomic) NSMutableArray *femaleMajorList;

@property (weak, nonatomic) IBOutlet UIView *barContainerView;
@property (weak, nonatomic) IBOutlet UIView *figureContainerView;
@property (strong, nonatomic) DiseaseMajorListView *diseaseTwoMenuView;
@property (strong, nonatomic) DiseaseAgeWorkListView *ageWorkListView;
//
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@property (weak, nonatomic) IBOutlet UIImageView *genderExtendIcon;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIImageView *ageExtendIcon;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UIButton *workButton;
@property (weak, nonatomic) IBOutlet UIImageView *workExtendIcon;
//
@property (weak, nonatomic) IBOutlet UIButton *switchSideButton;

// male front
@property (strong, nonatomic) MaleFrontView *maleFrontView;
// male back
@property (strong, nonatomic) MaleBackView *maleBackView;
// female front
@property (strong, nonatomic) FemaleFrontView *femaleFrontView;
// female back
@property (strong, nonatomic) FemaleBackView *femaleBackView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation DiseaseMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"症状自查";
    if (_isListOnly) {
        self.isList = YES; // show list
    }
    else {
        [self addSwitchRightItem];
    }
    
    // for saving user selected gender/age/work
    self.userInfoManager = [[DiseaseUserInfoManager alloc] init];
    
    self.genderInfos = @[@{@"name":@"男性", @"sex":@"性别_男"}, @{@"name":@"女性", @"sex":@"性别_女"}];
    
    self.ageInfos = @[@{@"name":@"一个月内", @"param":@"新生儿", @"index":@(1)}, @{@"name":@"2~11个月", @"param":@"婴儿", @"index":@(2)}, @{@"name":@"1~12岁", @"param":@"儿童", @"index":@(3)}, @{@"name":@"13~18岁", @"param":@"少年", @"index":@(4)}, @{@"name":@"19~29岁", @"param":@"青年", @"index":@(5)}, @{@"name":@"30~39岁", @"param":@"壮年", @"index":@(6)}, @{@"name":@"40~49岁", @"param":@"中年", @"index":@(7)}, @{@"name":@"50~64岁", @"param":@"中老年", @"index":@(8)}, @{@"name":@"65岁以上", @"param":@"老年", @"index":@(9)}];
    
    self.workInfos = @[@{@"name":@"工人", @"id":@(3), @"index":@(1)}, @{@"name":@"农民", @"id":@(4), @"index":@(2)}, @{@"name":@"教师", @"id":@(11), @"index":@(3)}, @{@"name":@"服务员", @"id":@(7), @"index":@(4)}, @{@"name":@"司机", @"id":@(5), @"index":@(5)}, @{@"name":@"厨师", @"id":@(6), @"index":@(6)}, @{@"name":@"白领", @"id":@(10), @"index":@(7)}, @{@"name":@"医师/护士", @"id":@(12), @"index":@(8)}, @{@"name":@"公务员", @"id":@(9), @"index":@(9)}, @{@"name":@"销售/采购", @"id":@(8), @"index":@(10)}, @{@"name":@"其他", @"id":@(13), @"index":@(11)}];
    
    [self setupDiseaseTwoMenuView];
    
    // default age and work
    [self setupAgeWorkListView];
    self.ageWorkListView.hidden = YES;
    [self.view bringSubviewToFront:_barContainerView];
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureUserInfoFromLocalCache];
    
    [self showFigureOrList];
    
    self.diseaseTwoMenuView.symptomDelegate = self;
    [_diseaseTwoMenuView setFemale:self.isFemale];
    _diseaseTwoMenuView.ageInfo = self.ageInfo;
    _diseaseTwoMenuView.workInfo = self.workInfo;
    
    if ([_bodyName length] > 0) {
        _diseaseTwoMenuView.isOneScroll = YES;
        [_diseaseTwoMenuView fetchMajorSymptomsWithBodyName:_bodyName];
    }
    
    if (!_isListOnly) {
        // show is male front side.
        [self setupMaleFrontView];
        [self setupMaleBackView];
        [self setupFemaleFrontView];
        [self setupFemaleBackView];
        
        // hide all at first
        _maleFrontView.hidden = YES; // hide
        _maleBackView.hidden = YES;
        _femaleFrontView.hidden = YES;
        _femaleBackView.hidden = YES;
        
        if (self.isFemale) {
            if (_isBackSide) {
                _femaleBackView.hidden = NO; // show
            }
            else {
                _femaleFrontView.hidden = NO;
            }
        }
        else {
            if (_isBackSide) {
                _maleBackView.hidden = NO; // show
            }
            else {
                _maleFrontView.hidden = NO;
            }
        }
        
        if (_isBackSide) {
            [_switchSideButton setTitle:@"正面" forState:UIControlStateNormal];
        }
        else {
            [_switchSideButton setTitle:@"反面" forState:UIControlStateNormal];
        }
      
        [self.figureContainerView bringSubviewToFront:_switchSideButton];
        [self.figureContainerView bringSubviewToFront:_tipLabel];
    }
    else {
        self.figureContainerView.hidden = YES; //hide
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (!_isListOnly) {
        // reset all part, not highlight selected part
        [_maleFrontView reset];
        [_maleBackView reset];
        
        [_femaleFrontView reset];
        [_femaleBackView reset];
    }
}

//- (void)viewDidLayoutSubviews
//{
//    DebugLog(@"");
//}

- (void)configureUserInfoFromLocalCache
{
    // local cache user info
    self.isFemale = _userInfoManager.isFemale;
    NSDictionary *ageInfo = _userInfoManager.ageInfo;
    NSDictionary *workInfo = _userInfoManager.workInfo;
    
    NSInteger genderIndex = self.isFemale? 1:0;
    NSInteger ageIndex = [[ageInfo valueForKey:@"index"] integerValue];
    if (ageIndex == 0) {
        ageIndex = 6; // default age 30~39
    }
    NSInteger workIndex = [[workInfo valueForKey:@"index"] integerValue];
    if (workIndex == 0) {
        workIndex = 7; // default 白领
    }
    
    [_ageWorkListView configureWithGenderList:_genderInfos
                                      AgeList:_ageInfos
                                     workList:_workInfos
                           defaultGenderIndex:genderIndex
                              defaultAgeIndex:ageIndex-1
                             defaultWorkIndex:workIndex-1];
    
    NSDictionary *genderInfo = [_genderInfos objectAtIndex:_ageWorkListView.genderSelectedIndex];
    self.ageInfo = [_ageInfos objectAtIndex:_ageWorkListView.ageSelectedIndex];
    self.workInfo = [_workInfos objectAtIndex:_ageWorkListView.workSelectedIndex];
    // update name
    self.genderLabel.text = [genderInfo valueForKey:@"name"];
    self.ageLabel.text = [self.ageInfo valueForKey:@"name"];
    self.workLabel.text = [self.workInfo valueForKey:@"name"];
}

// override
- (void)handleSwitchBarButtonItem:(UIBarButtonItem*)sender
{
    [super handleSwitchBarButtonItem:sender]; // update title
    
    self.isList = !_isList; // switch
    
    [self showFigureOrList];
    
    if (_isList) {
        [_diseaseTwoMenuView fetchFirstBodyMajorSymptoms];
    }
}

// helper
- (void)showFigureOrList
{
    if (_isList) {
        // show list
        self.figureContainerView.hidden = YES;
        self.diseaseTwoMenuView.hidden = NO;
        
        _ageWorkListView.hidden = YES; // hide
    }
    else {
        // show figure
        self.figureContainerView.hidden = NO;
        self.diseaseTwoMenuView.hidden = YES;
    }
}

- (void)setupDiseaseTwoMenuView
{
    self.diseaseTwoMenuView = [[DiseaseMajorListView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_diseaseTwoMenuView];
    
    // auto layout
    _diseaseTwoMenuView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view pinSubview:_diseaseTwoMenuView toEdge:NSLayoutAttributeLeading];
    [self.view pinSubview:_diseaseTwoMenuView toEdge:NSLayoutAttributeTrailing];
    [self.view pinSubview:_diseaseTwoMenuView toEdge:NSLayoutAttributeTop offset:-44.0];
    [self.view pinSubview:_diseaseTwoMenuView toEdge:NSLayoutAttributeBottom];
}

- (void)setupAgeWorkListView
{
    self.ageWorkListView = [[DiseaseAgeWorkListView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_ageWorkListView];
    
    _ageWorkListView.delegate = self;
    
    // auto layout
    _ageWorkListView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *newConstraints = [NSMutableArray array];
    NSDictionary *views = @{@"ageWorkListView": self.ageWorkListView};
    
    NSArray *constraints11 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[ageWorkListView]-0-|" options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:constraints11];
    
    NSArray *constraints12 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[ageWorkListView]-0-|" options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:constraints12];
    
    [NSLayoutConstraint activateConstraints:newConstraints];
    
    // update
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)setupMaleFrontView
{
    NSString *nibName = @"MaleFrontView";
    nibName = [nibName bundleNameForDevice];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    self.maleFrontView = [[bundle loadNibNamed:nibName owner:nil options:nil] firstObject];
    [self.figureContainerView addSubview:_maleFrontView];
    _maleFrontView.delegate = self;
    
    // auto layout
    
    _maleFrontView.translatesAutoresizingMaskIntoConstraints = NO;
    [_figureContainerView pinAllEdgesOfSubview:_maleFrontView];
}

- (void)setupMaleBackView
{
    NSString *nibName = @"MaleBackView";
    nibName = [nibName bundleNameForDevice];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    self.maleBackView = [[bundle loadNibNamed:nibName owner:nil options:nil] firstObject];
    [self.figureContainerView addSubview:_maleBackView];
    _maleBackView.delegate = self;
    
    // auto layout
    
    _maleBackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_figureContainerView pinAllEdgesOfSubview:_maleBackView];
}

- (void)setupFemaleFrontView
{
    NSString *nibName = @"FemaleFrontView";
    nibName = [nibName bundleNameForDevice];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    self.femaleFrontView = [[bundle loadNibNamed:nibName owner:nil options:nil] firstObject];
    [self.figureContainerView addSubview:_femaleFrontView];
    _femaleFrontView.delegate = self;
    
    // auto layout
    
    _femaleFrontView.translatesAutoresizingMaskIntoConstraints = NO;
    [_figureContainerView pinAllEdgesOfSubview:_femaleFrontView];
}

- (void)setupFemaleBackView
{
    NSString *nibName = @"FemaleBackView";
    nibName = [nibName bundleNameForDevice];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    self.femaleBackView = [[bundle loadNibNamed:nibName owner:nil options:nil] firstObject];
    [self.figureContainerView addSubview:_femaleBackView];
    _femaleBackView.delegate = self;
    
    // auto layout
    
    _femaleBackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_figureContainerView pinAllEdgesOfSubview:_femaleBackView];
}

#pragma mark - DiseaseAgeWorkListViewDelegate

- (void)didSelectGender:(NSDictionary *)genderInfo
{
    if ([[genderInfo valueForKey:@"name"] isEqualToString:@"男性"]) {
        self.isFemale = NO;
    }
    else {
        self.isFemale = YES;
    }
    
    // save
    _userInfoManager.isFemale = self.isFemale;
    
    self.genderLabel.text = [genderInfo valueForKey:@"name"];
    
    [self updateGenderAndSide];
    
    [_diseaseTwoMenuView setFemale:self.isFemale];
    _diseaseTwoMenuView.genderInfo = genderInfo;
    
    if (_isList) { // show list
        [_diseaseTwoMenuView clearMajorSymptomsAndNeedUpdate:YES];
    }
    else {
        [_diseaseTwoMenuView clearMajorSymptomsAndNeedUpdate:NO];
    }
    
    [self animateToShowAgeWorkListView:NO]; // move up
}

- (void)didSelectAge:(NSDictionary *)ageInfo
{
    // selected age info
    self.ageInfo = ageInfo;
    
    // save to local cache
    _userInfoManager.ageInfo = self.ageInfo;
    
    self.ageLabel.text = [self.ageInfo valueForKey:@"name"];
    
    _diseaseTwoMenuView.ageInfo = self.ageInfo;
    
    if (_isList) { // show list
        [_diseaseTwoMenuView clearMajorSymptomsAndNeedUpdate:YES];
    }
    else {
        [_diseaseTwoMenuView clearMajorSymptomsAndNeedUpdate:NO];
    }
    
    [self animateToShowAgeWorkListView:NO]; // move up
}

- (void)didSelectWork:(NSDictionary *)workInfo
{
    // selected work info
    self.workInfo = workInfo;
    
    // save to local cache
    _userInfoManager.workInfo = workInfo;
    
    self.workLabel.text = [workInfo valueForKey:@"name"];
    
    _diseaseTwoMenuView.workInfo = workInfo;
    
    if (_isList) { // show list
        [_diseaseTwoMenuView clearMajorSymptomsAndNeedUpdate:YES];
    }
    else {
        [_diseaseTwoMenuView clearMajorSymptomsAndNeedUpdate:NO];
    }
    
    [self animateToShowAgeWorkListView:NO]; // move up
}

#pragma mark - ImageCheckHitViewDelegate
- (void)didSelectOnePart:(NSDictionary *)info
{
    // update
    self.bodyName = [info valueForKey:@"name"];
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    DiseaseMatchViewController *vc = [[DiseaseMatchViewController alloc] initWithNibName:@"DiseaseMatchViewController" bundle:bundle];
    
    vc.bodyName = [info valueForKey:@"name"];
    vc.isListOnly = YES;
    vc.isFemale = self.isFemale;
    vc.ageInfo = self.ageInfo;
    vc.workInfo = self.workInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DiseaseMajorListViewDelegate

- (void)didSelectOneBodyPart:(NSDictionary *)info
{
    // update
    self.bodyName = [info valueForKey:@"name"];
}

- (void)didSelectOneMajorSymptom:(NSDictionary *)info
{
    [self fetchMinorSymptomListWithMajorInfo:info];
}

#pragma mark - handle buttons

- (IBAction)handleButtonAge:(UIButton *)sender
{
    BOOL isHide = _ageWorkListView.hidden;
    
    if(_ageWorkListView.listType == QISDiseaseListAge) {
        // same type
        _ageWorkListView.hidden = !isHide;
    }
    else {
        // different type
        _ageWorkListView.hidden = NO; // show
    }
    _ageWorkListView.listType = QISDiseaseListAge;
    
    BOOL isDownToShow = !_ageWorkListView.hidden;
    [self animateToShowAgeWorkListView:isDownToShow];
}

- (IBAction)handleButtonWork:(UIButton *)sender
{
    BOOL isHide = _ageWorkListView.hidden;
    
    if(_ageWorkListView.listType == QISDiseaseListWork) {
        // same type
        _ageWorkListView.hidden = !isHide;
    }
    else {
        // different type
        _ageWorkListView.hidden = NO; // show
    }
    _ageWorkListView.listType = QISDiseaseListWork;
    
    BOOL isDownToShow = !_ageWorkListView.hidden;
    [self animateToShowAgeWorkListView:isDownToShow];
}

- (IBAction)handleButtonGender:(UIButton *)sender
{
    BOOL isHide = _ageWorkListView.hidden;
    
    if(_ageWorkListView.listType == QISDiseaseListGender) {
        // same type
        _ageWorkListView.hidden = !isHide;
    }
    else {
        // different type
        _ageWorkListView.hidden = NO; // show
    }
    _ageWorkListView.listType = QISDiseaseListGender;
    
    BOOL isDownToShow = !_ageWorkListView.hidden;
    [self animateToShowAgeWorkListView:isDownToShow];
}

// helper
- (void)animateToShowAgeWorkListView:(BOOL)isDown
{
    if (isDown) {
        // show animate
        _ageWorkListView.hidden = NO; //show
        [_ageWorkListView animateToShow];
    }
    else {
        // hide without animate
        _ageWorkListView.hidden = YES;
    }
}

- (IBAction)handleButtonSwitchSide:(UIButton *)sender
{
    self.isBackSide = !_isBackSide;
    [self updateGenderAndSide];
}

// helper
- (void)updateGenderAndSide
{
    // hide all
    self.maleFrontView.hidden = YES;
    self.maleBackView.hidden = YES;
    // female
    self.femaleFrontView.hidden = YES;
    self.femaleBackView.hidden = YES;
    
    if (self.isFemale) {
        if (_isBackSide) {
            self.femaleBackView.hidden = NO; // show
            [_switchSideButton setTitle:@"正面" forState:UIControlStateNormal]; // to front side
        }
        else {
            self.femaleFrontView.hidden = NO; // show
            [_switchSideButton setTitle:@"反面" forState:UIControlStateNormal]; // to back side
        }
    }
    else {
        // male
        if (_isBackSide) {
            self.maleBackView.hidden = NO; // show
            [_switchSideButton setTitle:@"正面" forState:UIControlStateNormal];
        }
        else {
            self.maleFrontView.hidden = NO; // show
            [_switchSideButton setTitle:@"反面" forState:UIControlStateNormal];
        }
    }
}

@end
