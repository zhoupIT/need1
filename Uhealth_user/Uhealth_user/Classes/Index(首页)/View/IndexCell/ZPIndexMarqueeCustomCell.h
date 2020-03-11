//
//  ZPIndexMarqueeCustomCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPHealthDynamicModel;
@interface ZPIndexMarqueeCustomCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *circle;
@property (nonatomic,strong) ZPHealthDynamicModel *model;
@end

NS_ASSUME_NONNULL_END
