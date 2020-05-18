//
//  AppDelegate.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexModel.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong) NSString *                deviceToken;

@property (nonatomic ,assign) BOOL                      isFromApplePush;
@property (nonatomic, strong) NSDictionary *            dicNotice;

@property (nonatomic, strong) UIApplication *           application;

- (void)initTabBar;

- (void)customPushNotificationWihtInfo:(NSString *)json canJump:(BOOL)canJump;

@end

