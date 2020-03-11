//
//  ZPPayController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger,ZPPayEnterType) {
    ZPPayEnterTypeNormal,
    ZPPayEnterTypeCart,
    ZPPayEnterTypeOrderDetail,
    ZPPayEnterTypeGreenPath
};
@interface ZPPayController : UIViewController
@property (nonatomic,copy) NSString *orderID;//订单id
@property (nonatomic,assign) ZPPayEnterType payEnterType;
@end
