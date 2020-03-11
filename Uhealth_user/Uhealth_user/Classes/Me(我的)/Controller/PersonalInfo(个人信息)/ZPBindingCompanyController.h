//
//  ZPBindingCompanyController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPBindingCompanyController : UIViewController
@property (nonatomic,copy) void (^updateComBlock) (void);
@end
