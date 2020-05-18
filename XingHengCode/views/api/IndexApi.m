//
//  IndexApi.m
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/24.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "IndexApi.h"

@implementation IndexApi

/**
 *     查询电池信息
 *
 */
+ (void)EqpInfoWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,EqpInfo] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     故障数据列表
 *
 */
+ (void)EqpAbnormalWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,EqpAbnormal] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     正常数据列表
 *
 */
+ (void)EqpNormalWithParams:(NSDictionary *)param
                    success:(void(^)(id obj))success
                    failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,EqpNormal] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     电池故障诊断
 *
 */
+ (void)DrsInfoWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,DrsInfo] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


/**
 *     检测结果提交
 *
 */
+ (void)EqpDetectionResultWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,EqpDetectionResult] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     新旧电池绑定
 *
 */
+ (void)EqpBandWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,EqpBand] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     验证账号是否存在
 *
 */
+ (void)CtmHasAccountWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmHasAccount] params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

@end
