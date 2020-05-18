//
//  QWLoading.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  QWLOADING [QWLoading instance]

@protocol QWLoadingDelegate;

@interface QWLoading : UIView

@property (assign) id delegate;
@property (assign) float minShowTime;

+ (instancetype)instance;
+ (instancetype)instanceWithDelegate:(id)delegate;

- (void)showLoading;
- (void)removeLoading;

//立刻去掉loading，无延时
- (void)closeLoading;

@end

@protocol QWLoadingDelegate <NSObject>

@optional
- (void)hudStopByTouch:(id)hud;

@end

