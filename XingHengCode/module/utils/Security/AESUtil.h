//
//  AESUtil.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

//  使用方法及其相关秘钥
//  1、引入头文件
//      #import "AESUtil.h"
//      #define AES_KEY @"Ao6IFeRFTsXuaD681snWCk" //key可修改
//  2、使用方法
//      //加密
//      NSString *output = [AESUtil encryptAESData:@"123456" app_key:AES_KEY];
//      NSLog(@"加密后的字符串 :%@",output);
//      解密
//      NSString *string1 = [AESUtil decryptAESData:output app_key:AES_KEY];


#import <Foundation/Foundation.h>

@interface  AESUtil:NSObject

#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key ;
//将带密码的data转成string
+(NSString*)decryptAESData:(NSString*)data app_key:(NSString*)key ;


@end
