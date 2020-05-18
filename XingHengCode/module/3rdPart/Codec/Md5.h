//
//  Md5.h
//


#import <Foundation/Foundation.h>


@interface Md5 : NSObject {
    
}

+(NSString *)encode:(NSString *)aStr;
+(NSString*)encode_ne:(NSString*)aString;
+(NSString *)file_encode:(NSString*)path;
+(NSString *)data_encode:(NSData*)data;
@end