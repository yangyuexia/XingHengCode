/*!
 @header QWConfig.h
 @abstract 处理系统调试的配置文件
 @author .
 @version 1.00 2015/03/06  (1.00)
 */

#ifndef APP_QWConfig_h
#define APP_QWConfig_h

#ifndef CONSOLE
#define CONSOLE
#endif

//TODO: !!!remove log for release
//#ifdef DEBUG
#define DebugLog(format, ...) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format),  ##__VA_ARGS__] )
//#endif
//#define DebugLog(format, ...)
#endif
