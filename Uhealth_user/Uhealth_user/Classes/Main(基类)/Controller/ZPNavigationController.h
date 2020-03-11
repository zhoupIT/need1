//
//  ZPNavigationController.h
//  Peng Zhou
//
//  Created by 鹏 周 on 2017/8/28.
//  Copyright (c) 2017年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZPAnimationDuration     0.5f
#define ZPMinX                  (0.3f * kSCREEN_WIDTH)

@interface UIViewController (ZPNavigationControllerAdd)
/**
 *  If yes, disable the drag back, default no.
 */
@property (nonatomic, assign) BOOL disableDragBack;
@end

@interface ZPNavigationController : UINavigationController
/**
 *  If yes, disable the drag back, default no. global
 */
@property (nonatomic, assign) BOOL disableDragBack;

@end
