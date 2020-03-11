//
//  ZPWelcomeController.h
//  uhealth
//
//  Created by Biao Geng on 2018/4/18.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPWelcomeController : UIViewController
/**
 * 创建一个引导页
 * @param  welcomeImages 引导页的图片数组
 * @param  VC 引导页之后的第一个视图控制器
 * @return  VC视图控制器
 */
-(instancetype)initWelcomeView:(NSArray *)welcomeImages firstVC:(UIViewController *)VC;
@end
