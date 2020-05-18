//
//  NSString+URLEncoding.h
//  js
//
//  Created by imac on 14-10-14.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)


- (NSString *)URLDecodedString;

+ (NSString*)URLencode:(NSString *)originalString
        stringEncoding:(NSStringEncoding)stringEncoding;

@end
