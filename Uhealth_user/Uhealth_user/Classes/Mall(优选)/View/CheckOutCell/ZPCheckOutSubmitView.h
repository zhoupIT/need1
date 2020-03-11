//
//  ZPCheckOutSubmitView.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPCheckOutSubmitView : UIView
+ (instancetype)addSubmitView;
@property (nonatomic,copy) void (^submitBlock) (UIButton *btn);
@property (strong, nonatomic) IBOutlet UILabel *presentPriceLabel;

@end
