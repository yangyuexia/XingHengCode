//
//  cssex.h
//  APP
//
//  Created by Martin.Liu on 16/6/21.
//  Copyright © 2016年 carret. All rights reserved.
//


#ifndef cssex_h
#define cssex_h

#import "css.h"

#define QWCSS(_VIEW,_font,_color) QWCSSArgs(_font,_color,@[_VIEW])

#define QWStateCSS(_VIEW,_state,_font,_color) QWStateCSSArgs(_font,_color,UIControlStateNormal,@[_VIEW])

#define QWCSSArgs(_font,_color,...) QWStateCSSArgs(_font,_color,UIControlStateNormal,__VA_ARGS__)

#define QWStateCSSArgs(_font,_color,_state,...) \
{ \
    NSArray* _tmpArray = __VA_ARGS__; \
    for (UIView* VIEW in _tmpArray) \
    {\
        if ([VIEW isKindOfClass:[UILabel class]]) \
        { \
            ((UILabel*)VIEW).font = [UIFont systemFontOfSize:kFontS##_font]; \
            ((UILabel*)VIEW).textColor = RGBHex(qwColor##_color);   \
        } \
        else if ([VIEW isKindOfClass:[UIButton class]]) \
        { \
            ((UIButton*)VIEW).titleLabel.font = [UIFont systemFontOfSize:kFontS##_font]; \
            [((UIButton*)VIEW) setTitleColor:RGBHex(qwColor##_color) forState:_state]; \
        } \
    } \
}

#endif /* cssex_h */
