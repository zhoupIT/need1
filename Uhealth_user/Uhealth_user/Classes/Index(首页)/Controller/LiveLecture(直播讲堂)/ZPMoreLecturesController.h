//
//  ZPMoreLecturesController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZPMoreLecturesController : ZPRootViewController
@property (nonatomic,assign) BOOL allLecture;//是否是全部讲座
@property (nonatomic,copy) NSString *doctorId;
@property (nonatomic,copy) NSString *toplectureId;
@end
