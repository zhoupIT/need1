//
//  XBTimerManager.h
//  WYFX
//
//  Created by 周旭斌 on 2017/8/31.
//  Copyright © 2017年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singleton.h"

@interface XBTimerManager : NSObject

/**
 评定总时间
 */
@property (nonatomic, assign, readonly) long long totalTimerInterval;
/**
 赛事列表总运行的时间
 */
@property (nonatomic, assign, readonly) long long totalGameListTimeInterval;
/**
 总共剩下的时间
 */
@property (nonatomic, assign) long long totalLeaveTime;

ZPSingletonH(XBTimerManager)

// 评定计时器
- (void)startTimer;
- (void)startGcdTimer:(NSInteger)timeout;
- (void)stopGcdTimer;
- (void)pauseTimer;
- (void)stopTimer;

// 首页赛事倒计时
- (void)startGameTimer;
- (void)stopGameTimer;

@end
