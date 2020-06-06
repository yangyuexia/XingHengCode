//
//  System.m
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/27.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "System.h"

@implementation System

/**
 *     获取可升级的版本信息
 *
 */
+ (void)storeVersionWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure
{
    NSString *urlStr = @"http://itunes.apple.com/cn/lookup?id=1516850507";
    [HttpClientMgr post:urlStr params:param success:^(id responseObj) {
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
 *     获取可升级的版本信息
 *
 */
+ (void)SysVersionWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,SysVersion] params:param success:^(id responseObj) {
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
 *     账号密码登陆
 *
 */
+ (void)LoginInfoWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,LoginInfo] params:param success:^(id responseObj) {
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
 *     查询个人信息
 *
 */
+ (void)CtmInfoWithParams:(NSDictionary *)param
                  success:(void(^)(id obj))success
                  failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmInfo] params:param success:^(id responseObj) {
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
 *     注册
 *
 */
+ (void)CtmRegisterWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmRegister] params:param success:^(id responseObj) {
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
 *     激活注册用户
 *
 */
+ (void)CtmActivateWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmActivate] params:param success:^(id responseObj) {
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
 *     检测用户信息（忘记密码）
 *
 */
+ (void)CtmForgetPwdCheckWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmForgetPwdCheck] params:param success:^(id responseObj) {
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
 *     修改忘记密码
 *
 */
+ (void)CtmChangePwdWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmChangePwd] params:param success:^(id responseObj) {
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
 *     修改个人信息
 *
 */
+ (void)CtmUpdateWithParams:(NSDictionary *)param
                    success:(void(^)(id obj))success
                    failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmUpdate] params:param success:^(id responseObj) {
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
 *     修改密码
 *
 */
+ (void)CtmChangePToWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmChangePTo] params:param success:^(id responseObj) {
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
 *     子账号列表
 *
 */
+ (void)CtmSubListWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmSubList] params:param success:^(id responseObj) {
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
 *     子账号修改
 *
 */
+ (void)CtmSubUpdateWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmSubUpdate] params:param success:^(id responseObj) {
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
 *     子账号新增
 *
 */
+ (void)CtmSubAddWithParams:(NSDictionary *)param
                    success:(void(^)(id obj))success
                    failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmSubAdd] params:param success:^(id responseObj) {
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
 *     子账号修改密码
 *
 */
+ (void)CtmSubChangePwdWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmSubChangePwd] params:param success:^(id responseObj) {
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
 *     子账号删除
 *
 */
+ (void)CtmSubDeleteWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;
{
    [HttpClientMgr post:[NSString stringWithFormat:@"%@%@",YINIU_BASE_URL,CtmSubDelete] params:param success:^(id responseObj) {
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
