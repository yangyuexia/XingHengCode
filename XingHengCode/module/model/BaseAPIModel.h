//
//  BaseAPIModel.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseAPIModel : BaseModel
@property (nonatomic,strong) NSString *code;        //业务逻辑根据流转以状态码为判断依据
@property (nonatomic,strong) NSString *message;     //业务状态码描述，或者业务需要返回的提示信息等
@property (nonatomic,strong) NSString *dataMessage;
@property (nonatomic,strong) NSArray  *dataArray;
@end
