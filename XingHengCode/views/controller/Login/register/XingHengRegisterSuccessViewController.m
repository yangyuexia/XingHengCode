//
//  XingHengRegisterSuccessViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengRegisterSuccessViewController.h"
#import "AccountModel.h"

@interface XingHengRegisterSuccessViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBg_layout_height;

@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *circle2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;

@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

- (IBAction)backAction:(id)sender;
- (IBAction)makeAction:(id)sender;

@end

@implementation XingHengRegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBg_layout_height.constant = 160-20+STATUS_H;
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configureUI{
    self.circle1.layer.cornerRadius = self.circle2.layer.cornerRadius = self.circle3.layer.cornerRadius = 10.0;
    self.circle1.layer.masksToBounds = self.circle2.layer.masksToBounds = self.circle3.layer.masksToBounds = YES;
    
    self.makeBtn.layer.cornerRadius = 8;
    self.makeBtn.layer.masksToBounds = YES;
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----  确定 Action ----
- (IBAction)makeAction:(id)sender{
    
    NSMutableDictionary *loginSetting = [NSMutableDictionary dictionary];
    loginSetting[@"username"] = StrFromObj(self.username);
    loginSetting[@"password"] = StrFromObj(self.password);
    
    [System LoginInfoWithParams:loginSetting success:^(id obj) {
        LoginTempModel *baseModel = [LoginTempModel parse:obj];
        if ([baseModel.code integerValue] == 200) {
            
            LoginInfoModel *loginModel = baseModel.data;
            QWGLOBALMANAGER.configure.token = obj[@"Request-Info"];
            QWGLOBALMANAGER.configure.id = loginModel.id;
            QWGLOBALMANAGER.configure.nickname = loginModel.nickname;
            QWGLOBALMANAGER.configure.phone = loginModel.phone;
            QWGLOBALMANAGER.configure.pic = loginModel.pic;
            QWGLOBALMANAGER.configure.username = loginModel.username;
            QWGLOBALMANAGER.configure.uuid = loginModel.uuid;
            QWGLOBALMANAGER.configure.passwordloginAccount = self.username;
            [QWGLOBALMANAGER saveAppConfigure];
            
            QWGLOBALMANAGER.loginStatus = YES;
            [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
            [QWGLOBALMANAGER loginSucess];
            [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            
        }else{
            [SVProgressHUD showErrorWithStatus:baseModel.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
    
}

@end
