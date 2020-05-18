/*!
 @header css.h
 @abstract 样式表常量及有关UI界面相关宏方法
 @author .
 @version 1.00 2015/01/01  (1.00)
 */

#ifndef CSS_h
#define CSS_h

#define kShadowAlpha    0.4

/**
 *  所有涉及颜色，字体，字体大小必须按格式调用
 */

/**
 *  颜色样式表
 *  根据UI色表定义
 */

#define qwColor1     0x333333
#define qwColor2     0x666666
#define qwColor3     0x999999
#define qwColor4     0xcccccc
#define qwColor5     0xffffff
#define qwColor6     0x3779f6
#define qwColor8     0xfde8e8
#define qwColor10    0xff9a9a
#define qwColor11    0xf2f2f2
#define qwColor12    0xe6e6e6
#define qwColor14    0xf1f1f1

#define qwColor20    0x34a398
#define qwColor21    0x6de2bb
#define qwColor22    0xaef0da
#define qwColor23    0xffc107

#define qwColor24    0xdddde0


#define kFontS1      18
#define kFontS2      16
#define kFontS3      15
#define kFontS4      14
#define kFontS5      13
#define kFontS6      12
#define kFontS7      11
#define kFontS8      10
#define kFontS9      9
#define kFontS10     20
#define kFontS11     31
#define kFontS12     24
#define kFontS13     21
#define kFontS14     27
#define kFontS15     25
#define kFontS16     34

#define MYGREEN [UIColor colorWithRed:27/255.0 green:153/255.0 blue:52/255.0 alpha:1.0]


/**
 *  文字样式表
 */
#define kFont1 @"Helvetica"
#define kFont2 @"Helvetica-Bold"
#define kFont3 @"STHeitiSC-Medium"
#define kFont4 @"STHeitiSC-Light"

#endif

#define HIGH_RESOLUTION             ([UIScreen mainScreen].bounds.size.height > 480)

#define TAG_BASE            100000

#define NAV_H               44
#define TAB_H               49

#define MAX_SIZE 130 //　图片最大显示大小
