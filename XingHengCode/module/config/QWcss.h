/*!
 @header QWcss.h
 @abstract 样式表常量及有关UI界面相关宏方法
 @author .
 @version 1.00 2015/03/06  (1.00)
 */

#ifndef QW_CSS_h
#define QW_CSS_h


/**
 *  边距
 */
typedef NS_ENUM(NSInteger, Enum_Edge){
    /**
     *  右边距
     */
    EdgeRight = 1 << 1,
    /**
     *  左
     */
    EdgeLeft = 1 << 2,
    
    EdgeTop = 1 << 3,
    EdgeBottom = 1<< 4,
};

/**
 *  使用rgb颜色
 */
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/**
 *  使用16位表达
 */
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAHex(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)]

/**
 *  使用字体
 */
#define font(fontName,fontSize)         [UIFont fontWithName:fontName size:fontSize]
#define fontSystem(fontSize)            [UIFont systemFontOfSize:fontSize]
#define fontSystemBold(fontSize)        [UIFont boldSystemFontOfSize:fontSize]

/**
 *  屏幕大小常量
 */
#define APP_W               [UIScreen mainScreen].applicationFrame.size.width
#define APP_H               [UIScreen mainScreen].applicationFrame.size.height
#define SCREEN_W            [UIScreen mainScreen].bounds.size.width  //屏幕宽
#define SCREEN_H            [UIScreen mainScreen].bounds.size.height //屏幕高
#define STATUS_H            [UIApplication sharedApplication].statusBarFrame.size.height

#define STATUS_BAR_HEIGHT ([UIApplication sharedApplication].statusBarHidden? 0.0 : 20.0)


/**
 *  设置位置大小
 */
#define RECT(x,y,w,h)       CGRectMake(x,y,w,h)

/**
 *  带适配的设置位置大小
 */
#define kAutoScale          APP_W/320
#define AutoRect(x,y,w,h)   CGRectMake(x*kAutoScale,y*kAutoScale,w*kAutoScale,h*kAutoScale)
#define AutoSize(w,h)       CGSizeMake(w*kAutoScale,h*kAutoScale)
#define AutoValue(ss)       ss*kAutoScale
#define AutoMoveValue(ss)   ss+(APP_W-320)/2
#endif
