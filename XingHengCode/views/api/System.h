//
//  System.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/27.
//  Copyright © 2017年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

@interface System : NSObject

/**
 *     获取可升级的版本信息
 *
 */
+ (void)SysVersionWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure;



//星恒


/**
 *     查询个人信息
 *
 */
+ (void)CtmInfoWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure;

/**
 *     账号密码登陆
 *
 */
+ (void)LoginInfoWithParams:(NSDictionary *)param
                    success:(void(^)(id obj))success
                    failure:(void(^)(HttpException * e))failure;

/**
 *     注册
 *
 */
+ (void)CtmRegisterWithParams:(NSDictionary *)param
                    success:(void(^)(id obj))success
                    failure:(void(^)(HttpException * e))failure;


/**
 *     激活注册用户
 *
 */
+ (void)CtmActivateWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;


/**
 *     检测用户信息（忘记密码）
 *
 */
+ (void)CtmForgetPwdCheckWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;


/**
 *     修改忘记密码
 *
 */
+ (void)CtmChangePwdWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;


/**
 *     修改个人信息
 *
 */
+ (void)CtmUpdateWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;


/**
 *     修改密码
 *
 */
+ (void)CtmChangePToWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

/**
 *     子账号列表
 *
 */
+ (void)CtmSubListWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

/**
 *     子账号修改
 *
 */
+ (void)CtmSubUpdateWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

/**
 *     子账号新增
 *
 */
+ (void)CtmSubAddWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

/**
 *     子账号修改密码
 *
 */
+ (void)CtmSubChangePwdWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

/**
 *     子账号删除
 *
 */
+ (void)CtmSubDeleteWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

@end
