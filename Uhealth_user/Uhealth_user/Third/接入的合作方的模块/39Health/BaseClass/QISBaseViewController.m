//
//  QISBaseViewController.m
//  QISDisease
//
//  Created by xiexianyu on 5/28/18.
//  Copyright © 2018 39. All rights reserved.
//

#import "QISBaseViewController.h"

@interface QISBaseViewController ()

@end

@implementation QISBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

// any text
- (UIBarButtonItem *)textBarButtonItemWithTitle:(NSString*)title
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(handleTextBarButtonItem:)];
    return barButtonItem;
}

// override it
- (void)handleTextBarButtonItem:(UIBarButtonItem*)sender
{
    // action
}

- (void)addTextRightItemWithTitle:(NSString*)title
{
    self.navigationItem.rightBarButtonItem = [self textBarButtonItemWithTitle:title];
}

- (void)addTextSpaceRightBarItemsWithTitle:(NSString*)title
{
    UIBarButtonItem *barButtonItem = [self textBarButtonItemWithTitle:title];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 7.0;
    self.navigationItem.rightBarButtonItems = @[spaceItem, barButtonItem];
}

// title switch
- (UIBarButtonItem *)switchBarButtonItem
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表查看" style:UIBarButtonItemStylePlain target:self action:@selector(handleSwitchBarButtonItem:)];
    return barButtonItem;
}

// override it
- (void)handleSwitchBarButtonItem:(UIBarButtonItem*)sender
{
    // switch action
    if([sender.title isEqualToString:@"部位图"]) {
        sender.title = @"列表查看";
    }
    else {
        sender.title = @"部位图";
    }
}

- (void)addSwitchRightItem
{
    self.navigationItem.rightBarButtonItem = [self switchBarButtonItem];
}

@end
