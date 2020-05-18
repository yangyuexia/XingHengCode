//
//  DFKeyChainService.m
//  DFace
//
//  Created by FanYuandong on 14-3-19.
//
//

#import "DFKeyChainService.h"
#import <Security/Security.h>

#define DF_UUID_KEY @"DF_UUID_KEY"

@implementation DFKeyChainService

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    
    unsigned long t = SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (t == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
            
        }

    } else {
        NSLog(@"hehehe is %ld",t);
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}  

#pragma mark - public methods
+ (void)saveUUID:(NSString *)deviceUUID
{
    NSMutableDictionary *uuidDict = [NSMutableDictionary dictionary];
    [uuidDict setObject:deviceUUID forKey:DF_UUID_KEY];
    [self save:DF_UUID_KEY data:uuidDict];
}

+ (NSString *)loadUUID
{
    NSMutableDictionary *uuidDict = (NSMutableDictionary *)[self load:DF_UUID_KEY];
    NSString *retUUID = [uuidDict objectForKey:DF_UUID_KEY];
    if (retUUID && retUUID.length) {
        return retUUID;
    }
    return nil;
}

+ (void)deleteUUID
{
    [self delete:DF_UUID_KEY];
}
@end
