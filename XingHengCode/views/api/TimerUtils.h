//
//  TimerUtils.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/27.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  TIMER [TimerUtils instance]

@interface TimerUtils : NSObject

+ (instancetype)instance;

#pragma mark - 延迟执行
- (void)timerAfter:(dispatch_source_t)timerPL timeDelay:(CGFloat)timeDelay
        blockAfter:(dispatch_block_t)blockAfter;

#pragma mark - 立即循环
- (dispatch_source_t)timerLoop:(dispatch_source_t)timerPL timeInterval:(CGFloat)timeInterval
                     blockLoop:(dispatch_block_t)blockLoop blockStop:(dispatch_block_t)blockStop;

#pragma mark - 结束
- (dispatch_source_t)timerClose:(dispatch_source_t)timerPL;

#pragma mark - 是否暂停
- (void)timerSuspend:(dispatch_source_t)timerPL enabled:(BOOL)enabled;
@end
