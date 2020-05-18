/*!
 @header QWSystemMacro.h
 @abstract 存储所用到的系统宏
 @author .
 @version 1.00 2015/03/06  (1.00)
 */

#import "Constant.h"
#ifndef Module_SystemMacro_h
#define Module_SystemMacro_h

#import "UIDevice+IdentifierAddition.h"
#import "UIDevice+Hardware.h"

#define	APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//version
#define	VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define	BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define	BUILD_COUNT [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"]

#define ChANNELID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ChannelID"]

#define DEVICE_ID [[UIDevice currentDevice] uniqueDfaceDeviceIdentifier]
#define DEVICE_MODEL [[UIDevice currentDevice] platformString]

#define OS_VERSION [[UIDevice currentDevice] systemVersion]
//版本识别宏
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kUserDefaultsCookie   @"kUserDefaultsCookie"
#define kUserDefaultsIdLogin  @"kUserDefaultsIdLogin"


#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \


#endif

#define APPDelegate     ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define checkNull(origin)           ((origin == nil)? @"":origin);

#define TAG_BASE            100000
#define iOSv8               (iOS_V >= 8.0)
#define iOSv9               (iOS_V >= 9.0)

#define PORID_IMAGE(proId) (((NSString *)proId).length == 6)? [NSString stringWithFormat:@"%@middle/%@/%@/%@/1.JPG",IMAGE_PRFIX,[proId substringWithRange:NSMakeRange(0, 2)],[proId substringWithRange:NSMakeRange(2, 2)],[proId substringWithRange:NSMakeRange(4, 2)]] : @""

#define myFormat(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]

#define iOS_V               [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOSv7               (iOS_V >= 7)
#define iOSLowV7            (iOS_V < 7.090000)

#define RECT(x,y,w,h)       CGRectMake(x,y,w,h)
#define NAV_H               44
#define TAB_H               49
#define APP_W               [UIScreen mainScreen].bounds.size.width
#define APP_H               [UIScreen mainScreen].applicationFrame.size.height
#define SCREEN_W            [UIScreen mainScreen].bounds.size.width
#define SCREEN_H            [UIScreen mainScreen].bounds.size.height
#define STATUS_H            [UIApplication sharedApplication].statusBarFrame.size.height

