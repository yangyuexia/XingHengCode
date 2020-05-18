//
//  BasePrivateModel+ExcludeORM.m
//  wenYao-store
//
//  Created by garfield on 15/5/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel+ExcludeORM.h"
#import "LKDBHelper.h"
@implementation BasePrivateModel(ExcludeORM)

+ (NSArray *)getArrayFromDBWithWhere:(NSString *)where WithorderBy:(NSString*)orderBy
{
    return [[self class] getArrayFromDBWithWhere:where WithorderBy:orderBy offset:-1 count:-1];
}


+ (NSArray*)getArrayFromDBWithWhere:(NSString *)where
                        WithorderBy:(NSString*)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count
{
    __block NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:15];
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return retArray;
    }
    NSString *query = nil;
    if (where.length == 0 || where == nil)
    {
        query = [NSString stringWithFormat:@"select *,rowid from %@",[self class]]
        ;
    }
    else
    {
        query = [NSString stringWithFormat:@"select *,rowid from %@ where %@",[self class],where];
    }
    if(orderBy && orderBy.length > 0) {
        query = [query stringByAppendingFormat:@" order by %@",orderBy];
    }
    if(count > 0) {
        query = [query stringByAppendingFormat:@" limit %d",count];
    }
    if(offset > 0) {
        query = [query stringByAppendingFormat:@" offset %d",offset];
    }
//    DebugLog(@"%@",query);
    [globalHelper executeDB:^(FMDatabase *db) {
        FMResultSet * set =[db executeQuery:query];
        while ([set next]) {
            NSDictionary *row = [set resultDictionary];
            if (row)
            {
                id msg = [[[self class] alloc] init];
                for(NSString *key in [row allKeys])
                {
                    [msg setValue:row[key] forKey:key];
                }
                [retArray addObject:msg];
            }
        }
        [set close];
    }];
    return retArray;
}


+ (void)getArrayFromDBWithWhere:(NSString *)where WithorderBy:(NSString*)value withCallBackBlock:(void(^)(NSArray *))block
{
    Async_Begin
    __block NSArray *retArray = [[self class] getArrayFromDBWithWhere:where WithorderBy:value];
    if(block) {
        dispatch_main_sync_safe(block(retArray));
    }
    Async_End
}

+ (NSArray *)getArrayFromDBWithWhere:(NSString *)where
{
    return [self getArrayFromDBWithWhere:where WithorderBy:nil];
}

+ (void)getArrayFromDBWithWhere:(NSString *)where withCallBackBlock:(void(^)(NSArray *))block
{
    Async_Begin
    __block NSArray *retArray = [self getArrayFromDBWithWhere:where WithorderBy:nil];
    if(block) {
        dispatch_main_sync_safe(block(retArray));
    }
    Async_End
}

+ (NSError *)updateObjToDB:(id)Obj WithKey:(NSString *)key
{
    if (Obj == nil)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", Obj] code:0 userInfo:nil];
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", Obj] code:1 userInfo:nil];
    }
    
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'", [[self class] getPrimaryKey], key];
    
    if ([[self class] getObjFromDBWithKey:key]) {
        if (![globalHelper updateToDB:Obj where:where])
        {
            return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", Obj] code:0 userInfo:nil];
        }
    }
    else
    {
        //如果失败插入数据
        [globalHelper insertToDB:Obj];
    }
    return nil;
}

+ (void)updateObjToDB:(id)Obj WithKey:(NSString *)key withCallBackBlock:(void(^)(NSError *))block
{
    Async_Begin
    __block NSError *error = [self updateObjToDB:Obj WithKey:key];
    if(block) {
        dispatch_main_sync_safe(block(error));
    }
    Async_End
}

+ (NSError *)updateSetToDB:(NSString*)set WithWhere:(NSString *)where
{
    __block NSError *error = nil;
    if (set == nil || set.length == 0)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", set] code:0 userInfo:nil];
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", set] code:1 userInfo:nil];
    }
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@",[self class],set];
    if(where && where.length > 0) {
        sql = [sql stringByAppendingFormat:@" where %@",where];
    }
    
    [globalHelper executeDB:^(FMDatabase *db) {
        
        BOOL execute = [db executeUpdate:sql];
        if(!execute) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"[update error] :%@", set] code:1 userInfo:nil];
        }
    }];
    
    return error;
}

+ (void)updateSetToDB:(NSString*)set WithWhere:(NSString *)where withCallBackBlock:(void(^)(NSError *))block
{
    Async_Begin
    __block NSError *error = [self updateSetToDB:set WithWhere:where];
    if(block) {
        dispatch_main_sync_safe(block(error));
    }
    Async_End
}



@end
