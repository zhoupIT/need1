//
//  ZPAddPatientController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPatientListModel;
@interface ZPAddPatientController : ZPRootViewController
@property (nonatomic,copy) void (^addSuceesBlock) (void);
@property (nonatomic,copy) void (^updateSuceesBlock) (void);
@property (nonatomic,strong) ZPPatientListModel *model;
@end
