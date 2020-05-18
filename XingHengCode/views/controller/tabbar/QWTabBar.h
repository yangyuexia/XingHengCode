//
//  QWTabBar.h
//  APP
//
//  Created by Yan Qingyang on 15/2/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTabBar.h"

enum  Enum_TabBar_Items {
    Enum_TabBar_Items_HomePage         = 0,     // 首页
    Enum_TabBar_Items_Classify         = 1,     // 分类
    Enum_TabBar_Items_UserCenter       = 2,     // 我的
};

@interface QWTabBar : QWBaseTabBar

/**
 *  初始化
 *
 *  @param dlg 托管delegate
 *
 *  @return 返回self
 */
- (id)initWithDelegate:(id)dlg;

@property (strong, nonatomic) UIButton *centerBtn;


@end
