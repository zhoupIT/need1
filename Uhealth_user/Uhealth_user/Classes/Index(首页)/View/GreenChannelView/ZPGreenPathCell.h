//
//  ZPGreenPathCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPGreenPathCell : UITableViewCell
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *titleBtnStr;
@property (nonatomic,copy) NSString *titleBtnImgStr;
@property (nonatomic,copy) void (^btnDidClickBlock) (UIButton *btn);
@end

NS_ASSUME_NONNULL_END
