//
//  QWBaseViewController.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseViewController.h"
#import "GlobalManager.h"

@interface QWBaseViewController ()

@end

@implementation QWBaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self UIGlobal];
    [self addObserverGlobal];
}

- (void)dealloc{
    [self removeObserverGlobal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)UIGlobal{
    
}

#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
}

- (void)removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQWGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{
    //NSLog(@"%@",sender);
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([GLOBALMANAGER object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj{
    
}

@end
