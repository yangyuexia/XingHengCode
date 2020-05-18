//
//  QWLoading.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWLoading.h"
#import "UIImage+GIF.h"
#import "QWGlobalManager.h"
#import "XingHengHomePageViewController.h"
#import "XingHengMsgBoxViewController.h"
#import "XingHengUserCenterViewController.h"

@interface QWLoading()
{
    UIImageView *imgvLoading, *imgvBG;
    BOOL canMove;
}
@end

@implementation QWLoading

@synthesize delegate=_delegate;

+ (instancetype)instance{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+(instancetype)instanceWithDelegate:(id)delegate{
    QWLoading* obj=[self instance];
    obj.delegate=delegate;
    return obj;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.minShowTime=0.5;
        canMove=YES;
    }
    return self;
}


- (void)showLoading {
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _showLoading];
    });
}

- (void)removeLoading
{
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _removeLoading];
    });
}

- (void)stopLoading
{
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _stopLoading];
    });
}

- (void)closeLoading
{
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _closeLoading];
    });
}

- (void)_showLoading{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    if(win == nil){
        return;
    }
    
    if ([[QWGLOBALMANAGER currentViewController] isKindOfClass:[XingHengHomePageViewController class]] || [[QWGLOBALMANAGER currentViewController] isKindOfClass:[XingHengMsgBoxViewController class]] || [[QWGLOBALMANAGER currentViewController] isKindOfClass:[XingHengUserCenterViewController class]]) {
        self.frame = CGRectMake(0, 0, APP_W, SCREEN_H-49);
    }else{
        self.frame = CGRectMake(0, 0, APP_W, SCREEN_H);
    }
    
    CGRect frm;
    
    if (imgvLoading==nil) {
        
        CGSize sz=CGSizeMake(26, 26);
        frm.size=sz;
        frm.origin.x=self.bounds.size.width/2-sz.width/2;
        frm.origin.y=self.bounds.size.height/2-sz.height/2;
        
        imgvBG = nil;
        imgvBG = [[UIImageView alloc] initWithFrame:frm];
        
        
        NSMutableArray *arrImgs = [NSMutableArray arrayWithCapacity:49];
        for(NSInteger index = 0; index < 12; ++index)
        {
            [arrImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"newloading%ld",1+index]]];
        }
        
        frm.size=sz;
        frm.origin.x=self.bounds.size.width/2-sz.width/2;
        frm.origin.y=self.bounds.size.height/2-sz.height/2;
        
        imgvLoading = [[UIImageView alloc] initWithFrame:frm];
        imgvLoading.animationImages = arrImgs;
        imgvLoading.animationDuration = 0.8;
        imgvLoading.animationRepeatCount = 0;
        [imgvLoading startAnimating];
        
        [self addSubview:imgvBG];
        [self addSubview:imgvLoading];
        
        
    }
    [win addSubview:self];
    [win bringSubviewToFront:imgvBG];
    [win bringSubviewToFront:imgvLoading];
    
    canMove=NO;
}

- (void)_removeLoading{
    canMove=YES;
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:self.minShowTime];
}

- (void)_stopLoading{
    if (canMove==NO) {
        return;
    }
    
    [self removeFromSuperview];
}

- (void)removeLoadingByTouch{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(hudStopByTouch:)]) {
        [self.delegate hudStopByTouch:self];
    }
    
    [self removeFromSuperview];
}

- (void)_closeLoading{
    
    [self removeFromSuperview];
}
#pragma mark - 触摸关闭loading

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UIWindow *win=[UIApplication sharedApplication].delegate.window;
    UITouch *et = [[event allTouches] anyObject];
    CGPoint ep = [et locationInView:win];
    
    
    CGRect navRect=(CGRect){0,0,120,64};
    if (([self superview].bounds.size.height>=win.bounds.size.height) && CGRectContainsPoint(navRect, ep)) {
        [self removeLoadingByTouch];
    }
}

@end
