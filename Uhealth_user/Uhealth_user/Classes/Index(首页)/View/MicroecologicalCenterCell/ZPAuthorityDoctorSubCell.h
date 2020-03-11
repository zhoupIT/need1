//
//  ZPAuthorityDoctorSubCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPChannelDoctorModel;
@interface ZPAuthorityDoctorSubCell : UITableViewCell
@property (nonatomic,strong) ZPChannelDoctorModel *model;
@property (nonatomic,assign) NSInteger index;
@end
