//
//  ConfigureModel.h
//  APP
//
//  Created by qw on 15/3/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"
#import "BaseAPIModel.h"

@interface UserInfoModel : BaseAPIModel

@property (strong, nonatomic) NSString *id; // = 401399166116573184;
@property (strong, nonatomic) NSString *nickname; // = "\U8096\U6587\U4f1f";
@property (strong, nonatomic) NSString *phone; // = 18915432481;
@property (strong, nonatomic) NSString *pic; // = "";
@property (strong, nonatomic) NSString *username; // = xiaoww;
@property (strong, nonatomic) NSString *uuid; // = 277f27fcb1b54079aae779c05e8f145e;

@property (strong, nonatomic) NSString *addr; // = "\U6c5f\U82cf\U7701\U82cf\U5dde\U5e02";
@property (strong, nonatomic) NSString *area; // = 0;
@property (strong, nonatomic) NSString *city; // = 320500;
@property (strong, nonatomic) NSString *province; // = 320000;
@property (assign, nonatomic) NSInteger state; // = 1;
@property (strong, nonatomic) NSString *info; // = "\U91d1\U9e21";
@property (strong, nonatomic) NSString *password; // = e10adc3949ba59abbe56e057f20f883e;

@property (strong, nonatomic) NSString *token;          //登陆令牌

@property (strong, nonatomic) NSString *passwordloginAccount;
@end



