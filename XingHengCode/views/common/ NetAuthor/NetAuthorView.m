//
//  NetAuthorView.m
//  wenYao-store
//
//  Created by Yang Yuexia on 2018/6/13.
//  Copyright © 2018年 carret. All rights reserved.
//

#import "NetAuthorView.h"
#import "CheckNetSolutionViewController.h"

@implementation NetAuthorView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"NetAuthorView" owner:self options:nil];
        self = array[0];
        self.frame = frame;
        
        self.check_layout_width.constant = 100;
        
        self.checkLabel.layer.cornerRadius = 2.0;
        self.checkLabel.layer.masksToBounds = YES;
        self.checkLabel.layer.borderColor = RGBHex(qwColor2).CGColor;
        self.checkLabel.layer.borderWidth = 0.5;
        
    }
    return self;
}

- (IBAction)checkAction:(id)sender {
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
        if ([vcTab isKindOfClass:[QWTabBar class]]) {
            UINavigationController *vcNavi = (UINavigationController *)vcTab.selectedViewController;
            CheckNetSolutionViewController *vc = [[UIStoryboard storyboardWithName:@"CheckNetSolution" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckNetSolutionViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [vcNavi pushViewController:vc animated:YES];
        }
        
    }else{
        if (self.CheckNetworkBlock) {
            self.CheckNetworkBlock();
        }
    }
}

@end
