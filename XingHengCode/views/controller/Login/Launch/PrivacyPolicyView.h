//
//  PrivacyPolicyView.h
//  SportDi
//
//  Created by Yang Yuexia on 2019/12/23.
//  Copyright © 2019年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyPolicyView : UIView 

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UIView *webBg;
@property (strong, nonatomic) WKWebView *webView;

- (IBAction)agreeAction:(id)sender;

+ (PrivacyPolicyView *)sharedManager;
- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
