//
//  GlobalManager.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QWcss.h"

#define  GLOBALMANAGER [GlobalManager sharedInstance]

#define StrFromInt(IntValue)     [NSString stringWithFormat: @"%ld", (long)IntValue]
#define StrFromFloat(FloatValue)     [NSString stringWithFormat: @"%f", FloatValue]
#define StrFromDouble(DoubleValue)     [NSString stringWithFormat: @"%f", DoubleValue]
#define StrFromObj(objValue)     [NSString stringWithFormat: @"%@", objValue]
#define StrIsEmpty(strObj)      [GLOBALMANAGER isStringEmpty:strObj]

@interface GlobalManager : NSObject

+ (GlobalManager *)sharedInstance;


- (BOOL)isStringEmpty:(id)obj;


/**
 *  判断是不是某类
 *
 *  @param obj    判断对象
 *  @param aClass 类类型
 *
 *  @return 返回BOOL
 */
- (BOOL)object:(id)obj isClass:(Class)aClass;

/**
 *  判断是不是手机号码
 *
 *  @param text    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isPhoneNumber:(NSString*)text;

/**
 *  判断是不是电话号码
 *
 *  @param text    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isTelPhoneNumber:(NSString*)text;


/**
 *  @brief 判断是否包含数字或字母
 *
 *  @return YES表示包含, NO表示不包含
 */

- (BOOL)isContainNumOrABC:(NSString *)str;


/**
 *  校验身份证号码
 *
 *  @param value    判断对象
 *
 *  @return 返回BOOL
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (BOOL)checkIDCard:(NSString *)str;


/**
 *  判断字符串是否都为数字
 *
 *  @param string    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isAllNum:(NSString *)string;
/**
 *  发出全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param object  通知来源对象，填self
 *  @return @{type:,data:,object:}
 */
- (NSDictionary *)postNotif:(NSInteger)type data:(id)data object:(id)object;

/**
 *  文字限宽下高度计算
 *
 *  @param text  文字内容
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 返回高度,如果带emoji表情，要加2
 */
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width;

- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height;
/**
 *  返回文字的size
 *
 *  @param text 内容
 *  @param font 字体
 *
 *  @return size
 */
- (CGSize)sizeText:(NSString*)text font:(UIFont*)font;

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font constrainedToSize:(CGSize)size;

/**
 *  设置边距
 *
 *  @param object UI控件
 *  @param margin 边距
 *  @param edge   方位
 */
- (void)setObject:(UIView*)object margin:(CGFloat)margin edge:(Enum_Edge)edge;

@end
