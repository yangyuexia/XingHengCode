//
//  TimerUtils.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/27.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "TimerUtils.h"

//static NSInteger instanceNum = 0;

@interface TimerUtils()
{
    dispatch_queue_t queueTimer;
}
@end

@implementation TimerUtils

+ (instancetype)instance{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init{
    if (self = [super init]) {
        //        NSString *queueID = [NSString stringWithFormat:@"kTimerPolling[%d]", instanceNum++];
        //        queueTimer = dispatch_queue_create([queueID UTF8String], NULL);
        //并行队列
        queueTimer = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

#pragma mark - 延迟执行
- (void)timerAfter:(dispatch_source_t)timerPL timeDelay:(CGFloat)timeDelay
        blockAfter:(dispatch_block_t)blockAfter {
    [self timerClose:timerPL];
    
    //延迟
    timeDelay=(timeDelay>=0)?timeDelay:0;
    uint64_t delay = (uint64_t)(timeDelay * (double)NSEC_PER_SEC);
    //    uint64_t delay = timeDelay * NSEC_PER_SEC;
    
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = queueTimer;//dispatch_queue_create("kTimerPolling", 0);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay);
    
    dispatch_after(popTime, queue, blockAfter);
}

#pragma mark - 立即循环
- (dispatch_source_t)timerLoop:(dispatch_source_t)timerPL timeInterval:(CGFloat)timeInterval
                     blockLoop:(dispatch_block_t)blockLoop blockStop:(dispatch_block_t)blockStop{
    [self timerClose:timerPL];
    
    //间隔
    if (timeInterval<=0)
        return nil;
    uint64_t interval = (uint64_t)(timeInterval * (double)NSEC_PER_SEC);
    //    uint64_t interval = timeInterval * NSEC_PER_SEC;
    
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = queueTimer;//dispatch_queue_create("kTimerPolling", 0);
    
    //创建Timer
    dispatch_source_t tt = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //使用dispatch_source_set_timer函数设置timer参数，dispatch_time设置开始时间，间隔，精度（最高0）
    dispatch_source_set_timer(tt, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    
    //设置回调
    dispatch_source_set_event_handler(tt, blockLoop);
    
    //设置停止回调
    dispatch_source_set_cancel_handler(tt, blockStop);
    
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    dispatch_resume(tt);
    
    return tt;
}

#pragma mark - 结束
- (dispatch_source_t)timerClose:(dispatch_source_t)timerPL{
    if (timerPL) {
        dispatch_source_cancel(timerPL);
        timerPL = NULL;
    }
    return timerPL;
}

#pragma mark - 是否暂停
- (void)timerSuspend:(dispatch_source_t)timerPL enabled:(BOOL)enabled{
    if (timerPL) {
        if (enabled) {
            dispatch_suspend(timerPL);
        }
        else {
            dispatch_resume(timerPL);
        }
    }
}
@end
