//
//  ZPPsychologicalAssessmentInfoSelCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPPsyModel.h"
#import "ZPPsyAssessmentModel.h"
@interface ZPPsychologicalAssessmentInfoSelCell : UITableViewCell
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) ZPPsyModel *model;
@property (nonatomic,strong) ZPPsyAssessmentModel *retireModel;
@property (nonatomic,strong) ZPPsyAssessmentModel *psyModel;
@property (nonatomic,copy) void (^selBlock) (UIButton *btn);
@property (nonatomic,copy) void (^selGenderBlock) (UIButton *btn);
@end
