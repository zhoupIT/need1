//
//  ZPAddAddressController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPAddressModel;
@interface ZPAddAddressController : ZPRootViewController
@property (nonatomic,copy) void (^addAddressBlock) (void);
//添加地址 或者 编辑地址
@property (nonatomic,assign) ZPAddressType addressType;
@property (nonatomic,strong) ZPAddressModel *model;
@end
