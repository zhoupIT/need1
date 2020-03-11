//
//  ZPStepModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/9/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPStepModel : NSObject
@property (nonatomic,copy) NSString *stepsDate;
//步数
@property (nonatomic,assign) NSInteger stepsCount;
//百分比
@property (nonatomic,assign) CGFloat progress;
/*
 运动里程
 女：1步=0.0006962公里
 男：1步=0.00075015公里
 里程=步数*步公里数（小数点保留两位，四舍五入）
 ≈绕操场x圈：里程*1000/400（小数点后保留1位，四舍五入）
 */
@property (nonatomic,copy) NSString *liDis;
//xx圈
@property (nonatomic,copy) NSString *circle;

/*
 1步=0.03620225卡
 消耗=步数*步数卡路里（取整数，四舍五入）
 ≈X罐可乐的热量：消耗/141.9(整数四舍五入)
 */
@property (nonatomic,assign) NSInteger calorie;
//xx罐
@property (nonatomic,assign) NSInteger cocoNums;

@end

NS_ASSUME_NONNULL_END
