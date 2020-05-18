//
//  YYXError.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYXErrorDefines.h"

@interface YYXError : NSObject

@property (nonatomic) NSInteger errorCode;

@property (nonatomic, copy) NSString *Edescription;

+ (YYXError *)errorWithCode:(QWErrorType)errCode
            andDescription:(NSString *)description;

+ (YYXError *)errorWithNSError:(NSError *)error;

@end
