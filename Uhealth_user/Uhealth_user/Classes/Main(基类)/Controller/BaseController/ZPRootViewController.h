//
//  ZPRootViewController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPRootViewController : UIViewController
/* 滚动距离 */
@property (nonatomic, assign) CGFloat scrollOffsetY;
/* 渐变导航栏的透明度 */
@property (nonatomic,assign) CGFloat navigationBarAlpha;
/* 导航栏上的item的背景图 */
@property (nonatomic,strong) UIImage *itemBackgroundImage;
/* 初始化界面UI */
- (void)initAll;
/* 初始化数据 */
- (void)initData;
/* 刷新界面 */
- (void)refreshPage;
/* 结束上次的刷新 */
-(void)endLastRefresh;

- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
