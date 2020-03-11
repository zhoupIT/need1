//
//  ZPReservationView.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPTextView.h"
NS_ASSUME_NONNULL_BEGIN
@class ZPPriceModel,ZPPatientListModel;
@interface ZPReservationView : UIView
@property (nonatomic,strong) ZPTextView *descTextView;
@property (nonatomic,copy) void (^commitAppointmentBlock) (void);
@property (nonatomic,copy) void (^addPerBlock) (void);
@property (nonatomic,copy) void (^deleteBlock) (void);
@property (nonatomic,copy) void (^callBlock) (void);

@property (nonatomic,strong) ZPPriceModel *model;
@property (nonatomic,strong) ZPImg *processImage;

- (void)updateUIWithModel:(ZPPatientListModel *)model;
@end

NS_ASSUME_NONNULL_END
