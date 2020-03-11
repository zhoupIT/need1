//
//  QISTwoMenuView.m
//  YYK
//
//  Created by xiexianyu on 1/14/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISTwoMenuView.h"
// cell
#import "QISIconOneTextCell.h"
#import "QISTextIconCell.h"
//
#import "QISConditionSwitchPrivate.h"


@interface QISTwoMenuView ()
{
    // width of the left table view
    CGFloat _leftWidth;
    CGFloat _rightWidth;  // screen width - left width
}

@property (nonatomic, copy, readwrite) NSString *listKey;
@property (nonatomic, assign) BOOL didSaveCheck; // save check state or not
@property (nonatomic, strong) NSArray *oneInfos;
@property (nonatomic, strong) NSArray *twoInfos;
@property (nonatomic, copy) NSString *twoLevelKey;
@property (nonatomic, copy) NSString *oneTextKey;
@property (nonatomic, copy) NSString *twoTextKey;
@property (nonatomic, assign, readwrite) NSInteger leftIndex; // left list index
// right list selected index
@property (nonatomic, assign, readwrite) NSInteger rightIndex;
// table view
@property (nonatomic, strong) UITableView *oneTableView; // left list
@property (nonatomic, strong) UITableView *twoTableView; // right list
@property (nonatomic, strong) UIView *verticalLineView; // seperate line in vertical
// sample cell
@property (nonatomic ,strong) QISIconOneTextCell *oneSampleCell;
@property (nonatomic ,strong) QISBaseCell *twoSampleCell;

@property (nonatomic, strong) NSArray *widthConstraints;

@end

@implementation QISTwoMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    [self setupTwoTableView];
    
    // default cell type
    self.rightCellType = QISTextIconCellType;
    
    // default keys
    _twoLevelKey = @"list";
    _oneTextKey = @"name";
    _twoTextKey = @"name";
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // FIXME: - bug of iOS9
    self.twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupWithInfos:(NSArray*)infos
           twoLevelKey:(NSString*)twoLevelKey
            oneTextKey:(NSString*)oneTextKey
            twoTextKey:(NSString*)twoTextKey
{
    // default selected first item and unselected sub item.
    [self setupWithInfos:infos twoLevelKey:twoLevelKey oneTextKey:oneTextKey twoTextKey:twoTextKey selectedIndexPath:nil];
}

- (void)setupWithInfos:(NSArray*)infos
           twoLevelKey:(NSString*)twoLevelKey
            oneTextKey:(NSString*)oneTextKey
            twoTextKey:(NSString*)twoTextKey
     selectedIndexPath:(NSIndexPath*)indexPath
{
    // check params
    
    self.oneInfos = infos;
    
    // keys
    if (twoLevelKey.length > 0) {
        self.twoLevelKey = twoLevelKey;
    }
    if (oneTextKey.length > 0) {
        self.oneTextKey = oneTextKey;
    }
    if (twoTextKey.length > 0) {
        self.twoTextKey = twoTextKey;
    }
    
    // set left and right index
    if (indexPath != nil && indexPath.length == 2) {
        //limit index
        _leftIndex = indexPath.section;
        _rightIndex = indexPath.row;
    }
    else {
        // default selected first item.
        _leftIndex = 0;
        _rightIndex = -1; // unselected sub item
    }
    
    if (_leftIndex < 0 && _rightCellType != QISSelectCityType) {
        // default selected first item in left table.
        _leftIndex = 0;
    }
    
    // set sub item infos.
    if (_leftIndex >= 0 && _leftIndex < [_oneInfos count]) {
        // left index range is ok
        self.twoInfos = [[_oneInfos objectAtIndex:_leftIndex] objectForKey:_twoLevelKey];
    }
    else if (_leftIndex < 0) {
        // unselected left item, try to show first sub items
        self.twoInfos = [[_oneInfos firstObject] objectForKey:_twoLevelKey];
    }
    else {
        self.twoInfos = nil;
    }
    
    [_oneTableView reloadData];
    [_twoTableView reloadData];
    
    // selected cell
    if ([_oneInfos count] > 0 && _leftIndex >= 0) {
        [self selectRowAtIndex:_leftIndex tableView:_oneTableView shouldScroll:_isOneScroll];
    }
    if ([_twoInfos count] > 0 && _rightIndex >= 0) {
        [self selectRowAtIndex:_rightIndex tableView:_twoTableView shouldScroll:_isOneScroll];
    }
    self.isOneScroll = NO; // reset
}

// helper
- (void)selectRowAtIndex:(NSUInteger)rowIndex tableView:(UITableView *)tableView shouldScroll:(BOOL)isNeed
{
    // selected one
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    
    if (isNeed) {
        [tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    else {
        [tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
}

// for update right data
- (void)refreshRightTableView
{
    // refresh data list
    if (_leftIndex >= 0 && _leftIndex < [_oneInfos count]) {
        self.twoInfos = [[_oneInfos objectAtIndex:_leftIndex] valueForKey:_twoLevelKey];
    }
    
    [self.twoTableView reloadData];
    
    if (_rightIndex >= 0 && _rightIndex < [_twoInfos count]) {
        [self selectRowAtIndex:_rightIndex tableView:_twoTableView shouldScroll:NO];
    }
}

#pragma mark - access methods

- (void)setRightCellType:(QISCellType)rightCellType
{
    _rightCellType = rightCellType;
    
    // sample cell for computing height, and register cell
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *cellName = [self cellName];
    self.twoSampleCell = [[bundle loadNibNamed:cellName owner:nil options:nil] firstObject];
    [self.twoTableView registerNib:[UINib nibWithNibName:cellName bundle:bundle] forCellReuseIdentifier:cellName];
    
    _twoSampleCell.frame = CGRectMake(0., 0., _rightWidth, 44.);
    
    UIColor *bkColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIColor *lineColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    if (rightCellType == QISSelectCityType) {
        _twoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _oneTableView.backgroundView.backgroundColor = bkColor;
        _oneTableView.separatorColor = lineColor;
        _twoTableView.separatorColor = lineColor;
    }
    else if (rightCellType == QISCircleSquareType) {
        _oneTableView.backgroundView.backgroundColor = bkColor;
        _oneTableView.separatorColor = lineColor;
    }
}

- (NSString*)cellName
{
    NSString *cellName = @"QISTextIconCell";
    return cellName;
}

- (NSDictionary*)selectedLeftInfo
{
    if (_leftIndex >= 0 && _leftIndex < [_oneInfos count]) {
        return [_oneInfos objectAtIndex:_leftIndex];
    }
    else if (_rightCellType == QISSelectCityType) {
        // if show auto city, then left info as hot city
        return [_oneInfos objectAtIndex:0];
    }
    
    return nil;
}

- (NSDictionary*)selectedRightInfo
{
    if (_rightIndex >= 0 && _rightIndex < [_twoInfos count]) {
        return [_twoInfos objectAtIndex:_rightIndex];
    }
    
    return nil;
}

#pragma mark - layout
// helper
- (void)setupTwoTableView
{
    // default width is half of screen
    _leftWidth = [UIScreen mainScreen].bounds.size.width/2 - 4; // middle space 8
    _rightWidth = _leftWidth; // half
    
    // one table view
    self.oneTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _oneTableView.delegate = self;
    _oneTableView.dataSource = self;
    _oneTableView.backgroundColor = [UIColor whiteColor];
    _oneTableView.translatesAutoresizingMaskIntoConstraints = NO; // use auto layout
    // table separator style
    _oneTableView.separatorInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    if ([_oneTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _oneTableView.layoutMargins = UIEdgeInsetsZero;
    }
    // hide separator line if empty cell.
    self.oneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // show separator line in last cell
    [self addSubview:self.oneTableView];
    
    UIColor *lineColor = [UIColor colorWithRed:246.0/255.0 green:248.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.oneTableView.separatorColor = lineColor;
    
    // iOS8 self sizing cells
    self.oneTableView.estimatedRowHeight = 44.0; // default row height
    self.oneTableView.rowHeight = UITableViewAutomaticDimension;
    
    // register default cell
    //[self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OneTableViewCell"];
    
    // sample cell for computing height, and register cell
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *leftCellName = @"QISIconOneTextCell";
    self.oneSampleCell = [[bundle loadNibNamed:leftCellName owner:nil options:nil] firstObject];
    [self.oneTableView registerNib:[UINib nibWithNibName:leftCellName bundle:bundle] forCellReuseIdentifier:leftCellName];
    // for select city page
    leftCellName = @"QISLineIconTextCell";
    [self.oneTableView registerNib:[UINib nibWithNibName:leftCellName bundle:bundle] forCellReuseIdentifier:leftCellName];
    // for cicel square page
    leftCellName = @"CircleSquareTypeCell";
    [self.oneTableView registerNib:[UINib nibWithNibName:leftCellName bundle:bundle] forCellReuseIdentifier:leftCellName];
    
    // two table view
    self.twoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.translatesAutoresizingMaskIntoConstraints = NO; // use auto layout
    // table separator style
    _twoTableView.separatorInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    if ([_twoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _twoTableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    _twoTableView.separatorColor = lineColor;
    _twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // hide separator line if empty cell.
    self.twoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // show separator line in last cell
    [self addSubview:self.twoTableView];
    
    // iOS8 self sizing cells
    self.twoTableView.estimatedRowHeight = 44.0; // default row height
    self.twoTableView.rowHeight = UITableViewAutomaticDimension;
    
    // register default cell
    //[self.twoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TwoTableViewCell"];
    
    // vertical line
    self.verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(_leftWidth-0.5, 0.0, 0.5, self.bounds.size.height)];
    _verticalLineView.backgroundColor = lineColor;
    
    UIView *tableBkView = [[UIView alloc] initWithFrame:CGRectZero];
    UIColor *bkColor = [UIColor colorWithRed:246.0/255.0 green:248.0/255.0 blue:252.0/255.0 alpha:1.0];
    tableBkView.backgroundColor = bkColor;
    self.oneTableView.backgroundView = tableBkView;
    [self.oneTableView.backgroundView addSubview:_verticalLineView];
    _verticalLineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // auto layout
    
    NSMutableArray *newConstraints = [NSMutableArray array];
    NSDictionary *views = @{@"oneTableView": self.oneTableView, @"twoTableView":self.twoTableView, @"verticalLineView":self.verticalLineView};
    
    NSNumber *leftW = @(_leftWidth); //
    NSDictionary *metrics = NSDictionaryOfVariableBindings(leftW);
    
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[oneTableView(leftW)]-[twoTableView]|" options:0 metrics:metrics views:views];
    [newConstraints addObjectsFromArray:constraints1];
    self.widthConstraints = constraints1; // save for update it
    
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[oneTableView]|" options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:constraints2];
    
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[twoTableView]|" options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:constraints3];
    
    NSArray *constraints41 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[verticalLineView(0.5)]|" options:0 metrics:metrics views:views];
    [newConstraints addObjectsFromArray:constraints41];
    
    NSArray *constraints42 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[verticalLineView]|" options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:constraints42];
    
    [NSLayoutConstraint activateConstraints:newConstraints];
    
    // adjust cell frame
    _oneSampleCell.frame = CGRectMake(0., 0., _leftWidth, 44.);
}

- (void)adjustWidthOfLeftTableView:(CGFloat)leftWidth
{
    _leftWidth = leftWidth;
    _rightWidth = [UIScreen mainScreen].bounds.size.width - _leftWidth;
    
    // remove old
    [self removeConstraints:_widthConstraints];
    [_oneTableView removeConstraints:_widthConstraints];
    [_twoTableView removeConstraints:_widthConstraints];
    
    // add new
    
    NSDictionary *views = @{@"oneTableView": self.oneTableView, @"twoTableView":self.twoTableView};
    
    NSNumber *leftW = @(leftWidth); //
    NSDictionary *metrics = NSDictionaryOfVariableBindings(leftW);
    
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[oneTableView(leftW)]-[twoTableView]|" options:0 metrics:metrics views:views];
    self.widthConstraints = constraints1; //save it
    
    [NSLayoutConstraint activateConstraints:_widthConstraints];
    
    // adjust cell frame
    _oneSampleCell.frame = CGRectMake(0., 0., _leftWidth, 44.);
    _twoSampleCell.frame = CGRectMake(0., 0., _rightWidth, 44.);
    
    // update
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    // update UI
    [self.oneTableView reloadData];
    [self.twoTableView reloadData];
}

#pragma mark - table view source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _oneTableView) {
        return [_oneInfos count];
    }
    else {
        return [_twoInfos count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (tableView == _oneTableView) {
        // one level cell
        NSString *cellName = @"QISIconOneTextCell";
        QISBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        // configure
        // check state
        if (row < [_oneInfos count]) {
            NSDictionary *info = [_oneInfos objectAtIndex:row];
            [cell configureWithInfo:info textKey:_oneTextKey];
        }
        else {
            [cell configureWithInfo:nil textKey:_oneTextKey];
        }

        return cell;
    }
    else {
        // two level cell
        NSString *cellName = [self  cellName];
        QISBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        if (row < [_twoInfos count]) {
            NSDictionary *info = [_twoInfos objectAtIndex:row];
            [cell configureWithInfo:info textKey:_twoTextKey];
        }
        else {
            [cell configureWithInfo:nil textKey:_twoTextKey];
        }
        
        return cell;
    }
    
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    if (tableView == _oneTableView) {
        if (row != _leftIndex) {
            // if did select another item
            _leftIndex = row; // update it
            
            self.twoInfos = [[_oneInfos objectAtIndex:_leftIndex] valueForKey:_twoLevelKey];
            
            if (_didSelectRight) {
                // selected first sub item.
                if ([self.twoInfos count] > 0) {
                    _rightIndex = 0;
                }
                else {
                    // non sub item, unselected
                    _rightIndex = -1;
                }
            }
            else {
                //unselected
                _rightIndex = -1;
            }

            // notify delegate
            if ([_delegate respondsToSelector:@selector(didSelecteOneLevelItem:)]) {
                // update second level data
                NSDictionary *oneInfo = [_oneInfos objectAtIndex:row];
                [_delegate didSelecteOneLevelItem:oneInfo];
            }
            
            // refresh second list
            [self.twoTableView reloadData];
            
            if (_rightIndex >= 0) {
                [self selectRowAtIndex:_rightIndex tableView:_twoTableView shouldScroll:NO];
            }
        }
        else {
            // not change
            // TODO nothing
        }
        
    }
    else {
        // two level table view
        
        // deselect animate
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        _rightIndex = indexPath.row;
        
        // notify delegate
        NSDictionary *twoInfo = [_twoInfos objectAtIndex:row];
        if ([_delegate respondsToSelector:@selector(didSelecteTwoLevelItem:)]) {
            [_delegate didSelecteTwoLevelItem:twoInfo];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:MainGetPageDataNotification object:nil];
        }
    }
    
}

// for iOS 7.x
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _oneTableView) {
        if (_rightCellType == QISSelectCityType) { //city list
            return 44.0;
        }
        else if (_rightCellType == QISCircleSquareType) { //circle square
            return 75.0;
        }
        
        // check state
        if (indexPath.row < [_oneInfos count]) {
            NSDictionary *info = [_oneInfos objectAtIndex:indexPath.row];
            [_oneSampleCell configureWithInfo:info textKey:_oneTextKey];
        }
        else {
            [_oneSampleCell configureWithInfo:nil textKey:_oneTextKey];
        }
        
        CGSize size = [_oneSampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat height = ceil(size.height) + 1.0;
        //DebugLog(@"one list h=%f", height);
        
        if (height < 44.0) {
            height = 44.0; // min height
        }
        
        return height;
    }
    else {
        // two table view
        if (indexPath.row < [self.twoInfos count]) {
            NSDictionary *twoInfo = [self.twoInfos objectAtIndex:indexPath.row];
            [_twoSampleCell configureWithInfo:twoInfo textKey:_twoTextKey];
        }
        else {
            [_twoSampleCell configureWithInfo:nil textKey:_twoTextKey];
        }
        
        CGSize size = [_twoSampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat height = size.height + 1.0;
        //DebugLog(@"two list h=%f", height);
        
        if (height < 44.0) {
            height = 44.0; // min height
        }
        
        return height;
    }
    
    // default height
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _oneTableView) {
        if (indexPath.row == _leftIndex) {
            [cell setSelected:YES animated:NO];
        }
        else {
            [cell setSelected:NO animated:NO];
        }
    }
    else {
        // two level table view
        if (indexPath.row == _rightIndex) {
            [cell setSelected:YES animated:NO];
        }
        else {
            [cell setSelected:NO animated:NO];
        }
    }
}


@end
