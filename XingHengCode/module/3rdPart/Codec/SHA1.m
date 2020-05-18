//
//  SHA1.m
//

#import "SHA1.h"
#import <CommonCrypto/CommonDigest.h>

#define DFACE_SHA1_DIGEST_LENGTH 16

@implementation SHA1
+ (NSString *)encode:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *ret = [NSMutableString string];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x", digest[i]];
    }
    
    return ret;
}
@end