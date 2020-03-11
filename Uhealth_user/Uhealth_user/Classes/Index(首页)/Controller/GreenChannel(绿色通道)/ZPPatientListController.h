//
//  ZPPatientListController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ZPPatientListModel;
@interface ZPPatientListController : ZPRootViewController
@property (nonatomic,copy) void (^selectedPatientBlock) (ZPPatientListModel *model);
@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
