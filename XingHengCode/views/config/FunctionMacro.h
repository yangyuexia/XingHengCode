/*!
 @header FunctionMacro.h
 @abstract 记录存储所有宏实现方法相关方法
 @author .
 @version 1.00 2015/03/06  (1.00)
 */

#ifndef FunctionMacro_H
#define FunctionMacro_H

//拼接图片路径
#define PORID_IMAGE(proId) (((NSString *)proId).length == 6)? [NSString stringWithFormat:@"%@middle/%@/%@/%@/1.JPG",IMAGE_PRFIX,[proId substringWithRange:NSMakeRange(0, 2)],[proId substringWithRange:NSMakeRange(2, 2)],[proId substringWithRange:NSMakeRange(4, 2)]] : @""

#endif
