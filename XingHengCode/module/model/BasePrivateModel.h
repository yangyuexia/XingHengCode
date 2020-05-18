//
//  BasePrivateModel.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "LKDBHelper.h"

@interface BasePrivateModel : BaseModel

+(LKDBHelper*)getUsingLKDBHelperEx:(NSString*)dbName;

@end
