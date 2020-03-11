//
//  ZPFeatureItemCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPFeatureContentModel;
@interface ZPFeatureItemCell : UICollectionViewCell
@property (nonatomic,strong) ZPFeatureContentModel *contentModel;
@end

NS_ASSUME_NONNULL_END
