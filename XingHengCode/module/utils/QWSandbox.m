//
//  QWSandbox.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWSandbox.h"

@interface QWSandbox()
{
    NSString *    _appPath;
    NSString *    _docPath;
    NSString *    _libPrefPath;
    NSString *    _libCachePath;
    NSString *    _tmpPath;
}

- (BOOL)remove:(NSString *)path;
- (BOOL)touch:(NSString *)path;
- (BOOL)touchFile:(NSString *)path;

@end

#pragma mark -

@implementation QWSandbox



@dynamic appPath;
@dynamic docPath;
@dynamic libPrefPath;
@dynamic libCachePath;
@dynamic tmpPath;
+ (QWSandbox *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}
+ (NSString *)appPath
{
    return [[QWSandbox sharedInstance] appPath];
}

- (NSString *)appPath
{
    if ( nil == _appPath )
    {
        NSString * exeName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
        NSString * appPath = [[NSHomeDirectory() stringByAppendingPathComponent:exeName] stringByAppendingPathExtension:@"app"];
        
        _appPath = [appPath copy];
    }
    
    return _appPath;
}

+ (NSString *)docPath
{
    return [[QWSandbox sharedInstance] docPath];
}

- (NSString *)docPath
{
    if ( nil == _docPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _docPath = [[paths objectAtIndex:0] copy];
    }
    
    return _docPath;
}

+ (NSString *)libPrefPath
{
    return [[QWSandbox sharedInstance] libPrefPath];
}

- (NSString *)libPrefPath
{
    if ( nil == _libPrefPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
        
        [self touch:path];
        
        _libPrefPath = [path copy];
    }
    
    return _libPrefPath;
}

+ (NSString *)libCachePath
{
    return [[QWSandbox sharedInstance] libCachePath];
}

- (NSString *)libCachePath
{
    if ( nil == _libCachePath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
        
        [self touch:path];
        
        _libCachePath = [path copy];
    }
    
    return _libCachePath;
}

+ (NSString *)tmpPath
{
    return [[QWSandbox sharedInstance] tmpPath];
}

- (NSString *)tmpPath
{
    if ( nil == _tmpPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
        
        [self touch:path];
        
        _tmpPath = [path copy];
    }
    
    return _tmpPath;
}

+ (BOOL)remove:(NSString *)path
{
    return [[QWSandbox sharedInstance] remove:path];
}

- (BOOL)remove:(NSString *)path
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (BOOL)touch:(NSString *)path
{
    return [[QWSandbox sharedInstance] touch:path];
}

- (BOOL)touch:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

+ (BOOL)touchFile:(NSString *)file
{
    return [[QWSandbox sharedInstance] touchFile:file];
}

- (BOOL)touchFile:(NSString *)file
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    
    return YES;
}

@end



