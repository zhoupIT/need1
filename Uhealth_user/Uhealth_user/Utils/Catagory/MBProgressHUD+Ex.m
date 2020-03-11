//
//  MBProgressHUD+Ex.m
//
//  Created by itcast on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Ex.h"

@implementation MBProgressHUD (Ex)
#pragma mark 显示信息
+ (void)show:(NSString*)text icon:(NSString*)icon view:(UIView*)view
{
    if (view == nil)
//        view = [[UIApplication sharedApplication].windows lastObject];
        view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString*)error toView:(UIView*)view
{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString*)success toView:(UIView*)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD*)showMessage:(NSString*)message toView:(UIView*)view
{
    if (view == nil)
//        view = [[UIApplication sharedApplication].windows lastObject];
       view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    
//    UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    images.image = [UIImage imageNamed:@"loading_1"];
//    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    anima.toValue = @(M_PI*2);
//    anima.duration = 1.0f;
//    anima.repeatCount = MAXFLOAT;
//    [images.layer addAnimation:anima forKey:nil];
//    
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.customView = images;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString*)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString*)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD*)showMessage:(NSString*)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView*)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:[UIApplication sharedApplication].keyWindow];
}
@end
