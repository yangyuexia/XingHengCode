
//
//  QWGlobalManager.m
//  APP
//
//  Created by qw on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWGlobalManager.h"
#import "QWUserDefault.h"
#import "SVProgressHUD.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "XMPPStream.h"
#import "NotificationModel.h"
#import "NSDate+Category.h"
#import <mach/mach.h>
#import <Accelerate/Accelerate.h>
#import "NoticeModel.h"
#import "SystemModel.h"
#import "sys/utsname.h"
#import "NSString+URLEncoding.h"
#import "LoginViewController.h"

static NSString *kToken12345= @"12345";

@interface QWGlobalManager()
{
    BOOL _qwTabBarShown;
}

@end

@implementation QWGlobalManager

@synthesize deviceToken = _deviceToken;

+ (QWGlobalManager *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.deviceToken = [XMPPStream generateUUID];
        _currentNetWork = ReachableViaWWAN;
        //全局配置信息
        [self loadAppConfigure];
        
        //初始化网络监控
        self.reachabilityMonitor = [[ReachabilityMonitor alloc] initWithDelegate:self];
        [self.reachabilityMonitor startMonitoring];
        
        [self addObserverGlobal];
        self.baby = [BabyBluetooth shareBabyBluetooth];
                
    }
    return self;
}

- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

- (BOOL)isIphoneX
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //模拟器
    if ([deviceString isEqualToString:@"i386"] || [deviceString isEqualToString:@"x86_64"]) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        BOOL haveSafeInset;
        if (@available(iOS 11.0, *)) {
            CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
            haveSafeInset = (bottomSafeInset == 34.0f || bottomSafeInset == 21.0f);
        }else{
            haveSafeInset = NO;
        }
        return haveSafeInset;
    }
    
    
    BOOL isIphoneX = NO;
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"] ||[deviceString isEqualToString:@"iPhone11,8"] || [deviceString isEqualToString:@"iPhone11,2"] || [deviceString isEqualToString:@"iPhone11,6"]) {
        isIphoneX = YES;
    }
    return isIphoneX;
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

#pragma mark ---- 全局通知 ----

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

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{

}

#pragma mark ---- devicetoken ----
- (void)setDeviceToken:(NSString *)deviceToken{
    _deviceToken=deviceToken;
}

- (NSString *)deviceToken{
    NSString *token=(_deviceToken)?_deviceToken:kToken12345;
    return token;
}

#pragma mark ---- 私有数据库名称 ----
- (NSString*)getPrivateDBNameWithClass:(NSString*)cls
{
    NSString* ret = @"";
    if (self.configure) {
        if ([cls hasPrefix:@"QWQLMessage"]) {
            ret = self.configure.id;
        }
        else{
            ret = self.configure.id;
        }
    }
    return ret;
}

#pragma mark ---- 全局配置信息 ----
- (void)loadAppConfigure
{
    self.configure = [UserInfoModel getFromNsuserDefault:USER_PERSON_INFO];
    if (!self.configure) {
        self.configure = [[UserInfoModel alloc] init];
    }
}

//根据当前登陆的账号,保存配置信息
- (void)saveAppConfigure
{
    [self.configure saveToNsuserDefault:USER_PERSON_INFO];
}

#pragma mark 发出全局通知
- (NSDictionary *)postNotif:(Enum_Notification_Type)type data:(id)data object:(id)obj{
    return [super postNotif:type data:data object:obj];
}


#pragma mark -
#pragma mark ReachabilityDelegate  网络状态监控
-(void)networkDisconnectFrom:(NetworkStatus)netStatus
{
    QWGLOBALMANAGER.currentNetWork = NotReachable;
    [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
    
    //掉线
    [self postNotif:NotifNetworkDisconnect data:nil object:self];
}

- (void)networKCannotStartupWhenFinishLaunching
{
    QWGLOBALMANAGER.currentNetWork = NotReachable;
}

- (void)networkStartAtApplicationDidFinishLaunching:(NetworkStatus)netStatus
{
    QWGLOBALMANAGER.currentNetWork = netStatus;
    //重新获取地址
    [self postNotif:NotifLocationNeedReload data:nil object:self];
}

- (void)networkRestartFrom:(NetworkStatus)oldStatus toStatus:(NetworkStatus)newStatus
{
    QWGLOBALMANAGER.currentNetWork = newStatus;
    if (LOGIN && newStatus != kNotReachable)
    {
    }
    [self postNotif:NotifNetworkReconnect data:nil object:self];
}

#pragma mark -
#pragma mark  清除账户信息 退出登录
- (void)clearAccountInformation:(BOOL)kickOff
{
    QWGLOBALMANAGER.loginStatus = NO;
    [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
    [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:self];
    
    
    QWGLOBALMANAGER.configure.id = @"";
    QWGLOBALMANAGER.configure.token = @"";
    [QWGLOBALMANAGER saveAppConfigure];
    
    //抢登
    if (kickOff) {
        UINavigationController *navgationController = QWGLOBALMANAGER.tabBar.viewControllers[0];
        navgationController.tabBarItem.badgeValue = nil;
        [navgationController popToRootViewControllerAnimated:NO];
        navgationController = QWGLOBALMANAGER.tabBar.viewControllers[1];
        [navgationController popToRootViewControllerAnimated:NO];
        navgationController = QWGLOBALMANAGER.tabBar.viewControllers[2];
        [navgationController popToRootViewControllerAnimated:NO];
        QWGLOBALMANAGER.tabBar.selectedIndex = 0;
        
        
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [QWGLOBALMANAGER.tabBar presentViewController:nav animated:YES completion:nil];
        
        
    }

}

#pragma mark -
#pragma mark 登录成功调用
- (void)loginSucess
{
    HttpClientMgr.progressEnabled = NO;
    
    [self createPrivateDir];
    
    //登陆成功后拉取消息
    [self createMessageTimer];
    [self createTimerForCheckToken];
    [self getAllMessage];
    
}

#pragma mark - 对数组进行操作
- (NSUInteger)valueExists:(NSString *)key withValue:(NSString *)value withArr:(NSMutableArray *)arrOri
{
    NSPredicate *predExists = [NSPredicate predicateWithFormat:
                               @"%K MATCHES[c] %@", key, value];
    NSUInteger index = [arrOri indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [predExists evaluateWithObject:obj];
                        }];
    return index;
}

- (NSMutableArray *)sortArrWithKey:(NSString *)strKey isAscend:(BOOL)isAscend oriArray:(NSMutableArray *)oriArr
{
    NSMutableArray *arrSorted = [@[] mutableCopy];
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:strKey ascending:isAscend];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    arrSorted = [[oriArr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return arrSorted;
}

//登录成功后创建私有目录
- (void)createPrivateDir
{
//    NSString *privateName;
//    privateName = self.configure.userName;
//    
//    if(StrIsEmpty(privateName)){
//        [SVProgressHUD showErrorWithStatus:@"私有目录无法创建，可能导致语音文件无法生成"];
//    }
//    
//    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@",privateName]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if(![fileManager fileExistsAtPath:homePath]){
//        [fileManager createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    homePath = [homePath stringByAppendingString:@"/Voice"];
//    if(![fileManager fileExistsAtPath:homePath]){
//        [fileManager createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
}

#pragma mark ---- 轮训主播的登录状态 ----
- (void)pollUserStateData{
    
}

#pragma mark ------- 全量拉消息数据
- (void)getAllMessage{
    [self pollMsgBoxData];
}

- (void)pollMsgBoxData{
    if(!LOGIN){
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"UserIDGuid"] = QWGLOBALMANAGER.configure.token;
    setting[@"TypeID"] = @"1";
    setting[@"PageIndex"] = @"1";
    setting[@"PageSize"] = @"20";
    HttpClientMgr.progressEnabled = NO;
    
//    [Lottery LotteryWithBaseUrl:YINIU_BASE_URL Action:@"814" Params:setting success:^(id obj) {
//        
//        NoticePageModel *page = [NoticePageModel parse:obj Elements:[NoticeListModel class] forAttribute:@"item"];
//        if ([page.code integerValue] == 200)
//        {
//            NSArray *arr = [NSArray arrayWithArray:page.item];
//            
//            if (arr.count>0)
//            {
//                BOOL haveUnRead = NO;
//                
//                if ([NoticeListModel getArrayFromDBWithWhere:nil])
//                {
//                    NSArray *cacheArr = [NSArray arrayWithArray:[NoticeListModel getArrayFromDBWithWhere:nil]];
//                    
//                    if (cacheArr.count > 0) {
//                        for (NoticeListModel *apimodel in arr) {
//                            
//                            BOOL unread = YES;
//                            for (NoticeListModel *cacheModel in cacheArr) {
//                                if ([cacheModel.ID intValue] == [apimodel.ID intValue]) {
//                                    unread = NO;
//                                    break;
//                                }
//                            }
//                            
//                            apimodel.unread = unread;
//                            
//                            if (unread) {
//                                haveUnRead = YES;
//                                break;
//                            }
//                        }
//                    }
//                }
//                
//                
//                BOOL haveRead = YES;
//                if ([NoticeListModel getArrayFromDBWithWhere:nil])
//                {
//                    NSArray *cacheArr = [NoticeListModel getArrayFromDBWithWhere:nil];
//                    if (cacheArr.count > 0)
//                    {
//                        for (NoticeListModel *cacheModel in cacheArr) {
//                            if (cacheModel.unread) {
//                                haveRead = NO;
//                                break;
//                            }
//                        }
//                    }
//                }
//                
//            
//                if (haveUnRead || !haveRead) {
//                    QWGLOBALMANAGER.hadNewMsgBox = YES;
//                }else{
//                    QWGLOBALMANAGER.hadNewMsgBox = NO;
//                }
//            }
//        }
//    } failure:^(HttpException *e) {
//
//    }];

}

#pragma mark 开始/暂停
- (void)applicationDidEnterBackground{
    [self releaseMessageTimer];
}

/**
 *  APP 从后台进前台的回调
 */
- (void)applicationDidBecomeActive
{
    //版本更新
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"showGuide"] boolValue]){
    if (self.isForceUpdating) {
        if (self.currentNetWork == NotReachable) {
            VersionModel * vmodel = [VersionModel getFromNsuserDefault:@"Version"];
            if (vmodel != nil) {
                    [self showForceUpdateAlert:vmodel];
                } else {
                    [self checkVersion];
                }
            } else {
                [self checkVersion];
            }
        } else {
            [self checkNeedUpdate];
        }
    }
    
    [self createMessageTimer];
    [self createTimerForCheckToken];
        
}

- (void)checkNeedUpdate
{
    self.lastTimeStamp = (double)[[NSDate date] timeIntervalSince1970];//[dicReturn[@"respTime"] doubleValue];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:APP_UPDATE_AFTER_THREE_DAYS] boolValue]) {
        // 3天后提醒
        NSTimeInterval intevalLast = [[[NSUserDefaults standardUserDefaults] objectForKey:APP_LAST_TIMESTAMP] doubleValue];//3*24*60*60
        if (self.lastTimeStamp - intevalLast >= 3*24*60*60) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self checkVersion];
            self.boolLoadFromFirstIn = YES;
        }
        return ;
    } else {
        [self checkVersion];
    }
}


//消息轮训
- (void)createMessageTimer
{
    pullMessageTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(pullMessageTimer, dispatch_time(DISPATCH_TIME_NOW, 0), 10ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(pullMessageTimer, ^{
        //执行轮训的方法
//        [self pollMsgBoxData];
    });
    dispatch_resume(pullMessageTimer);
}

//校验token 账号抢登
- (void)createTimerForCheckToken
{
    CheckTokenTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(CheckTokenTimer, dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), 60ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(CheckTokenTimer, ^{
//        [self checkTokenVaild:NO];
    });
    dispatch_resume(CheckTokenTimer);
}

- (void)releaseMessageTimer
{
    if(pullMessageTimer)
    {
        dispatch_source_cancel(pullMessageTimer);
        pullMessageTimer = NULL;
    }

    if (CheckTokenTimer)
    {
        dispatch_source_cancel(CheckTokenTimer);
        CheckTokenTimer = NULL;
    }
}

- (void)getCramePrivate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"无法使用相机"message:kWaring67 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark  版本检查

//强制升级提示框
- (void)showForceUpdateAlert:(VersionModel *)model
{
    if (!self.isShowAlert) {
        if (self.isShowCustomAlert) {
        }
        model.remark = [model.remark stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        NSString *strAlertMessage = [NSString stringWithFormat:@"版本号: %@    \n%@",model.version, model.remark];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:strAlertMessage delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立即更新", nil];
        alertView.tag = 10000;
        [alertView show];
        self.isShowAlert = YES;
    }
}

//普通升级提示框
- (void)showNormalUpdateAlert:(VersionModel *)model
{
    if (!self.isShowAlert) {
        if (self.isShowCustomAlert) {
        }
        //    NSString *strAlertMessage = [NSString stringWithFormat:@"版本号: %@    大小: %@",dicUpdate[@"versionName"], dicUpdate[@"size"]];
        NSString *strAlertMessage = [NSString stringWithFormat:@"版本号: %@    ",model.version];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:strAlertMessage delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立即更新", nil];
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"customAlertView"
                                                          owner:self
                                                        options:nil];
        
        myAlertView = [nibViews objectAtIndex:0];
        
        model.remark = [model.remark stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        myAlertView.tvViewMessage.text = model.remark;
        
        //check if os version is 7 or above
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [alertView setValue:myAlertView forKey:@"accessoryView"];
        }else{
            [alertView addSubview:myAlertView];
        }
        alertView.tag = 10001;
        [alertView show];

        self.isShowAlert = YES;
    }
}

- (NSInteger)getIntValueFromVersionStr:(NSString *)strVersion
{
    NSArray *arrVer = [strVersion componentsSeparatedByString:@"."];
    NSString *strVer = [arrVer componentsJoinedByString:@""];
    NSInteger intVer = [strVer integerValue];
    return intVer;
}

- (void)clearOldCache
{
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(NSString *userDir in [fileManager contentsOfDirectoryAtPath:homePath error:nil])
    {
        [fileManager removeItemAtPath:[homePath stringByAppendingFormat:@"/%@",userDir] error:nil];
    }
    [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
}

//版本
-(NSString *)version{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

//检查版本更新
- (void)checkVersion
{
    HttpClientMgr.progressEnabled = NO;
    [System storeVersionWithParams:nil success:^(id obj) {
        NSArray *array = obj[@"results"];
        if (array.count > 0) {
            NSString * version = obj[@"results"][0][@"version"];//线上最新版本
            NSString *currentVersion= [self version];//当前用户版本
            BOOL result= [currentVersion compare:version] == NSOrderedAscending;
            if (result) {//需要更新
                //调用弹框
                VersionModel *model = [VersionModel new];
                model.remark = obj[@"results"][0][@"releaseNotes"];
                model.downLoadUrl = @"http://itunes.apple.com/cn/lookup?id=1516850507";
                model.version = version;
                installUrl = model.downLoadUrl;
                [self showNormalUpdateAlert:model];
            }
        }        
    } failure:^(HttpException *e) {
        
    }];
    
    
    
    return;
    
    if (self.boolLoadFromFirstIn) {
        self.boolLoadFromFirstIn = NO;
        return;
    }
    self.boolLoadFromFirstIn = YES;
    HttpClientMgr.progressEnabled=NO;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"version"] = APP_VERSION;
    [System SysVersionWithParams:setting success:^(id obj) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"version"]];
        dic[@"code"] = obj[@"code"];
        dic[@"message"] = obj[@"message"];
        
        VersionModel *model = [VersionModel parse:dic];
        
        if ([model.code integerValue] == 200) {
            self.boolLoadFromFirstIn = NO;
            installUrl = model.downLoadUrl;
            
            NSInteger intCurVersion = [self getIntValueFromVersionStr:APP_VERSION];
            intCurVersion = intCurVersion / 10;
            NSInteger intSysVersion = [self getIntValueFromVersionStr:model.version];
            NSInteger intLastSysVersion = [self getIntValueFromVersionStr:[[NSUserDefaults standardUserDefaults] objectForKey:APP_LAST_SYSTEM_VERSION]];
            [[NSUserDefaults standardUserDefaults] setObject:model.version forKey:APP_LAST_SYSTEM_VERSION];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (model.compel) {
                self.isForceUpdating = YES;
                [self showForceUpdateAlert:model];
                [model saveToNsuserDefault:@"Version"];
            } else {
                self.isForceUpdating = NO;
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:APP_UPDATE_AFTER_THREE_DAYS] boolValue]){
                    
                }
                else{
                    [self showNormalUpdateAlert:model];
                }
            }
        }
        
    } failure:^(HttpException *e) {
        
    }];
    
}
 
 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        self.isShowAlert = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (buttonIndex == 0) {
            exit(0);
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
        }
    } else if (alertView.tag == 10001) {
        self.isShowAlert = NO;
        if (buttonIndex == 0) {
            if (myAlertView.isClick) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:APP_UPDATE_AFTER_THREE_DAYS];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:(double)[[NSDate date] timeIntervalSince1970]] forKey:APP_LAST_TIMESTAMP];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
        }
    }
}

- (NSString *)removeSpace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark -
#pragma mark 长按保存图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(QWGLOBALMANAGER.saveImage,  self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error) {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功" duration:0.8f];
    }
}

- (NSString *)randomUUID
{
    NSString* uuid = [NSUUID UUID].UUIDString;
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuid;
}


- (UIViewController *)findBestViewController:(UIViewController*)vc{
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

- (UIViewController *)currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}

- (UIImage *)launchImage {
    
    UIImage *lauchImage  = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize  = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation  = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        viewOrientation = @"Landscape";
    } else {
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return lauchImage;
}

- (BOOL)judgePassWordLegal:(NSString*)pwd{
    BOOL result = NO;
    if (pwd.length >= 6) {
        //判断是否同时包含数字和字符
        NSString * regex = @"^([0-9]|[a-zA-Z]){6,17}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pwd];
    }
    return result;
}

- (NSString *)changeTelephone:(NSString *)teleStr{
    NSString * string = [teleStr stringByReplacingOccurrencesOfString:[teleStr substringWithRange:NSMakeRange(3,4)] withString:@"****"];
    return string;
}

- (BOOL)isValidateEmail:(NSString *)email{
    NSString *userRegexp = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";   //邮箱格式
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userRegexp];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isChinese:(NSString *)string{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {2,2};
    
    CGContextSetStrokeColorWithColor(line, RGBHex(qwColor2).CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 300, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (NSInteger)hexToTen:(NSString *)hex{
    return strtoul(hex.UTF8String, 0, 16);
}

//将十进制转换成十六进制，其中0表示成00
- (NSString *)tenToHex:(long long int)tmpid{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    //NSLog(@"16进制是：%@",str);
    //不够一个字节凑0
    if(str.length == 1){
        return [NSString stringWithFormat:@"0%@",str];
    }else{
        return str;
    }
}

//发送十六进制的Str变化成data
- (NSData *)hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    NSLog(@"hexToBytes:data:%@",data);
    return data;
}

- (NSMutableData *)convertHexStrToData:(NSString*)str{
    if(!str || [str length] ==0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    
    if([str length] %2==0) {
        range =NSMakeRange(0,2);
    }else{
        range =NSMakeRange(0,1);
    }
    
    for(NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString*hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location+= range.length;
        range.length=2;
    }
    return hexData;
    
}


- (NSString*)hexStringFromData:(NSData*)myD{
    Byte *bytes = (Byte*)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    
    for(int i=0;i<[myD length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}


- (void)getFF_FormartData:(NSString *)code{
//    NSString *code = @"20";
//    if ([QWUserDefault getObjectBy:BLETONGXUNCONFIGURE]) {
//        code = [QWUserDefault getObjectBy:BLETONGXUNCONFIGURE];
//    }
//
//    [self updateHeaderUI:1];
//
//    NSString *hexCode = [QWGLOBALMANAGER tenToHex:[code integerValue]];
//
//    NSInteger a = [QWGLOBALMANAGER hexToTen:@"16"];
//    NSInteger b = [QWGLOBALMANAGER hexToTen:@"FF"];
//    NSInteger c = [QWGLOBALMANAGER hexToTen:@"01"];
//    NSInteger d = [QWGLOBALMANAGER hexToTen:hexCode];
//    NSInteger e = a+b+c+d;
//    NSString *subHex = [QWGLOBALMANAGER tenToHex:e];
}

- (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}

/** 判断一个字符串是纯数字 */
- (BOOL)isPureNum:(NSString *)text {
    if (!text) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end

