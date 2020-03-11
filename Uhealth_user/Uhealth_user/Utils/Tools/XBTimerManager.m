//
//  XBTimerManager.m
//  WYFX
//
//  Created by 周旭斌 on 2017/8/31.
//  Copyright © 2017年 周旭斌. All rights reserved.
//

#import "XBTimerManager.h"

@interface XBTimerManager ()

/**
 评定计时器
 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,strong) dispatch_source_t gcdtimer;
@property (nonatomic,strong) dispatch_queue_t queue;
/**
 赛事计时器
 */
@property (nonatomic, strong) NSTimer *gameTimer;

@end

@implementation XBTimerManager

ZPSingletonM(XBTimerManager)

- (void)startGcdTimer:(NSInteger)timeout {
    __block NSInteger time  = timeout;
    if (_gcdtimer) {
        [self recoverGcdData];
    }
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _gcdtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    dispatch_source_set_timer(_gcdtimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
    dispatch_source_set_event_handler(_gcdtimer, ^{
        if(time <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
            dispatch_source_cancel(_gcdtimer);
            _gcdtimer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                ZPLog(@"您可以进入讲堂了");
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTimeEnd object:nil];
            });
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTimeOut object:@(time)];
            time--;
        }
    });
    dispatch_resume(_gcdtimer);
}

- (void)startTimer {
    if (_timer) {
        [self recoverData];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
}

- (void)pauseTimer {
    
}

- (void)stopTimer {
    [self recoverData];
}

- (void)timer:(NSTimer *)timer {
    _totalTimerInterval++;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTimeOut object:@(_totalTimerInterval)];
    ZPLog(@"%s", __func__);
}

- (void)recoverData {
    [_timer invalidate];
    _timer = nil;
    _totalTimerInterval = 0;
}

- (void)recoverGcdData {
     dispatch_source_cancel(_gcdtimer);
    _gcdtimer = nil;
    _totalTimerInterval = 0;
}

// 赛事列表计时器
- (void)startGameTimer {
    if (_gameTimer) {
        return;
    }
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameTimer:) userInfo:nil repeats:YES];
}

- (void)gameTimer:(NSTimer *)timer {
    _totalGameListTimeInterval++;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTimeOut object:@(_totalLeaveTime - _totalGameListTimeInterval)];
    ZPLog(@"%s===%lld", __func__, _totalGameListTimeInterval);
//    if ((_totalLeaveTime - _totalGameListTimeInterval) > 0) { // 大于0说明比赛还没开始
//    }else {
//        [timer invalidate];
//        timer = nil;
//        [XBNotificationCenter postNotificationName:KGAMETIMENOTIFICATION object:@0];
//    }
}

- (void)stopGameTimer {
    [_gameTimer invalidate];
    _gameTimer = nil;
    _totalGameListTimeInterval = 0;
    _totalLeaveTime = 0;
}


- (void)stopGcdTimer {
    if (_gcdtimer) {
        dispatch_source_cancel(_gcdtimer);
        _gcdtimer = nil;
        _totalTimerInterval = 0;
    }
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
