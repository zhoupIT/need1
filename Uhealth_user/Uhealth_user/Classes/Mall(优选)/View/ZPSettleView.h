//
//  ZPSettleView.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPSettleView : UIView
+ (instancetype)addSettleView;
@property (strong, nonatomic) IBOutlet UIButton *selectAllButton;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *settleButton;
@property (strong, nonatomic) IBOutlet UILabel *tiplabel;

@property (nonatomic,copy) void (^selectAllBlock) (UIButton *btn);
@property (nonatomic,copy) void (^settleBlock) (UIButton *btn);

@end
