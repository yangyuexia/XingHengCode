//
//  AESUtil.h
//  Smile
//

#import "AESUtil.h"
#import "NSData+AES.h"

@implementation AESUtil

#pragma mark - AES加密
//将string转成带密码的data
+ (NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:key];
    if (encryptedData && encryptedData.length > 0) {
        
        Byte *datas = (Byte*)[encryptedData bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:encryptedData.length * 2];
        for(int i = 0; i < encryptedData.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        //NSLog(@"加密后的字符串 :%@",output);
        return output;
    }
    return nil;
}

#pragma mark - AES解密
//将带密码的data转成string
+ (NSString*)decryptAESData:(NSString*)decryData  app_key:(NSString*)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:[decryData length] / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [decryData length] / 2; i++) {
        byte_chars[0] = [decryData characterAtIndex:i*2];
        byte_chars[1] = [decryData characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES128DecryptWithKey:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
