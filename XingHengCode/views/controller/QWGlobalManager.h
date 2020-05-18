//
//  QWGlobalManager.h
//  APP
//
//  Created by qw on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "userDefault.h"
#import "ReachabilityMonitor.h"
#import "GlobalManager.h"
#import "UserInfoModel.h"
#import "QWTabBar.h"
#import "HttpClient.h"
#import "customAlertView.h"
#import "CocoaLumberjack.h"
#import "Countdown.h"
#import "IndexModel.h"
#import "SystemModel.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"


//全局管理对象
#define  QWGLOBALMANAGER [QWGlobalManager sharedInstance]

typedef struct RedPoint RedPoint;


@interface QWGlobalManager : GlobalManager <ReachabilityDelegate, UIAlertViewDelegate,UIActionSheetDelegate>
{
    dispatch_source_t   pullMessageTimer;
    dispatch_source_t   CheckTokenTimer;
    
    // 版本更新
    customAlertView *myAlertView;
    
    NSTimeInterval lastTimeStamp;
    NSString * installUrl;
}

@property (strong, nonatomic) BabyBluetooth *baby;
@property (strong, nonatomic) NSString * installUrl;


//版本更新
@property (nonatomic, assign) BOOL isForceUpdating;
@property (nonatomic, strong) NSDictionary *dicForceUpdated;
@property (nonatomic, assign) NSTimeInterval lastTimeStamp;
@property (nonatomic, assign) BOOL boolLoadFromFirstIn;

@property (nonatomic, assign) BOOL                      loginStatus;                    //登陆状态
@property (nonatomic, strong) UserInfoModel             *configure;                     //全局配置
@property (nonatomic, assign) NetworkStatus             currentNetWork;                 //当前的网络状态
@property (nonatomic, strong) NSString                  *deviceToken;                   //令牌
@property (nonatomic, strong) QWTabBar                  *tabBar;                        //底部tab标签
@property (nonatomic, strong) ReachabilityMonitor       *reachabilityMonitor;           //网络监控
@property (nonatomic, strong) UIImage                   *saveImage;                     //长按保存图片

@property (nonatomic, assign) NSInteger                 unReadCount;                        //未读数

@property (nonatomic, strong) DDFileLogger              *fileLogger;

@property (nonatomic, assign) BOOL                      isShowAlert;
@property (nonatomic, assign) BOOL                      isShowCustomAlert;

@property (nonatomic, assign) BOOL isLoadH5;

@property (assign, nonatomic) BOOL hadNewMsgBox;

@property (assign, nonatomic) BOOL isShowAppLaunch;


- (void)getAllMessage;

+ (QWGlobalManager *)sharedInstance;
- (void)getCramePrivate;


//保存全局设置
- (void)saveAppConfigure;
- (void)clearOldCache;

//获取私有数据库的名称 业务无需关心此处
- (NSString*)getPrivateDBNameWithClass:(NSString*)cls;

/**
 *  发出全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param obj  通知来源对象，填self
 */
- (NSDictionary *)postNotif:(Enum_Notification_Type)type data:(id)data object:(id)obj;

- (void)checkVersion;

- (void)releaseMessageTimer;

//清除账户信息 退出登录
- (void)clearAccountInformation:(BOOL)kickOff;
//登录成功地回调
- (void)loginSucess;
- (void)applicationDidBecomeActive;
- (void)applicationDidEnterBackground;
/**
 *  @brief 去掉字符串中得空格
 *
 *  @param string 原字符串
 
 *
 *  @return 去掉空格之后的新字符串
 */
- (NSString *)removeSpace:(NSString *)string;

/* 获取一个随机的32位UUID
 * add By martin
 */
- (NSString*)randomUUID;

- (NSString*)deviceVersion;

- (UIImage *)launchImage;
- (UIViewController *)currentViewController;

//强制升级提示框
- (void)showForceUpdateAlert:(VersionModel *)model;

//普通升级提示框
- (void)showNormalUpdateAlert:(VersionModel *)model;

- (BOOL)isIphoneX;

- (BOOL)judgePassWordLegal:(NSString*)pwd;
- (NSString *)changeTelephone:(NSString *)teleStr;
- (BOOL)isValidateEmail:(NSString *)email;
- (BOOL)isChinese:(NSString *)string;

- (UIImage *)drawLineByImageView:(UIImageView *)imageView;

//求累加和(校验和)(CHECKSUM)的求法
- (NSData *)getCheckSum:(NSData *)byteStr;

- (NSInteger)hexToTen:(NSString *)hex;

//将十进制转换成十六进制，其中0表示成00
- (NSString *)tenToHex:(long long int)tmpid;

//发送十六进制的Str变化成data
- (NSData *)hexToBytes:(NSString *)str;


- (NSMutableData *)convertHexStrToData:(NSString*)str;

//解析蓝牙数据
- (NSString*)hexStringFromData:(NSData*)myD;

- (void)addShadowToView:(UIView *)view
        withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius;

- (BOOL)isPureNum:(NSString *)text;

@end
