//
//  ZPOrderDetailImageFootView.h
//  ZPealth
//
//  Created by Biao Geng on 2018/7/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPOrderDetailImageFootView : UIView
@property (nonatomic , copy ) void (^updateHeightBlock)(ZPOrderDetailImageFootView *view); //更新高度Block
@end
