//
//  UrlEncode.h
//

#import <Foundation/Foundation.h>



@interface UrlEncode : NSObject {

}
+ (BOOL)needEncode:(NSString *)aStr;
+ (NSString *)encode:(NSString *)aStr;
@end

@interface OAuthPercentEncode : NSObject
{
}
+ (NSString *)encode:(NSString *)aStr;
@end;