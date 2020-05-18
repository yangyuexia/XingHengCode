//
//  GlobalManager.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "GlobalManager.h"
#import "SystemMacro.h"

@implementation GlobalManager

+ (GlobalManager *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)isStringEmpty:(id)obj{
    if (obj==nil || [obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj length]==0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark 判断
- (BOOL)isNULL:(id)obj{
    if (obj==nil || [obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)object:(id)obj isClass:(Class)aClass {
    if (![self isNULL:obj] && [obj isKindOfClass:aClass]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPhoneNumber:(NSString*)text
{
    NSString * regex = @"^([1])([0-9]{10})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}


+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue +
                         [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

+ (BOOL)checkIDCard:(NSString *)str{
    //max 2013年以后，15位身份证失效
    if (str==nil||str.length<=0) {
        return NO;
    }
    return checkIDfromchar((char *)[[str uppercaseString] UTF8String]);
}

//验证身份证是否有效 //max
int checkIDfromchar (const char *sPaperId)
{
    if( 18 != strlen(sPaperId)) return 0;  //检验长度
    long lSumQT =0;
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };   //加权因子
    char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};  //校验码
    //校验数字
    for (int i=0; i<18; i++){
        if ( !isdigit(sPaperId[i]) && !('X' == sPaperId[i] && 17 == i) ) {
            return 0;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)  {
        lSumQT += (sPaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != sPaperId[17] ){
        return 0;
    }
    return 1;
}

#pragma mark 发出全局通知
- (NSDictionary *)postNotif:(NSInteger)type data:(id)data object:(id)obj{
    NSMutableDictionary *info=[NSMutableDictionary dictionary];
    [info setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (data) {
        [info setObject:data forKey:@"data"];
    }
    if (obj) {
        [info setObject:obj forKey:@"object"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kQWGlobalNotification object:obj userInfo:info];
    return info;
}

#pragma mark 文字高度

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
}

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font constrainedToSize:(CGSize)size{
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
}
#pragma mark 设置边距
- (void)setObject:(UIView*)object margin:(CGFloat)margin edge:(Enum_Edge)edge{
    if (object && [object isMemberOfClass:[UIView class]]) {
        CGRect frm=object.frame;
        if (edge & EdgeLeft) {
            frm.size.width -= margin;
            frm.origin.x = margin;
        }
        if (edge & EdgeRight) {
            frm.size.width -= margin;
        }
        if (edge & EdgeTop) {
            frm.size.height -= margin;
            frm.origin.y = margin;
        }
        if (edge & EdgeBottom) {
            frm.size.height -= margin;
        }
        
        object.frame=frm;
    }
}

/**
 *  @brief 判断是否包含数字或字母
 *
 *  @return YES表示包含, NO表示不包含
 */

- (BOOL)isContainNumOrABC:(NSString *)str
{
    NSString * regex = @"^[A-Za-z0-9]{1,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isContain = [predicate evaluateWithObject:str];
    return isContain;
}


/*
 电话号码情况
 手机号：11位，1开头
 座机号：
 a.    2位区号+6-8座机（有-和无-）
 b.    3位区号+7-8座机（有-和无-）
 c.    4位区号+7-8座机（有-和无-）
 d.    5位区号+8座机（有-和无-）
 400电话：10位
 */

- (BOOL)isTelPhoneNumber:(NSString *)text
{
    if (text.length <= 0) {
        return NO;
    }
    
    if (istelString(text)) {//如果包含特殊字符
        
        if ([self isPhoneNumber:text]){//是手机号
            return YES;
        }else{//不是手机号,判断是不是座机号
            
            NSString *firstStr = [text substringToIndex:1];
            
            if ([firstStr isEqualToString:@"4"]) {//如果是4开头的
                
                if (text.length == 10) {
                    return YES;
                }
                return NO;
            }else if ([firstStr isEqualToString:@"0"]){//如果是0开头的
                NSString *phoneRegexA = @"^((\\d{2}-)|\\d{2})\\d{6,8}$"; //a.    2位区号+6-8座机（有-和无-）
                NSString *phoneRegexB = @"^((\\d{3}-)|\\d{3})\\d{7,8}$"; //b.    3位区号+7-8座机（有-和无-）
                NSString *phoneRegexC = @"^((\\d{4}-)|\\d{4})\\d{7,8}$"; //c.    4位区号+7-8座机（有-和无-）
                NSString *phoneRegexD = @"^((\\d{5}-)|\\d{5})\\d{8}$";   //d.    5位区号+8座机（有-和无-）
                
                if (isTelNum(text, phoneRegexA) || isTelNum(text, phoneRegexB) || isTelNum(text, phoneRegexC) || isTelNum(text, phoneRegexD)) {
                    
                    return YES;
                }
            }
            return NO;
        }
    }
    return NO;
}

BOOL istelString(NSString *text){
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"-0123456789"] invertedSet];
    NSRange NameRange = [text rangeOfCharacterFromSet:nameCharacters];
    if (NameRange.location == NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

BOOL isTelNum(NSString *text,NSString *phoneRegexA)
{
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegexA];
    
    if ([phoneTest evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}


#pragma mark 文字高度
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.height=height;
    rect.size.width=ceil(rect.size.width);
    return rect.size;
}


@end
