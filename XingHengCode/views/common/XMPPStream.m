//
//  XMPPStream.m
//  APP
//
//  Created by garfield on 15/7/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "XMPPStream.h"

@implementation XMPPStream

+ (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}


@end
