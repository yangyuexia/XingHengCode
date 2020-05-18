//
//  SystemMacro.h
//  APP
//
//  Created by carret on 15/3/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#ifndef APP_SystemMacro_h
#define APP_SystemMacro_h

#define PORID_IMAGE(proId) (((NSString *)proId).length == 6)? [NSString stringWithFormat:@"%@middle/%@/%@/%@/1.JPG",IMAGE_PRFIX,[proId substringWithRange:NSMakeRange(0, 2)],[proId substringWithRange:NSMakeRange(2, 2)],[proId substringWithRange:NSMakeRange(4, 2)]] : @""

#endif
