//
//  QWUserDefault.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQWUserID       @"kQYUserID"
#define kQWUserToken    @"kQYUserToken"

@interface QWUserDefault : NSObject

+ (void)setString:(NSString*)str key:(NSString*)keyWord;
+ (NSString *)getStringBy:(NSString*)keyWord;

+ (void)setBool:(BOOL)value key:(NSString*)keyWord;
+ (BOOL)getBoolBy:(NSString*)keyWord;

+ (void)setDict:(NSDictionary*)dict key:(NSString*)keyWord;
+ (NSDictionary *)getDictBy:(NSString*)keyWord;

+ (void)setObject:(id)obj key:(NSString*)keyWord;
+ (id)getObjectBy:(NSString*)keyWord;
+ (void)removeObjectBy:(NSString*)keyWord;

+ (void)setModel:(id)mod key:(NSString*)keyWord;
+ (id)getModelBy:(NSString*)keyWord;

+ (void)setDouble:(double)value key:(NSString*)keyWord;
+ (double)getDoubleBy:(NSString*)keyWord;

+ (void)setInterger:(float)value key:(NSString*)keyWord;
+ (double)getIntergerBy:(NSString*)keyWord;

+ (void)setNumber:(NSNumber*)num key:(NSString*)keyWord;
+ (NSNumber *)getNumberBy:(NSString*)keyWord;

@end
