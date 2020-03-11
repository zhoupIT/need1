//
//  QISBaseListViewController.h
//  YYK
//
//  Created by xiexianyu on 12/18/17.
//  Copyright © 2017 39.net. All rights reserved.
//

#import "QISBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QISBaseListViewController : QISBaseViewController <UITableViewDataSource, UITableViewDelegate>

// default false, use UITableView or UITableViewController
@property (assign, nonatomic) BOOL isChildTablePage; //set it before push/present vc
@property (nonnull, strong, nonatomic, readonly) NSMutableArray *items; //one refresh section
//
@property (nonnull, strong, nonatomic, readonly) UITableView *tableView; //plain style

// adjust top and bottom of table view.
- (void)adjustTableViewWithTop:(CGFloat)top bottom:(CGFloat)bottom;

#pragma mark - update items for refreshing
// for refresh list
- (void)resetList; // clear all data, reload list.
- (void)configureList:(NSArray*)items;
- (void)updateList:(NSArray*)items isEndAppend:(BOOL)isEnd;

@end

NS_ASSUME_NONNULL_END
