//
//  ZPForPwdController.h
//  uhealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPForPwdController : UIViewController
@property (nonatomic,copy) void (^modifyPasswordBlock) (void);
/** present出来的 */
@property (nonatomic,assign) BOOL isPresent;
@end
