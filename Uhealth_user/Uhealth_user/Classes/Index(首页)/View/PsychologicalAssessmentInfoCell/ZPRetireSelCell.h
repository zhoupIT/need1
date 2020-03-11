//
//  ZPRetireSelCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPPsyModel.h"
#import "ZPPsyAssessmentModel.h"
@interface ZPRetireSelCell : UITableViewCell
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) void (^selBlock) (UIButton *btn);
@property (nonatomic,strong) ZPPsyModel *model;
@property (nonatomic,strong) ZPPsyAssessmentModel *psyModel;
@end
