/*!
 @header NSDateFormatter+Category.h
 @abstract 针对时间格式的处理
 @author .
 @version 1.00 2015/01/01  (1.00)
 */

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Category)

+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
