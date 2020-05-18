//
//  AccountModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/21.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface AccountModel : BaseAPIModel
@property (strong, nonatomic) NSString *addr; // = "\U6c5f\U82cf\U7701\U82cf\U5dde\U5e02";
@property (strong, nonatomic) NSString *area; // = 0;
@property (strong, nonatomic) NSString *city; // = 320500;
@property (strong, nonatomic) NSString *email; // = "";
@property (strong, nonatomic) NSString *id; // = 401399166116573184;
@property (strong, nonatomic) NSString *id_card; //" = 430321190000000000;
@property (strong, nonatomic) NSString *info; // = "\U91d1\U9e21";
@property (strong, nonatomic) NSString *nickname; // = "\U8096\U6587\U4f1f";
@property (strong, nonatomic) NSString *password; // = e10adc3949ba59abbe56e057f20f883e;
@property (strong, nonatomic) NSString *phone; // = 18915432481;
@property (strong, nonatomic) NSString *pic; // = "";
@property (strong, nonatomic) NSString *province; // = 320000;
@property (strong, nonatomic) NSString *register_time; //" = "2019-12-09 12:58:04";
@property (assign, nonatomic) NSInteger sex; // = 0;
@property (assign, nonatomic) NSInteger state; // = 1;
@property (strong, nonatomic) NSString *username; // = xiaoww;
@end

@interface LoginInfoModel : BaseAPIModel
@property (strong, nonatomic) NSString *id; // = 401399166116573184;
@property (strong, nonatomic) NSString *nickname; // = "\U8096\U6587\U4f1f";
@property (strong, nonatomic) NSString *phone; // = 18915432481;
@property (strong, nonatomic) NSString *pic; // = "";
@property (strong, nonatomic) NSString *username; // = xiaoww;
@property (strong, nonatomic) NSString *uuid; // = 277f27fcb1b54079aae779c05e8f145e;
@property (strong, nonatomic) NSString *token;          //登陆令牌
@end

@interface LoginTempModel : BaseAPIModel
//@property (strong, nonatomic) NSString *Request-Info; //0010de7a5ee040bf97b815654331162a-SWMA_401399166116573184_webpage";
@property (strong, nonatomic) LoginInfoModel *data;
@end

@interface RegisterInfoModel : BaseAPIModel
@property (assign, nonatomic) NSInteger token;
@end

@interface RemAccountModel : BaseAPIModel
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL isRemPwd; //是否记住密码
@end

