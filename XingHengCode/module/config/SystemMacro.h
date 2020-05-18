
#ifndef Module_SystemMacro_h
#define Module_SystemMacro_h

#import "UIDevice+IdentifierAddition.h"
#import "UIDevice+Hardware.h"

//version
#define	VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define	BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define	BUILD_COUNT [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"]
#define	APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define ChANNELID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ChannelID"]
#define OS_VERSION [[UIDevice currentDevice] systemVersion]
#define DEVICE_ID [[UIDevice currentDevice] uniqueDfaceDeviceIdentifier]
#define DEVICE_MODEL [[UIDevice currentDevice] platformString]

/**
 *  单例宏方法
 *
 *  @param block
 *
 *  @return 返回单例
 */
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \


#endif


/**
 *  输出日志宏
 *
 *  @param format
 *  @param ...
 *
 *  @return
 */
//#ifdef DEBUG
#define DebugLog(format, ...) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format),  ##__VA_ARGS__] )
//#endif



#ifndef CONSOLE
   #define CONSOLE
#endif



#define checkNull(origin)           ((origin == nil)? @"":origin);


#define iOS_V               [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOSv8               (iOS_V >= 8.0)
#define iOSv7               (iOS_V >= 7)



#define myFormat(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]



