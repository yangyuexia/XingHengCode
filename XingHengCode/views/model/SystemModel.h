//
//  SystemModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/27.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface SystemModel : BaseAPIModel

@end

@interface VersionModel : BaseAPIModel
@property (assign, nonatomic) BOOL compel;  //是否强制升级版本 ,
@property (strong, nonatomic) NSString *remark;  //版本描述 ,
@property (strong, nonatomic) NSString *downLoadUrl;  //包下载地址 ,
@property (strong, nonatomic) NSString *size;  //包大小。形如512M ,
@property (strong, nonatomic) NSString *version;  //版本号
@end

@interface ForgetPwdModel : BaseAPIModel
@property (strong, nonatomic) NSString *token;
@end
