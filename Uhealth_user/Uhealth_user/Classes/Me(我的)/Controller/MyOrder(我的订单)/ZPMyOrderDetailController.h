//
//  ZPMyOrderDetailController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPOrderModel.h"
@interface ZPMyOrderDetailController : UIViewController
@property (nonatomic,strong) ZPOrderModel *orderModel;

@property (nonatomic,copy) void (^updateTableBlock) (void);
@end
