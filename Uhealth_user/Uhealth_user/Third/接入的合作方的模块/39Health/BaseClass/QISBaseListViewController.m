//
//  QISBaseListViewController.m
//  YYK
//
//  Created by xiexianyu on 12/18/17.
//  Copyright © 2017 39.net. All rights reserved.
//

#import "QISBaseListViewController.h"
#import "UIView+QISAutolayout.h"

@interface QISBaseListViewController ()
@property (nonnull, strong, nonatomic, readwrite) UITableView *tableView; //plain style
@property (nullable, strong, nonatomic, readwrite) UITableViewController *tableViewController;
@property (nonnull, strong, nonatomic, readwrite) NSMutableArray *items; //one refresh section
//
@property (nonnull, strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (nonnull, strong, nonatomic) NSLayoutConstraint *bottomConstraint;

@end

@implementation QISBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [[NSMutableArray alloc] init];
    [self setupListView];
    [self configureListView];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)setupListView {
    UITableViewStyle listStyle = UITableViewStylePlain;
    if (self.isChildTablePage) {
        // table view controller
        self.tableViewController = [[UITableViewController alloc] initWithStyle:listStyle];
        self.tableView = _tableViewController.tableView;
        
        // add child view contoller
        [self addChildViewController:_tableViewController];
        [self didMoveToParentViewController:self];
        [self.view addSubview:_tableViewController.tableView];
    }
    else {
        CGRect rect = CGRectZero;
        self.tableView = [[UITableView alloc] initWithFrame:rect style:listStyle];
        [self.view addSubview:_tableView];
    }
}

- (void)configureListView {
    // register default cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    // hide separator line if empty cell. show separator line in last cell
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // iOS8 self sizing cells
    _tableView.estimatedRowHeight = 44.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    // separator color and inset
    UIColor *lineColor = [UIColor colorWithRed:246.0/255.0 green:248.0/255.0 blue:252.0/255.0 alpha:1.0];
    _tableView.separatorColor = lineColor;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero; //iOS8
    //
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // auto layout
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view pinSubview:_tableView toEdge:NSLayoutAttributeLeading];
    [self.view pinSubview:_tableView toEdge:NSLayoutAttributeTrailing];
    self.topConstraint = [self.view pinSubview:_tableView toEdge:NSLayoutAttributeTop];
    self.bottomConstraint = [self.view pinSubview:_tableView toEdge:NSLayoutAttributeBottom];
}

// adjust top and bottom of table view.
- (void)adjustTableViewWithTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGFloat topOffset = -top;
    CGFloat bottomOffset = bottom;
    self.topConstraint.constant = topOffset;
    self.bottomConstraint.constant = bottomOffset;
}

#pragma mark - update items for refreshing

// clear all data, reload
- (void)resetList {
    [self.items removeAllObjects];
    [self.tableView reloadData];
}

- (void)configureList:(NSArray*)items {
    [self.items removeAllObjects];
    if ([items count] > 0) {
        [self.items addObjectsFromArray:items];
    }
    [self.tableView reloadData];
}

- (void)updateList:(NSArray*)items isEndAppend:(BOOL)isEnd {
    if (items == nil || [items count] == 0) { //no changed
        return ;
    }
    
    if (isEnd) { //after add
        [self.items addObjectsFromArray:items];
    }
    else { //before add
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:1];
        NSInteger count = [items count];
        for (NSInteger index=2; index<count; ++index) {
            [indexes addIndex:index];
        }//for
        
        [self.items insertObjects:items atIndexes:indexes];
    }
    [self.tableView reloadData];
}

#pragma mark - table view source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect animate
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44.0;
//}

@end
