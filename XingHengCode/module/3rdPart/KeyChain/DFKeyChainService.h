//
//  DFKeyChainService.h
//  DFace
//
//  Created by FanYuandong on 14-3-19.
//
//

#import <Foundation/Foundation.h>

@interface DFKeyChainService : NSObject
+ (void)saveUUID:(NSString *)deviceUUID;
+ (NSString *)loadUUID;
+ (void)deleteUUID;
@end
