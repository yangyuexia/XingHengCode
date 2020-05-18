//
//  IndexApi.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/24.
//  Copyright © 2017年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

@interface IndexApi : NSObject


/**
 *     查询电池信息
 *
 */
+ (void)EqpInfoWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;


/**
 *     故障数据列表
 *
 */
+ (void)EqpAbnormalWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure;

/**
 *     正常数据列表
 *
 */
+ (void)EqpNormalWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure;

/**
 *     电池故障诊断
 *
 */
+ (void)DrsInfoWithParams:(NSDictionary *)param
                    success:(void(^)(id obj))success
                    failure:(void(^)(HttpException * e))failure;

/**
 *     检测结果提交
 *
 */
+ (void)EqpDetectionResultWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure;

/**
 *     新旧电池绑定
 *
 */
+ (void)EqpBandWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;


/**
 *     验证账号是否存在
 *
 */
+ (void)CtmHasAccountWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;


@end
