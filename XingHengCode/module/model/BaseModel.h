//
//  BaseModel.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface BaseModel : NSObject

/*!
 @method
 @brief 将json数据转换成对象
 @param json 数据
 @discussion
 @result 返回对象
 */
+(id)parse:(id)json;

/*!
 @method
 @brief 将json数据转换成对象数据
 @param json 数据
 @param Elements 包含多对象的数据
 @discussion
 @result 返回对象
 */
+(id)parse:(id)json Elements:(id)classE;

/*!
 @method
 @brief 将json数据转换成对象数据
 @param json 数据
 @param Elements 包含多对象的数据
 @param forAttribute 包含多对象的数据的属性名称（缺省的情况为data）
 @discussion
 @result 返回对象
 */

+(id)parse:(id)json Elements:(id)classE forAttribute:(NSString *)attribute;

/*!
 @method
 @brief 将json数据转换成对象数据
 @param json 数据
 @param ClassArr 要数组内所包含的对象的数组
 @param elements 包含多多对象多属性的数据
 @discussion
 @result 返回对象
 */

+(id)parse:(id)json ClassArr:(NSMutableArray *)classA Elements:(NSMutableArray *)elements;

/*!
 @method
 @brief 将json数据转换成对象数据
 @param json 数据
 @discussion
 @result 返回对象数组
 */

+ (NSArray *)parseArray:(id)json;

/*!
 @method
 @brief 将对象转换成字典
 @param obj 对象
 @discussion
 @result 返回字典
 */

+ (NSDictionary*)dataTOdic:(id)obj;

/*!
 @method
 @brief 将对象转换成流
 @param obj 对象
 @param options options
 @param error 错误信息
 @discussion
 @result 返回流
 */

+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;
/*!
 @method
 @brief 在控制台输出对象转换成字典的结果
 @param obj 对象
 @discussion
 @result 打印字典
 */
+ (void)print:(id)obj;

/*!
 @method
 @brief 将对象存入NSUserDe
 @param objId key
 @discussion
 @result
 */
-(BOOL)saveToNsuserDefault:(NSString *)objId;
/*!
 @method
 @brief 从NSUserde里面取出对象
 @param obj 对象
 @discussion
 @result 返回对象
 */
+(id)getFromNsuserDefault:(NSString *)objId;

/*!
 @method
 @brief 将对象存入本地目录
 @param userPath 要出入的路径，参数为nil则存入默认目录中
 @discussion
 @result
 */
-(BOOL)saveToNsuserlocal:(NSString *)userPath;
/*!
 @method
 @brief 从本地目录里面取出对象
 @param userPath 对象存储的路径
 @discussion
 @result 返回对象
 */
- (id)getFromNsuserlocal:(NSString *)userPath;

//add by qingyang
/*!
 @method
 @brief 将对象参数转NSDictionary
 @param
 @discussion
 @result 返回对象
 */
- (NSDictionary*)dictionaryModel;
//add end

/*!
 @method
 @brief 对象的主键
 @param
 @discussion
 @result 返回对象
 */
+ (NSString *)getPrimaryKey;

/**
 *  自增保存
 *
 *  @param Obj 保存的对象
 *
 *  @return 失败返回错误码
 */
+ (NSError *)saveObjToDB:(id)Obj;

/**
 *  保存一组数据到数据库
 *
 *  @param Obj 保存的对象数组
 *
 *  @return 失败返回错误码
 */
+ (NSError *)saveObjToDBWithArray:(NSArray *)array;

/**
 *  更新数据
 *
 *  @param Obj 需要更新的对象
 *
 *  @return 失败返回错误码
 */
+ (NSError *)updateObjToDB:(id)Obj WithKey:(NSString *)key;

/**
 *  更新数据
 *
 *  @param set 数据表里的特定数据 kye＝'value',kye1＝'value1'
 *
 *  @return 失败返回错误码
 *
 */

+ (NSError *)updateSetToDB:(NSString*)set WithKey:(NSString *)key;
+ (NSError *)updateSetToDB:(NSString*)set WithWhere:(NSString *)key;


/**
 *  根据主键查找对象
 *
 *  @param Obj 对象的主键
 *
 *  @return 失败返回错误码
 */
+ (id)getObjFromDBWithKey:(NSString *)key;

/**
 *  根据条件查询数据
 *
 *  @param Obj 输入条件
 *
 *  @return 失败返回错误码
 */
+ (id)getObjFromDBWithWhere:(NSString *)where;
+ (id)getObjFromDBWithWhere:(NSString *)where WithorderBy:(NSString*)value;
/**
 *  根据条件查询一组数据
 *
 *  @param Obj 输入条件
 *
 *  @return 失败返回错误码
 */
+ (NSArray *)getArrayFromDBWithWhere:(NSString *)where;
+ (NSArray *)getArrayFromDBWithWhere:(NSString *)where WithorderBy:(NSString*)value;
/**
 *  根据条件获取数据条数
 *
 *  @param Obj 输入条件
 *
 *  @return 失败返回错误码
 */
+ (NSInteger)getcountFromDBWithWhere:(NSString *)where;

/**
 *  根据主键删除对象
 *
 *  @param Obj 对象的主键
 *
 *  @return 失败返回错误码
 */
+ (NSError *)deleteObjFromDBWithKey:(NSString *)key;

/**
 *  根据条件删除对象
 *
 *  @param Obj 输入条件
 *
 *  @return 失败返回错误码
 */
+ (NSError *)deleteObjFromDBWithWhere:(NSString *)where;

/**
 *  清空表
 */
+ (void)deleteAllObjFromDB;


//-(void) testCustomMap ;


/**
 *  事务操作
 *
 *  @param Obj 输入条件
 *
 *
 */
+(void)insertToDBWithArray:(NSArray *)models filter:(void (^)(id model, BOOL inseted, BOOL * rollback))filter;

+ (NSArray*)getArrayFromDBWithWhere:(NSString *)where
                            orderBy:(NSString*)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;

@end
