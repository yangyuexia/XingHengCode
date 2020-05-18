//
//  Md5.m
//

#import "Md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Md5

+ (NSString *)encode:(NSString *)aStr
{
	const char *cStr = [aStr UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];	
}

+ (NSString*)encode_ne:(NSString*)aString
{
	const char *cStr = [aString UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result);
	NSString *strBuffer = @"";
	for (int i =0; i < 16;i++) {
		unsigned char value = result[i] & 0xff;
		if (value < 16) {
			strBuffer = [strBuffer stringByAppendingString:@"0"];
		}
		strBuffer = [strBuffer stringByAppendingFormat:@"%0x",value];
	}
	
	return strBuffer;	
}
#define CHUNK_SIZE 1024
+(NSString *)file_encode:(NSString*) path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];  
    if(handle == nil)  
        return nil;  
	
    CC_MD5_CTX md5_ctx;  
    CC_MD5_Init(&md5_ctx);  
	
    NSData* filedata;  
    do {  
        filedata = [handle readDataOfLength:CHUNK_SIZE];  
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);  
    }  
    while([filedata length]);  
	
    unsigned char result[CC_MD5_DIGEST_LENGTH];  
    CC_MD5_Final(result, &md5_ctx);  
	
    [handle closeFile];  
	
    return [NSString stringWithFormat:  
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",  
            result[0], result[1], result[2], result[3],  
            result[4], result[5], result[6], result[7],  
            result[8], result[9], result[10], result[11],  
            result[12], result[13], result[14], result[15]  
            ];  
}

+(NSString *)data_encode:(NSData*)data {
    if(data == nil)  
        return nil;	
    CC_MD5_CTX md5_ctx;  
    CC_MD5_Init(&md5_ctx);  
    CC_MD5_Update(&md5_ctx, [data bytes], [data length]);
	
    unsigned char result[CC_MD5_DIGEST_LENGTH];  
    CC_MD5_Final(result, &md5_ctx);
	
    return [NSString stringWithFormat:  
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",  
            result[0], result[1], result[2], result[3],  
            result[4], result[5], result[6], result[7],  
            result[8], result[9], result[10], result[11],  
            result[12], result[13], result[14], result[15]  
            ];  
}

+(NSString *)file_encode_ne:(NSString*) path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];  
    if(handle == nil)  
        return nil;  
	
    CC_MD5_CTX md5_ctx;  
    CC_MD5_Init(&md5_ctx);  
	
    NSData* filedata;  
    do {  
        filedata = [handle readDataOfLength:CHUNK_SIZE];  
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);  
    }  
    while([filedata length]);  
	
    unsigned char result[CC_MD5_DIGEST_LENGTH];  
    CC_MD5_Final(result, &md5_ctx);  
	
    [handle closeFile];  
	
    return [NSString stringWithFormat:  
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",  
            result[0], result[1], result[2], result[3],  
            result[4], result[5], result[6], result[7],  
            result[8], result[9], result[10], result[11],  
            result[12], result[13], result[14], result[15]  
            ];  
}

@end