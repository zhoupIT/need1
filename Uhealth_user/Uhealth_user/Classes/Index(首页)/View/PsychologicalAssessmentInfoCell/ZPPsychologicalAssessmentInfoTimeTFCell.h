//
//  ZPPsychologicalAssessmentInfoTimeTFCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPsychologicalAssessmentInfoTimeTFCell : UITableViewCell
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) void (^updateTime) (NSString *newTime);
@end
