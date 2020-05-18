//
//  BasePrivateModel+ExcludeORM.h
//  wenYao-store
//
//  Created by garfield on 15/5/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"

@interface BasePrivateModel(ExcludeORM)

+ (NSArray *)getArrayFromDBWithWhere:(NSString *)where WithorderBy:(NSString*)orderBy;
+ (NSArray *)getArrayFromDBWithWhere:(NSString *)where;
+ (void)getArrayFromDBWithWhere:(NSString *)where withCallBackBlock:(void(^)(NSArray *))block;
+ (void)getArrayFromDBWithWhere:(NSString *)where WithorderBy:(NSString*)orderBy withCallBackBlock:(void(^)(NSArray *))block;
+ (NSError *)updateObjToDB:(id)Obj WithKey:(NSString *)key;
+ (NSError *)updateSetToDB:(NSString*)set WithWhere:(NSString *)where;
+ (void)updateSetToDB:(NSString*)set WithWhere:(NSString *)where withCallBackBlock:(void(^)(NSError *))block;
+ (NSArray*)getArrayFromDBWithWhere:(NSString *)where
                        WithorderBy:(NSString*)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;
+ (void)updateObjToDB:(id)Obj WithKey:(NSString *)key withCallBackBlock:(void(^)(NSError *))block;

@end
