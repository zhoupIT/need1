//
//  ZPUserHeaderView.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPUserModel;
@interface ZPUserHeaderView : UIView

@property (nonatomic, copy) void(^aboutBlock)(void);
@property (nonatomic,copy) void (^perosonalInfoBlock)(void);
@property (nonatomic, copy) void(^collectionGoodBlock)(void);
@property (nonatomic, copy) void(^collectionStoreBlock)(void);
@property (nonatomic,copy) void (^loginBlock) (void);


+ (instancetype)headerView;
@property (nonatomic,strong) ZPUserModel *model;
@end
