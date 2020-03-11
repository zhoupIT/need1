//
//  ZPMyOrderController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPOrderModel;

@interface ZPMyOrderController : ZPRootViewController
@property (nonatomic,copy) void (^detailClickEventBlock) (ZPOrderModel *model);
@property (nonatomic,copy) void (^payBlock) (ZPOrderModel *model);
//订单状态
@property (nonatomic,assign) ZPOrderStatusType orderStatusType;
@property (nonatomic,copy) void (^refreshTableBlock) (void);

@property (nonatomic,copy) void (^traceBlock) (ZPOrderModel *model);
@end
