//
//  AppDelegate.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpClient.h"
#import "XMPPStream.h"
#import "NotificationModel.h"
#import "SVProgressHUD.h"
#import "SystemModel.h"
#import "IndexApi.h"
#import "IndexModel.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


@synthesize window;
AppDelegate *app = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setTranslucent:NO];
    
    self.application = application;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    //talking
    QWGLOBALMANAGER.isLoadH5=NO;
    [self addObserverGlobal];
    
    [QWUserDefault setNumber:[NSNumber numberWithLongLong:0] key:SERVER_TIME];
    
#pragma mark 推送通知
    self.isFromApplePush = NO;
    self.dicNotice = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    [QWGLOBALMANAGER getAllMessage];
    
    [self initforLaunch];
    
    return YES;
}


- (void)initforLaunch
{
    app = self;
    
    self.deviceToken = @"";
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initBar];
    
}

- (void)initBar
{
    
    //初始化界面
    [self initNavigationBarStyle];
    
    //推送跳转
    if (self.dicNotice) {
        self.isFromApplePush = YES;
        [self application:self.application didReceiveRemoteNotification:self.dicNotice];
    }
    
    [self initTabBar];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    QWGLOBALMANAGER.boolLoadFromFirstIn = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [QWGLOBALMANAGER applicationDidEnterBackground ];
    [QWGLOBALMANAGER postNotif:NotifAppDidEnterBackground data:nil object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [QWGLOBALMANAGER postNotif:NotifAppWillEnterForeground data:nil object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [QWGLOBALMANAGER postNotif:NotifAppDidBecomeActive data:nil object:nil];
    [QWGLOBALMANAGER applicationDidBecomeActive];
    [QWUserDefault setNumber:[NSNumber numberWithLongLong:0] key:SERVER_TIME];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark ---- 初始化导航栏样式 ----
- (void)initNavigationBarStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:RGBHex(qwColor5)];//导航栏颜色
    [[UINavigationBar appearance] setTintColor:RGBHex(qwColor1)];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:RGBHex(qwColor1)}];
    
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:RGBHex(qwColor5)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[self imageWithColor:RGBHex(qwColor14)]];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);//导航栏颜色
    CGContextFillRect(context, rect);
    UIImage * imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imge;
}

#pragma mark ---- 初始化tab标签样式 ----
- (void)initTabBar
{
    QWGLOBALMANAGER.tabBar = [[QWTabBar alloc] initWithDelegate:self];
    self.window.rootViewController = QWGLOBALMANAGER.tabBar;
    
    if (LOGIN && [QWUserDefault getBoolBy:ISAUTOLOGIN]) {
        
    }else {
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [QWGLOBALMANAGER.tabBar presentViewController:nav animated:YES completion:nil];
    }
    
    [QWGLOBALMANAGER postNotif:NotifAppCheckVersion data:nil object:nil];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif




#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{
    
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([GLOBALMANAGER object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}

#pragma mark 全局通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (type == NotifAppCheckVersion) {
        [QWGLOBALMANAGER checkVersion];
    }
}


@end
