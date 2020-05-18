//
//  PrivacyPolicyView.m
//  SportDi
//
//  Created by Yang Yuexia on 2019/12/23.
//  Copyright © 2019年 Yang Yuexia. All rights reserved.
//

#import "PrivacyPolicyView.h"

@implementation PrivacyPolicyView

+ (PrivacyPolicyView *)sharedManager{
    return [[self alloc] init];
}

- (id)init{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"PrivacyPolicyView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);

        self.contentView.layer.cornerRadius = 7.0;
        self.contentView.layer.masksToBounds = YES;
        
        self.agreeBtn.layer.cornerRadius = 4.0;
        self.agreeBtn.layer.masksToBounds = YES;
        
        self.webView = [[WKWebView alloc] initWithFrame:self.webBg.bounds];
        [self.webView setOpaque:NO];
        self.webView.backgroundColor = [UIColor clearColor];
        [self.webBg addSubview:self.webView];
        
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.baidu.com"]];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        
    }
    return self;
}


- (IBAction)agreeAction:(id)sender {
    [self hidden];
    [QWUserDefault setBool:YES key:PRIVACYPOLICY];
}

- (void)show{
    if ([QWUserDefault getBoolBy:PRIVACYPOLICY]) {
        return;
    }
    
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    __weak PrivacyPolicyView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0.5;
    }];
}

- (void)hidden
{
    __weak PrivacyPolicyView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


@end
