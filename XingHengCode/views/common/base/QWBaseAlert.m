//
//  QWBaseAlert.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseAlert.h"

@interface QWBaseAlert()
{
    UIAlertView *alert;
    
}
@end
@implementation QWBaseAlert
@synthesize mainView=_mainView;
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//添加到windows 不要用super
- (void)addToWindow{
    if (_mainView!=nil) {
        CGRect frm=_mainView.bounds;
        self.frame=frm;
        [_mainView addSubview:self];
        [_mainView bringSubviewToFront:self];
    }
    else {
        UIWindow *win=[UIApplication sharedApplication].keyWindow;
        CGRect frm=win.bounds;
        self.frame=frm;
        [win addSubview:self];
        [win bringSubviewToFront:self];
    }
    
    vBG.translatesAutoresizingMaskIntoConstraints = YES;
    
    //    CGRect frm=vBG.frame;
    //    frm.size.width=AutoValue(frm.size.width);
    //    frm.size.height=AutoValue(frm.size.height);
    //    vBG.frame=frm;
    
    vBG.center=self.center;
}

- (void)UIGlobal{
    vBG.layer.cornerRadius=AutoValue(6);
    vBG.clipsToBounds=YES;
    
    
}

- (void)initAlert{
    [btn0 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    btn0.tag=0;
    btn1.tag=1;
    
    
}
- (void)UIInit{
    
}
- (void)show{
    [self initAlert];
    
    //    alert=nil;
    //    alert=[[UIAlertView alloc]init];
    //
    //    [alert show];
    
    [self addToWindow];
    [self UIGlobal];
    
    
    self.backgroundColor=RGBAHex(qwColor20, kShadowAlpha);
    self.alpha=0;
    [UIView animateWithDuration:kAlertDur animations:^{
        self.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    /*
     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
     
     // 动画选项设定
     animation.duration = kAlertDur; // 动画持续时间
     animation.repeatCount = 1; // 重复次数
     animation.autoreverses = NO; // 动画结束时执行逆动画
     
     // 缩放倍数
     animation.fromValue = [NSNumber numberWithFloat:2.0]; // 开始时的倍率
     animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
     
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     //    animation.fillMode = kCAFillModeForwards
     
     // 添加动画
     [vBG.layer addAnimation:animation forKey:@"scale-layer"];
     */
}

- (void)show:(id)obj block:(AlertSelectedBlock)block {
    if (block) {
        _selectedBlock=block;
    }
    [self show];
}

- (void)showNormal:(id)obj block:(AlertSelectedBlock)block
{
    if (block) {
        _selectedBlock=block;
    }
    [self show];
}


- (void)removeAlert{
    //    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)close:(int)tag{
    [UIView animateWithDuration:kAlertDur animations:^{
        //        self.backgroundColor=RGBAHex(kColor1, 0);
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _mainView=nil;
        
        if (self.selectedBlock) {
            self.selectedBlock(tag,nil);
        }
    }];
}

- (IBAction)clickAction:(UIButton *)sender{
    [self removeAlert];
    [self close:[sender tag]];
}


@end

