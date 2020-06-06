//
//  HttpClient.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "HttpClient.h"
#import "SystemMacro.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "Constant.h"
#import "SBJson.h"
#import "NSString+MD5HexDigest.h"
#import "QWGlobalManager.h"
#import "SVProgressHUD.h"
#import "NSString+URLEncoding.h"
#import "AFHTTPSessionManager.h"

@interface HttpException()

@end

@implementation HttpException
{
    
}
@end

@interface HttpClient()<QWLoadingDelegate>
{
    
}
@property (nonatomic, readwrite) NSString * baseUrl;
@property (nonatomic, readwrite) NSString * cookie;
@property (nonatomic, strong, readwrite) AFHTTPRequestOperationManager * http;
@property (nonatomic,assign)BOOL   touchCancle;
@end

@implementation HttpClient

@synthesize progressEnabled = _progressEnabled;

+ (instancetype)sharedInstance {
    static HttpClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HttpClient alloc]init];
        _sharedInstance.baseUrl = [[NSString alloc] init];
        _sharedInstance.cookie = [[NSString alloc] init];
    });
    return _sharedInstance;
}

-(id)init
{
    if (self == [super init]) {
        self.progressEnabled=YES;
        _touchCancle = YES;
        [QWLoading instanceWithDelegate:self];
        return self;
    }
    return nil;
}

- (void)dealloc
{
    self.cookie = nil;
    self.baseUrl = nil;
    [QWLoading instanceWithDelegate:nil];
}


- (NSString *)secretBuild:(NSDictionary *)dataSource
{
    NSMutableDictionary *build = [NSMutableDictionary dictionary];
    
    NSDate *datenow = [NSDate date];
    NSNumber *offset = [QWUserDefault getNumberBy:SERVER_TIME];
    if(offset && ![offset isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSTimeInterval current = [[NSDate date] timeIntervalSince1970] * 1000ll;
        long long rightTime = current + [offset longLongValue];
        [build setValue:[NSString stringWithFormat:@"%lld",rightTime] forKey:@"timestamp"];
    }else{
        NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[datenow timeIntervalSince1970] * 1000];
        [build setValue:timeSp forKey:@"timestamp"];
    }
    build[@"token"] = QWGLOBALMANAGER.configure.token;
    
    NSArray *values = [build allValues];
    NSMutableString *sign = [NSMutableString string];
    for(int i=0; i<values.count; i++)
    {
        if([values[i] isKindOfClass:[NSArray class]] || [values[i] isKindOfClass:[NSMutableArray class]])
        {
            NSArray *array = values[i];
            [sign appendString:[array JSONRepresentation]];
        }else{
            [sign appendString:[NSString stringWithFormat:@"%@",values[i]]];
        }
    }
    sign = [NSMutableString stringWithFormat:@"%@%@",@"ED3ED7C618F18AF3FAB71A05CFAB38EA",sign];
    return [sign md5HexDigest];
}

- (void)process
{
    if (_http) {
        _http = nil;
    }
    
    _http = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:_baseUrl]];
    [_http.requestSerializer setValue:_cookie forHTTPHeaderField:@"Cookie"];
    
//    _http.requestSerializer = [AFJSONRequestSerializer serializer];
//    _http.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _http.requestSerializer = [AFHTTPRequestSerializer serializer];
    _http.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    _http.responseSerializer.acceptableContentTypes = [_http.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [_http.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_http.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [_http.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    securityPolicy.allowInvalidCertificates = YES;
    _http.securityPolicy = securityPolicy;
}

- (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
    [self process];
}

- (void)setCookie:(NSString *)cookie
{
    _cookie = cookie;
    [self process];
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)keyValueStringWithDict:(NSDictionary *)dict
{
    if (dict == nil) {
        return @"";
    }
    NSMutableString *string = [NSMutableString stringWithString:@""];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    
    return string;
}

- (void)requestWithPath:(NSString *)path params:(NSDictionary *)params method:(NSString *)method progressEnabled:(BOOL)pEnabled success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (pEnabled) {
        [[QWLoading instance] showLoading];
    }
    NSMutableURLRequest *request = nil;
    
    
    if([method isEqualToString:@"GET"])
    {
        request = [self.http.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@""]] absoluteString] parameters:nil error:nil];
        [request setTimeoutInterval:30.0f];
    }
    else
    {
        request = [self.http.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@""]] absoluteString] parameters:nil error:nil];
        [request setTimeoutInterval:30.0f];

        NSString *paramStr = [self keyValueStringWithDict:params];
        
        NSString *encoded=[paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:[encoded dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    
    

    NSString *token = @"*";
    if (QWGLOBALMANAGER.configure.token.length > 0) {
        token = QWGLOBALMANAGER.configure.token;
    }
    [request setValue:token forHTTPHeaderField:@"Request-Info"];
    [request setValue:@"mbios" forHTTPHeaderField:@"Request-Terminal"];
    [request setValue:@"iOS" forHTTPHeaderField:@"deviceType"];
    [request setValue:DEVICE_IDD forHTTPHeaderField:@"deviceCode"];
    [request setValue:QWGLOBALMANAGER.deviceToken forHTTPHeaderField:@"pushDeviceCode"];
    [request setValue:APP_VERSION forHTTPHeaderField:@"version"];
    [request setValue:@"appstore" forHTTPHeaderField:@"channel"];
    [request setValue:@"2" forHTTPHeaderField:@"platform"];

    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    bundleid = [bundleid stringByReplacingOccurrencesOfString:@"." withString:@""];
    [request setValue:bundleid forHTTPHeaderField:@"bundleID"];

    NSString * phoneModel =  [QWGLOBALMANAGER deviceVersion];
    [request setValue:phoneModel forHTTPHeaderField:@"phoneModel"];
    
    
    //// success block
    void (^responseSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *fields= [operation.response allHeaderFields];
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:self->_baseUrl]];
        NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        if([requestFields objectForKey:@"Cookie"]){
            
        }
        
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if(!err) {
                responseObject = (NSDictionary *)dic;
            }
        }
        
        
        
        if ([path containsString:@"//itunes.apple.com/"]) {
            success(responseObject);
            return;
        }
        
        
        
        
        if (success) {
            
            id newResponseObject = responseObject;
            
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
            
            if (![newResponseObject objectForKey:@"data"] || [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                
            }else{
                
                if ([newResponseObject objectForKey:@"data"] && [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    bodyDict[@"dataArray"] = [newResponseObject objectForKey:@"data"];
                    
                }else if ([newResponseObject objectForKey:@"data"] && [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                    bodyDict = [[newResponseObject objectForKey:@"data"] mutableCopy];
                    
                }else{
                    
                    if ([newResponseObject objectForKey:@"data"] && [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSNumber class]]) {
                        NSNumber *dataStr = [newResponseObject objectForKey:@"data"];
                        bodyDict[@"dataMessage"] = dataStr;
                    }else
                    {
                        NSString *dataStr = [newResponseObject objectForKey:@"data"];
                        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                        
                        if (jsonData) {
                            NSError *err;
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                            if (dict) {
                                
                                if ([dict isKindOfClass:[NSArray class]]) {
                                    bodyDict[@"dataArray"] = dict;
                                }else{
                                    bodyDict = [dict mutableCopy];
                                }
                                
                            }else{
                                bodyDict[@"dataMessage"] = dataStr;
                            }
                        }
                    }
                }
                
            }
            
            if(operation.UUID){
                bodyDict[@"UUID"] = operation.UUID;
            }
            
            if ([responseObject objectForKey:@"code"] && ![[responseObject objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                bodyDict[@"code"] = [responseObject objectForKey:@"code"];
            }
            
            if(bodyDict && [bodyDict isKindOfClass:[NSDictionary class]] && bodyDict[@"code"] && [bodyDict[@"code"] integerValue] == 205)
            {
                [QWGLOBALMANAGER postNotif:NotifKickOff data:nil object:nil];
                
            }else if (bodyDict && [bodyDict isKindOfClass:[NSDictionary class]] && bodyDict[@"code"] && [bodyDict[@"code"] integerValue] == 205)
            {
                [QWGLOBALMANAGER postNotif:NotifTokenValide data:nil object:nil];
            }
            
            
            if ([responseObject objectForKey:@"msg"] && ![[responseObject objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
                bodyDict[@"message"] = [responseObject objectForKey:@"msg"];
            }
            success(bodyDict);
        }
        
        if (pEnabled) {
            [[QWLoading instance] removeLoading];
        }
    };
    
    /// failure block
    void (^failureResponse)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSInteger code = operation.response.statusCode;
        //DebugLog(@"code ===>%ld",(long)code);
        
        HttpException * e = [HttpException new];
        e.errorCode = code;
        e.UUID = operation.UUID;
        DDLogError(@"%s:%d,%@,%@",__FILE__,__LINE__,[error description],[e description]);
        
        if (error.code == -1001) {
            e.errorCode = -1001;
        }
        else if (error.code == -999) {
            e.errorCode = -999;
        }
        else  if (code == 401) {
            
        }else if (code == 400){
            
        }else if (code == 500){
            
        }else{
            
        }
        
        
        if (failure) {
            failure(e);
        }
        if (pEnabled) {
            [[QWLoading instance] removeLoading];
        }
    };
    
    AFHTTPRequestOperation *operation = [self.http HTTPRequestOperationWithRequest:request success:responseSuccess failure:failureResponse];
    if(params[@"UUID"]) {
        operation.UUID = params[@"UUID"];
    }
    [self.http.operationQueue addOperation:operation];
    
}

-(NSString *)escape:(NSString *)text
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)text,
                                                                                 NULL,
                                                                                 CFSTR("!*’();:@&=+$,/?%#[]"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

-(void)cancleLastRequest
{
    AFHTTPRequestOperation *current =  [self.http.operationQueue.operations lastObject] ;
    [current cancel];
    current = nil;
}

-(void)cancleAllRequest
{
    [self.http.operationQueue cancelAllOperations];
}

#pragma mark ---- .net post请求方法 ----
- (void)netPostBaseUrl:(NSString *)baseUrl action:(NSString *)action params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
{
    if ([_requestType isEqualToString:@"https"]) {
        if ([baseUrl hasPrefix:@"http://"]) {
            baseUrl =  [self.baseUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        }
    }
    
    [self netRequestWithBaseUrl:baseUrl action:action params:params method:@"POST" progressEnabled:self.progressEnabled success:^(id responseObj) {
        success (responseObj);
    } failure:^(HttpException *e) {
        failure(e);
    }];
    
    self.progressEnabled=YES;
}

#pragma mark ---- get 请求方法 ----
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure
{
    //    params = [self secretBuild:params];
    [self requestWithPath:[self urlWithPath:url] params:params method:@"GET" progressEnabled:self.progressEnabled  success:^(id responseObj) {
        success (responseObj);
    } failure:^(HttpException *e) {
        failure(e);
    }];
    self.progressEnabled=YES;
}


#pragma mark ---- post 请求方法 ----
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure
{
    //    params = [self secretBuild:params];
    
    [self requestWithPath:[self urlWithPath:url] params:params method:@"POST" progressEnabled:self.progressEnabled  success:^(id responseObj) {
        success (responseObj);
    } failure:^(HttpException *e) {
        failure(e);
    }];
    self.progressEnabled=YES;
}


#pragma mark ---- put 请求方法 ----
- (void)put:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure{
    //    params = [self secretBuild:params];
    [self requestWithPath:[self urlWithPath:url] params:params method:@"PUT" progressEnabled:NO  success:^(id responseObj) {
        success (responseObj);
    } failure:^(HttpException *e) {
        failure(e);
    }];
    
    self.progressEnabled=YES;
}


#pragma mark ---- delete 请求方法 ----
- (void)deleteR:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure{
    
    [self requestWithPath:[self urlWithPath:url] params:params method:@"DELETE" progressEnabled:NO  success:^(id responseObj) {
        success (responseObj);
    } failure:^(HttpException *e) {
        failure(e);
    }];
    self.progressEnabled=YES;
}


#pragma mark - URL schema
- (NSString *)urlWithPath:(NSString *)path
{
    if ([_requestType isEqualToString:@"https"]) {
        if ([self.baseUrl hasPrefix:@"http://"]) {
            self.baseUrl =  [self.baseUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        }
    }
    
    NSString * urlString;
    urlString = [NSString stringWithFormat:@"%@",path];
    
    return urlString;
}

#pragma mark ---- QWLoadingDelegate ----
- (void)hudStopByTouch:(id)hud
{
    //打断所有请求
    [self cancleAllRequest];
}

#pragma mark ---- 上传图片 ----
-(void)uploaderImg:(NSMutableArray *)imageDataArr  params:(NSDictionary *)params withUrl:(NSString *)imagUrl success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock
{
    if (imageDataArr.count >0) {
        
        NSData *mediaDatas = [imageDataArr objectAtIndex:0];
        void (^responseSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *fields= [operation.response allHeaderFields];
            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:_baseUrl]];
            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            if([requestFields objectForKey:@"Cookie"]){
                // Cookie  code
            }
            
            if (success) {
                if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                    
                    success(responseObject);
                }
                else
                {
                    
                }
                
            }
            if ([[responseObject objectForKey:@"code"] integerValue] != 0) {
                HttpException *qwError = [[HttpException alloc]init];
                qwError.errorCode = [[responseObject objectForKey:@"code" ]integerValue];
                qwError.Edescription =[responseObject objectForKey:@"message" ];
                
                if (failure) {
                    failure(qwError);
                }
                
            }
        };
        
        /// failure block
        void (^failureResponse)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSInteger code = operation.response.statusCode;
            HttpException * e = [HttpException new];
            e.errorCode = code;
            if (code == 401) {
                
            }else if (code == 400){
                
            }else if (code == 500){
                
            }else{
                
            }
            
            if (failure) {
                failure(e);
            }
        };
        
        NSMutableURLRequest *request = [self.http.requestSerializer multipartFormRequestWithMethod:@"POST"  URLString:[[NSURL URLWithString:imagUrl relativeToURL:nil] absoluteString]  parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
            [formData appendPartWithFileData:mediaDatas name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"%d.jpg",0] mimeType:@"image/*"];
            
            
        } error:nil];
        
        [request setValue:QWGLOBALMANAGER.configure.token forHTTPHeaderField:@"token"];
        
        AFHTTPRequestOperation *operation = [self.http HTTPRequestOperationWithRequest:request success:responseSuccess failure:failureResponse];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            if (uploadProgressBlock) {
                uploadProgressBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
            }
            
        }];
        
        [self.http.operationQueue addOperation:operation];
        
    }
}

- (NSString *)GetDocumentPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

#pragma mark ---- 下载域名json文件 ----
- (void)downloadHttpJsonFileURL:(NSString *)aUrl
                       fileName:(NSString *)fileName
                        success:(void(^)(NSString *aSavePath))success
                        failure:(void(^)(HttpException * e))failure
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self GetDocumentPath],fileName];
    
    NSURL *url = [[NSURL alloc] initWithString:aUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(filePath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operation start];
}


- (void)netRequestWithBaseUrl:(NSString *)baseUrl action:(NSString *)action params:(NSDictionary *)params method:(NSString *)method progressEnabled:(BOOL)pEnabled success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (pEnabled) {
        [[QWLoading instance] showLoading];
    }
    
    
    NSMutableURLRequest *request = nil;
    NSString *urlString = @"";
    
    if (params) {
        NSString *paramStr = [params JSONRepresentation];
        paramStr =  [NSString URLencode:paramStr stringEncoding:NSUTF8StringEncoding];
        urlString = [NSString stringWithFormat:@"%@action=%@&params=%@",baseUrl,action,paramStr];
    }else{
        urlString = [NSString stringWithFormat:@"%@action=%@&params=nil",baseUrl,action];
    }
    
    request = [self.http.requestSerializer requestWithMethod:method URLString:urlString parameters:nil error:nil];
    [request setTimeoutInterval:30.0f];
    
    NSString *sign = [self secretBuild:params];
    
    [request setValue:sign forHTTPHeaderField:@"sign"];
    [request setValue:QWGLOBALMANAGER.configure.token forHTTPHeaderField:@"token"];
    [request setValue:@"iOS" forHTTPHeaderField:@"deviceType"];
    [request setValue:DEVICE_IDD forHTTPHeaderField:@"deviceCode"];
    [request setValue:APP_VERSION forHTTPHeaderField:@"version"];
    [request setValue:@"2" forHTTPHeaderField:@"platform"];
    
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    bundleid = [bundleid stringByReplacingOccurrencesOfString:@"." withString:@""];
    [request setValue:bundleid forHTTPHeaderField:@"bundleID"];
    
    NSString * phoneModel =  [QWGLOBALMANAGER deviceVersion];
    [request setValue:phoneModel forHTTPHeaderField:@"phoneModel"];
    
    if ([[QWUserDefault getObjectBy:[NSString stringWithFormat:@"time+%@+%ld",urlString,(long)QWGLOBALMANAGER.configure.token]] doubleValue] > 0) {
        [request setValue:[NSString stringWithFormat:@"%@",[QWUserDefault getObjectBy:[NSString stringWithFormat:@"time+%@+%ld",urlString,(long)QWGLOBALMANAGER.configure.token]]] forHTTPHeaderField:@"stamp"];
    }
    
    
    //// success block
    void (^responseSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *fields= [operation.response allHeaderFields];
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:_baseUrl]];
        NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        if([requestFields objectForKey:@"Cookie"]){
            // Cookie  code
        }
        
        if (success) {
            
            NSNumber *apiStamp = [responseObject objectForKey:@"stamp"];
            NSNumber *cacheStamp = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"time+%@+%ld",urlString,(long)QWGLOBALMANAGER.configure.token]];
            
            if ([apiStamp doubleValue] > 0) {
                [QWUserDefault setObject:[responseObject objectForKey:@"stamp"] key:[NSString stringWithFormat:@"time+%@+%ld",urlString,(long)QWGLOBALMANAGER.configure.token]];
            }
            
            if ([apiStamp doubleValue] == [cacheStamp doubleValue] && [apiStamp doubleValue] > 0){
                
            }else{
                [QWUserDefault setObject:responseObject key:[NSString stringWithFormat:@"data+%@+%ld",urlString,(long)QWGLOBALMANAGER.configure.token]];
            }
            
            id newResponseObject = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"data+%@+%ld",urlString,(long)QWGLOBALMANAGER.configure.token]];
            
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
            
            if (![newResponseObject objectForKey:@"data"] || [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                
            }else{
                
                if ([newResponseObject objectForKey:@"data"] && [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    bodyDict[@"dataArray"] = [newResponseObject objectForKey:@"data"];
                    
                }else if ([newResponseObject objectForKey:@"data"] && [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                    bodyDict = [[newResponseObject objectForKey:@"data"] mutableCopy];
                    
                }else{
                    
                    if ([newResponseObject objectForKey:@"data"] && [[newResponseObject objectForKey:@"data"] isKindOfClass:[NSNumber class]]) {
                        NSNumber *dataStr = [newResponseObject objectForKey:@"data"];
                        bodyDict[@"dataMessage"] = dataStr;
                    }else
                    {
                        NSString *dataStr = [newResponseObject objectForKey:@"data"];
                        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                        
                        if (jsonData) {
                            NSError *err;
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                            if (dict) {
                                
                                if ([dict isKindOfClass:[NSArray class]]) {
                                    bodyDict[@"dataArray"] = dict;
                                }else{
                                    bodyDict = [dict mutableCopy];
                                }
                                
                            }else{
                                bodyDict[@"dataMessage"] = dataStr;
                            }
                        }
                        
                        
                    }
                }
            }
            
            if(operation.UUID){
                bodyDict[@"UUID"] = operation.UUID;
            }
            
            if ([responseObject objectForKey:@"code"] && ![[responseObject objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                
                NSInteger oo = [[responseObject objectForKey:@"code"] integerValue];
                bodyDict[@"code"] = StrFromInt(oo);
            }
            
            if (bodyDict && [bodyDict isKindOfClass:[NSDictionary class]] && bodyDict[@"code"] && [bodyDict[@"code"] integerValue] == -2)
            {
                [QWGLOBALMANAGER postNotif:NotifTokenValide data:nil object:nil];
            }
            
            if ([responseObject objectForKey:@"msg"] && ![[responseObject objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
                bodyDict[@"message"] = [responseObject objectForKey:@"msg"];
            }
            success(bodyDict);
            
        }
        
        if (pEnabled) {
            [[QWLoading instance] removeLoading];
        }
    };
    
    /// failure block
    void (^failureResponse)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSInteger code = operation.response.statusCode;
        //DebugLog(@"code ===>%ld",(long)code);
        
        HttpException * e = [HttpException new];
        e.errorCode = code;
        e.UUID = operation.UUID;
        DDLogError(@"%s:%d,%@,%@",__FILE__,__LINE__,[error description],[e description]);
        
        if (error.code == -1001) {
            e.errorCode = -1001;
        }
        else if (error.code == -999) {
            e.errorCode = -999;
        }
        else  if (code == 401) {
            
        }else if (code == 400){
            
        }else if (code == 500){
            
        }else{
            
        }
        
        
        if (failure) {
            failure(e);
        }
        if (pEnabled) {
            [[QWLoading instance] removeLoading];
        }
    };
    
    AFHTTPRequestOperation *operation = [self.http HTTPRequestOperationWithRequest:request success:responseSuccess failure:failureResponse];
    if(params[@"UUID"]) {
        operation.UUID = params[@"UUID"];
    }
    [self.http.operationQueue addOperation:operation];
    
}


@end
