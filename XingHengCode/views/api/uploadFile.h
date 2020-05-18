//
//  uploadFile.h
//  APP
//
//  Created by 李坚 on 15/4/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface uploadFile : BaseAPIModel

@property (nonatomic ,strong) NSString *msg;
@property (nonatomic ,strong) NSString *url;//图片文件上传后返回的URL地址

@property (nonatomic, assign) BOOL uploadSuccess;
@property (nonatomic, assign) NSInteger imageIndex;

@end
