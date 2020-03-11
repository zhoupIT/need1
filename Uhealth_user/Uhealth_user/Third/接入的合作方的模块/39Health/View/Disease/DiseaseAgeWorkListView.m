//
//  DiseaseAgeWorkListView.m
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseAgeWorkListView.h"
#import "UIView+QISAutolayout.h"
// cell
#import "QISTextIconCell.h"

@interface DiseaseAgeWorkListView () <UITableViewDataSource, UITableViewDelegate>

// for gender list
@property (strong, nonatomic) NSArray *genderInfos;
@property (assign, nonatomic, readwrite) NSInteger genderSelectedIndex;
// for age list
@property (strong, nonatomic) NSArray *ageInfos;
@property (assign, nonatomic, readwrite) NSInteger ageSelectedIndex;
// for work list
@property (strong, nonatomic) NSArray *workInfos;
@property (assign, nonatomic, readwrite) NSInteger workSelectedIndex;
// UI
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UITableView *tableView;
// cover view
@property (strong, nonatomic) UIView *coverView;
// auto layout
@property (strong, nonatomic) NSLayoutConstraint *containerViewHeightConstraint;

@end


@implementation DiseaseAgeWorkListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCoverView];
        [self setupTableView];
        
        [self setupDefaultData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCoverView];
        [self setupTableView];
        
        [self setupDefaultData];
    }
    return self;
}

- (void)setupDefaultData
{
    _genderSelectedIndex = -1; //unselected -1
    _ageSelectedIndex = -1;
    _workSelectedIndex = -1;
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:singleTap];
}

- (void)setupCoverView
{
    self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.4; // half transparent
    [self addSubview:_coverView];
    
    // auto layout
    _coverView.translatesAutoresizingMaskIntoConstraints = NO;
    [self pinAllEdgesOfSubview:_coverView];
}

- (void)setupTableView
{
    // container view
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    //
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self pinSubview:_containerView toEdge:NSLayoutAttributeLeading];
    [self pinSubview:_containerView toEdge:NSLayoutAttributeTrailing];
    [self pinSubview:_containerView toEdge:NSLayoutAttributeTop];
    self.containerViewHeightConstraint = [_containerView pinViewHeight:44.0];
    
    // table view
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // hide separator line if empty cell. show separator line in last cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
    [_containerView addSubview:self.tableView];
    
    UIColor *lineColor = [UIColor colorWithRed:246.0/255.0 green:248.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.tableView.separatorColor = lineColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // iOS8 self sizing cells
    self.tableView.estimatedRowHeight = 44.0; // default row height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.separatorInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    // register cell
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    NSString *cellName = @"QISTextIconCell";
    [_tableView registerNib:[UINib nibWithNibName:cellName bundle:bundle] forCellReuseIdentifier:cellName];
    
    // auto layout table view
    _tableView.translatesAutoresizingMaskIntoConstraints = NO; // use auto layout
    [_containerView pinAllEdgesOfSubview:_tableView];
}

//MARK: - show animate
- (void)animateToShow
{
    NSString *animationKey = @"filter_show_animation";
    [_containerView.layer removeAnimationForKey:animationKey];
    
    CGFloat minHeight = 44.0;
    CGFloat height = _containerViewHeightConstraint.constant;
    if (height < minHeight) {
        height = minHeight;
    }
    
    // move down
    CABasicAnimation *downAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    downAnimation.fromValue = @(- height);
    downAnimation.toValue = @(0.0);
    downAnimation.repeatCount = 1;
    // alpha
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(0.0);
    alphaAnimation.toValue = @(1.0);
    alphaAnimation.repeatCount = 1;
    // group animation
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    //animaGroup.duration = 0.2f;
    animaGroup.animations = @[downAnimation,alphaAnimation];
    //
    [_containerView.layer addAnimation:animaGroup forKey:animationKey];
}

- (void)configureWithGenderList:(NSArray*)genderInfos
                        AgeList:(NSArray*)ageInfos
                       workList:(NSArray*)workInfos
             defaultGenderIndex:(NSInteger)genderIndex
                defaultAgeIndex:(NSInteger)ageIndex
               defaultWorkIndex:(NSInteger)workIndex
{
    self.genderInfos = genderInfos;
    self.ageInfos = ageInfos;
    self.workInfos = workInfos;
    
    if (genderIndex < [_genderInfos count]) {
        self.genderSelectedIndex = genderIndex;
    }
    else {
        self.genderSelectedIndex = 0; //first item
    }
    
    if (ageIndex < [_ageInfos count]) {
        self.ageSelectedIndex = ageIndex;
    }
    else {
        self.ageSelectedIndex = 0; //first item
    }
    
    if (workIndex < [_workInfos count]) {
        self.workSelectedIndex = workIndex;
    }
    else {
        self.workSelectedIndex = 0; //first item
    }
    
    [self.tableView reloadData];
    [self selectOneRow];
}

// setter
- (void)setListType:(QISDiseaseListType)listType
{
    _listType = listType;
    
    // list total height
    NSInteger totalCount = 0;
    if (_listType == QISDiseaseListGender) {
        totalCount = [self.genderInfos count];
    }
    else if (_listType == QISDiseaseListAge) { // age list
        totalCount = [self.ageInfos count];
    }
    else {
        totalCount = [self.workInfos count];
    }
    _containerViewHeightConstraint.constant = 44.0 * totalCount;
    
    [self.containerView setNeedsLayout];
    [self.containerView layoutIfNeeded];
    
    [self.tableView reloadData];
    [self selectOneRow];
}

- (void)selectOneRow
{
    // selected one
    if (_listType == QISDiseaseListGender) {
        // gender list
        if (_genderSelectedIndex >= 0) { // did select
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_genderSelectedIndex inSection:0];
            [_tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    else if (_listType == QISDiseaseListAge) {
        // age list
        if (_ageSelectedIndex >= 0) { // did select
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_ageSelectedIndex inSection:0];
            [_tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    else {
        if(_workSelectedIndex >= 0) { // work list
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_workSelectedIndex inSection:0];
            [_tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

#pragma mark - handle gensture recognizer
- (void)handleSingleTap:(UIGestureRecognizer*)recognizer
{
    // hide self
    self.hidden = YES;
}

#pragma mark - table view source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listType == QISDiseaseListGender) {
        // gender list
        return [_genderInfos count];
    }
    else if (_listType == QISDiseaseListAge) {
        // age list
        return [_ageInfos count];
    }
    else {
        return [_workInfos count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QISTextIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QISTextIconCell" forIndexPath:indexPath];
    
    NSDictionary *info = nil;
    
    if (_listType == QISDiseaseListGender) {
        // gender list
        info = [_genderInfos objectAtIndex:indexPath.row];
    }
    else if (_listType == QISDiseaseListAge) {
        // age list
        info = [_ageInfos objectAtIndex:indexPath.row];
    }
    else {
        info = [_workInfos objectAtIndex:indexPath.row];
    }
    
    [cell configureWithInfo:info textKey:@"name"];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselect animate
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_listType == QISDiseaseListGender) {
        // gender list
        self.genderSelectedIndex = indexPath.row;
        
        // delegate
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectGender:)]) {
            NSDictionary *info = [_genderInfos objectAtIndex:indexPath.row];
            [_delegate didSelectGender:info];
        }
    }
    else if (_listType == QISDiseaseListAge) {
        self.ageSelectedIndex = indexPath.row;
        
        // delegate
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectAge:)]) {
            NSDictionary *info = [_ageInfos objectAtIndex:indexPath.row];
            [_delegate didSelectAge:info];
        }
    }
    else {
        self.workSelectedIndex = indexPath.row;
        
        // delegate
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectWork:)]) {
            NSDictionary *info = [_workInfos objectAtIndex:indexPath.row];
            [_delegate didSelectWork:info];
        }
    }
}

// for iOS 7.x
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listType == QISDiseaseListGender) {
        // gender list
        if (indexPath.row == _genderSelectedIndex) {
            [cell setSelected:YES animated:NO];
        }
        else {
            [cell setSelected:NO animated:NO];
        }
    }
    else if (_listType == QISDiseaseListAge) { // age list
        if (indexPath.row == _ageSelectedIndex) {
            [cell setSelected:YES animated:NO];
        }
        else {
            [cell setSelected:NO animated:NO];
        }
    }
    else { // work list
        if (indexPath.row == _workSelectedIndex) {
            [cell setSelected:YES animated:NO];
        }
        else {
            [cell setSelected:NO animated:NO];
        }
    }
}

@end

