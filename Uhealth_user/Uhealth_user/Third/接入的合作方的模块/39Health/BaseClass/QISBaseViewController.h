//
//  QISBaseViewController.h
//  QISDisease
//
//  Created by xiexianyu on 5/28/18.
//  Copyright © 2018 39. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QISDataManager.h"
#import "Reachability.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface QISBaseViewController : UIViewController

- (void)addTextRightItemWithTitle:(NSString*)title;
- (void)addTextSpaceRightBarItemsWithTitle:(NSString*)title;
- (void)handleTextBarButtonItem:(UIBarButtonItem*)sender; // override it
//
- (void)addSwitchRightItem;
// override it
- (void)handleSwitchBarButtonItem:(UIBarButtonItem*)sender;

@end
