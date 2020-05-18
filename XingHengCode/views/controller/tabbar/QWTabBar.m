//
//  QWTabBar.m
//  APP
//
//  Created by Yan Qingyang on 15/2/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWTabBar.h"

@interface QWTabBar ()

@end

@implementation QWTabBar

- (id)initWithDelegate:(id)dlg{
    self = [super init];
    if (self) {
        self.delegate=dlg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 *  初始化tab标签样式
 */

- (void)initTabBar
{
    QWTabbarItem *bar1=[QWTabbarItem new];
    bar1.title=@"首页";
    bar1.clazz=@"XingHengHomePageViewController";
    bar1.storyBoardName = @"HomePage";
    bar1.picNormal=@"icon-bottomNav-home-normal";
    bar1.picSelected=@"icon-bottomNav-home-active";
    bar1.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_HomePage];
    
    QWTabbarItem *bar2=[QWTabbarItem new];
    bar2.title=@"消息";
    bar2.clazz=@"XingHengMsgBoxViewController";
    bar2.storyBoardName = @"MsgBox";
    bar2.picNormal=@"icon-bottomNav-msg-normal";
    bar2.picSelected=@"icon-bottomNav-msg-active";
    bar2.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Classify];
    
    QWTabbarItem *bar4=[QWTabbarItem new];
    bar4.title=@"我的";
    bar4.clazz=@"XingHengUserCenterViewController";
    bar4.storyBoardName = @"UserCenter";
    bar4.picNormal=@"icon-bottomNav-mine-normal";
    bar4.picSelected=@"icon-bottomNav-mine-active";
    bar4.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_UserCenter];
    
    [self addTabBarItem:bar1,bar2,bar4, nil];
    
    [self backgroundColor:RGBHex(qwColor5)];
    [self separatorLine:RGBHex(qwColor4)];
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [QWLOADING removeLoading];
}



@end
