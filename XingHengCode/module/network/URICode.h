//
//  URICode.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URICode : NSObject

/**
 html转义方法
 
 */
+ (NSString*)escapeHTML:(NSString*)src;
/**
 转义后html转回方法
 
 */
+ (NSString*)unescapeHTML:(NSString*)src;

/**
 url编码
 
 */
+ (NSString*)escapeURIComponent:(NSString*)src;
/**
 url编码转回方法
 
 */
+ (NSString*)unescapeURIComponent:(NSString*)url;

@end
