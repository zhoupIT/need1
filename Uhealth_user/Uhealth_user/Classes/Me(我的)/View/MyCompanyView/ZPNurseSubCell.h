//
//  ZPNurseSubCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPNurseModel;
@interface ZPNurseSubCell : UICollectionViewCell
@property (nonatomic,strong) ZPNurseModel *model;
@property (nonatomic,copy) void (^contactNurseBlock) (ZPNurseModel *model);
@end
