//
//  YYXError.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "YYXError.h"

@implementation YYXError

+ (YYXError *)errorWithCode:(QWErrorType)errCode
            andDescription:(NSString *)description{
    YYXError *error = [[YYXError alloc]init];
    return error;
}

+ (YYXError *)errorWithNSError:(NSError *)error{
    YYXError *error1 = [[YYXError alloc]init];
    return error1;
}

@end
