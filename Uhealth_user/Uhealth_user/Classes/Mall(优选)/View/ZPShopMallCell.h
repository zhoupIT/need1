//
//  ZPShopMallCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPCommodity;
@interface ZPShopMallCell : UICollectionViewCell
@property (nonatomic,strong) ZPCommodity *model;
@end

NS_ASSUME_NONNULL_END
