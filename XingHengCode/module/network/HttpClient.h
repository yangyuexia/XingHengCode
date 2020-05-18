//
//  HttpClient.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYXError.h"
#import "uploadFile.h"

#define  HttpClientMgr [HttpClient sharedInstance]

typedef void (^SuccessBlock)(id resultObj);
typedef void (^FailureBlock)(NSError *error);
typedef void (^SuccessBlockIndex)(id resultObj,NSUInteger index);
typedef void (^FailureBlockIndex)(NSError *error,NSUInteger index);

@interface HttpException : YYXError
@property (nonatomic, strong) NSString *UUID;
@end

@class AFHTTPSessionManager;

@interface HttpClient : NSObject


@property (nonatomic, assign) BOOL progressEnabled;
@property (nonatomic, strong) NSString *requestType;
@property (readwrite, nonatomic, strong) AFHTTPSessionManager *client;

+ (instancetype)sharedInstance;

- (NSString *)secretBuild:(NSDictionary *)dataSource;

- (void)setBaseUrl:(NSString *)baseUrl;
- (void)setCookie:(NSString *)cookie;


/**
 * .net post请求方法
 *
 */
- (void)netPostBaseUrl:(NSString *)baseUrl action:(NSString *)action params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;


/**
 * get请求方法
 *
 */
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

/**
 * post请求方法
 *
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

/**
 * put请求方法
 *
 */
- (void)put:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

/**
 * delete请求方法
 *
 */
- (void)deleteR:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;


/**
 * 上传单张图片
 *
 */
-(void)uploaderImg:(NSMutableArray *)imageDataArr  params:(NSDictionary *)params withUrl:(NSString *)imagUrl success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;


/**
 * 下载域名json文件
 *
 * @param string aUrl 请求文件地址
 */
- (void)downloadHttpJsonFileURL:(NSString *)aUrl
                       fileName:(NSString *)fileName
                        success:(void(^)(NSString *aSavePath))success
                        failure:(void(^)(HttpException * e))failure;


-(void)cancleLastRequest;
-(void)cancleAllRequest;

-(NSString *)escape:(NSString *)text;

@end
