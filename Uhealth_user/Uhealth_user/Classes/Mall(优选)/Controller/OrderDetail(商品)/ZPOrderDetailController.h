//
//  ZPOrderDetailController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPCommodity;
@interface ZPOrderDetailController : ZPRootViewController
@property (nonatomic,strong) ZPCommodity *commodity;
@property (nonatomic,assign) ZPOrderEnterStatusType enterStatusType;
@end
