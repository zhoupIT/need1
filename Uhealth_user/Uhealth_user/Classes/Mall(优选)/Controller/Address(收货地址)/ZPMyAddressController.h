//
//  ZPMyAddressController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPAddressModel;
@interface ZPMyAddressController : ZPRootViewController
@property (nonatomic,copy) void (^selectLocBlock) (ZPAddressModel *model);
@end
