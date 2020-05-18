//
//  URICode.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "URICode.h"

@implementation URICode

#define SPECIAL_CHARACTER @"!*'();:@&=+$,/?%#[]"


+ (NSString*)escapeHTML:(NSString*)src {
    if (src == nil)
        return nil;
    const char* sch = [src UTF8String];
    NSString* sRes = @"";
    NSInteger num = [src length];
    for (int i = 0; i < num; i++) {
        char ch = sch[i];
        switch (ch) {
            case '<':
                sRes = [NSString stringWithFormat:@"%@%@",sRes,@"&lt;"];
                break;
            case '>':
                sRes = [NSString stringWithFormat:@"%@%@",sRes,@"&gt;"];
                break;
            case '&':
                sRes = [NSString stringWithFormat:@"%@%@",sRes,@"&amp;"];
                break;
            case '"':
                sRes = [NSString stringWithFormat:@"%@%@",sRes,@"&quot;"];
                break;
            case ' ':
                sRes = [NSString stringWithFormat:@"%@%@",sRes,@"&nbsp;"];
                break;
            default:
                sRes = [NSString stringWithFormat:@"%@%c",sRes,ch];
                break;
        }
    }
    return sRes;
}


//decode URL-encode string
/**
 * Unescape a HTML string by filtering out &...; sequences, including &#<numbers>;.
 * We do not consider the case where one sequence is broken into multiple lines.
 */
+ (NSString*)unescapeHTML:(NSString*)src {
    const char* chSrc = [src UTF8String];
    NSString* sDest = @"";
    NSInteger iLength = [src length];
    int escapeIdx = -1;
    int j;
    int ch;
    for (int i=0; i<iLength; i++) {
        switch (chSrc[i]) {
            case '&':
                // we should not miss the case &aaa&.
                if (escapeIdx > 0 && escapeIdx < i) {
                    NSRange range;
                    range.location = escapeIdx;
                    range.length = i-escapeIdx;
                    NSString* sub = [src substringWithRange:range];
                    sDest = [NSString stringWithFormat:@"%@%@",sDest,sub];
                }
                escapeIdx = i;
                break;
            case ';':
                if (escapeIdx >= 0) {
                    if (chSrc[escapeIdx+1] == '#') {
                        ch = 0;
                        for (j = escapeIdx+2; j < i; ++j) {
                            if (chSrc[j] < '0' || chSrc[j] > '9') {
                                ch = -1;
                                break;
                            } else {
                                ch *= 10;
                                ch += chSrc[j] - '0';
                            }
                        }
                    } else {
                        int pp1 = escapeIdx + 1;
                        int pp2 = escapeIdx + 2;
                        int pp3 = escapeIdx + 3;
                        int pp4 = escapeIdx + 4;
                        int pp5 = escapeIdx + 5;
                        if (chSrc[pp1] == 'q' && chSrc[pp2] == 'u' && chSrc[pp3] == 'o' && chSrc[pp4] == 't' && pp5 == i)
                            ch = '"';
                        else if (chSrc[pp1] == 'a' && chSrc[pp2] == 'm' && chSrc[pp3] == 'p' && pp4 == i)
                            ch = '&';
                        else if (chSrc[pp1] == 'l' && chSrc[pp2] == 't' && pp3 == i)
                            ch = '<';
                        else if (chSrc[pp1] == 'g' && chSrc[pp2] == 't' && pp3 == i)
                            ch = '>';
                        else if (chSrc[pp1] == 'n' && chSrc[pp2] == 'b' && chSrc[pp3] == 's' && chSrc[pp4] == 'p' && pp5 == i)
                            ch = ' ';
                        else
                            ch = -1;
                        if (ch != -1) {
                            sDest = [NSString stringWithFormat:@"%@%c",sDest,(char)ch];
                            escapeIdx = -1;
                            break;
                        }
                    }
                } else
                    ch = -1;
                // Replace the Html Special Characters likes &#<numbers>.
                if (ch >= 0){
                    switch (ch) {
                        case 123:
                            ch  = '{';
                            break;
                        case 125:
                            ch = '}';
                            break;
                        case 133:
                            for (int k = 0; k<3; k++)
                                sDest = [NSString stringWithFormat:@"%@%c",sDest,'.'];
                            ch  = -1;
                            break;
                        case 146:
                            ch = '\'';
                            break;
                        case 147:
                        case 148:
                            ch = '"';
                            break;
                        case 151:
                            ch = '-';
                            break;
                        default:
                            ch = ' ';
                            break;
                    }
                    if (ch != -1)
                        sDest = [NSString stringWithFormat:@"%@%c",sDest,(char)ch];
                }else {
                    // If current charactor is only a characters ";" ,
                    // not a Html Special Characters, we copy it in dest.
                    if (escapeIdx < 0)
                        sDest = [NSString stringWithFormat:@"%@%c",sDest,chSrc[i]];
                    else{
                        NSRange range;
                        range.location = escapeIdx;
                        range.length = i-escapeIdx+1;
                        NSString* sub = [src substringWithRange:range];
                        sDest = [NSString stringWithFormat:@"%@%@",sDest,sub];
                    }
                }
                escapeIdx = -1;
                break;
            default:
                if (escapeIdx < 0)
                    sDest = [NSString stringWithFormat:@"%@%c",sDest,chSrc[i]];
                else if (escapeIdx > 0  && ((i - escapeIdx) > 5)){
                    NSRange range;
                    range.location = escapeIdx;
                    range.length = i-escapeIdx+1;
                    NSString* sub = [src substringWithRange:range];
                    sDest = [NSString stringWithFormat:@"%@%@",sDest,sub];
                    escapeIdx = -1;
                }
                break;
        }
    }
    return sDest;
}


+ (NSString*)escapeURIComponent:(NSString*)src {
    
    if (src == nil)
        return nil;
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                    (CFStringRef)src,
                                                                                                    NULL,
                                                                                                    (CFStringRef)SPECIAL_CHARACTER,
                                                                                                    kCFStringEncodingUTF8 ));
    
    return  encodedString   ;
    
}



+ (NSString *)unescapeURIComponent:(NSString *)url {
    if (url == nil)
        return nil;
    
    // 某些情况下，url编码中会把空格转成 + 号，ios中的url解码不支持这种情况，所有在解码前，先将 + 号转成 空格
    NSMutableString *_url = [NSMutableString stringWithString:url];
    [_url replaceOccurrencesOfString:@"+"
                          withString:@" "
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [_url length])];
    
    
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault,
                                                                    (CFStringRef)_url,
                                                                    CFSTR(""));
    return (__bridge NSString *)string ;
    

}

@end
