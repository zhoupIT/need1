//
//  ZPLivingBroadcastTopCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPLectureModel;
@interface ZPLivingBroadcastTopCell : UITableViewCell
@property (nonatomic,strong) ZPLectureModel *model;
@property (nonatomic,copy) void (^moreHistoryLecturesBlock) (void);
@property (nonatomic,copy) void (^enterLectureBlock) (void);
@end
