//
//  ZPButton.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPButton : UIButton
//设置文字渐变色
- (void)setGradientColors:(NSArray<UIColor *> *)colors;

//设置背景渐变色
- (void)setBackgroundGradientColors:(NSArray<UIColor *> *)colors;
@end

NS_ASSUME_NONNULL_END
