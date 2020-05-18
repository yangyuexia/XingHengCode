//
//  LoginViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 17/2/22.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "LoginViewController.h"
#import "XingHengRegisterViewController.h"
#import "AccountModel.h"
#import "XingHengForgetPasswordViewController.h"
#import "AppDelegate.h"
#import "ReturnIndexView.h"

@interface LoginViewController () <ReturnIndexViewDelegate>
{
    BOOL isVisible; // 密码是否可见
    BOOL isRemPwd;
    BOOL isAutoLogin;
}

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIImageView *visibleImageView;

@property (weak, nonatomic) IBOutlet UIImageView *keepPwdImage;
@property (weak, nonatomic) IBOutlet UIImageView *autoLoginImage;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) ReturnIndexView *returnIndexView;


- (IBAction)selectSubAccountAction:(id)sender;
- (IBAction)visiblePwdAction:(id)sender;
- (IBAction)forgetPwdAction:(id)sender;

- (IBAction)keepPwdAction:(id)sender;
- (IBAction)autoLoginAction:(id)sender;

- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    
    NSMutableArray *cacheArray = [NSMutableArray arrayWithArray:[QWUserDefault getObjectBy:ISLOGINACCOUNTLIST]];
    if (cacheArray.count > 0) {
        RemAccountModel *model = [cacheArray firstObject];
        [self refreshAccountUI:model];
    }
    
    if ([QWUserDefault getBoolBy:ISAUTOLOGIN]) {
        isAutoLogin = YES;
        self.autoLoginImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-active"];
    }else {
        isAutoLogin = NO;
        self.autoLoginImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-normal"];
    }
    
}

- (void)refreshAccountUI:(RemAccountModel *)model{
    self.accountTF.text = model.userName;
    if (model.isRemPwd) {
        self.pwdTF.text = model.password;
        isRemPwd = YES;
        self.keepPwdImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-active"];
    }else{
        self.pwdTF.text = @"";
        isRemPwd = NO;
        self.keepPwdImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-normal"];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark ---- 设置UI ----
- (void)configureUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginBtn.layer.cornerRadius = self.registerBtn.layer.cornerRadius = 8;
    self.loginBtn.layer.masksToBounds = self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.backgroundColor = [UIColor whiteColor];
    self.registerBtn.layer.borderColor = RGBHex(0xB6B6B9).CGColor;
    self.registerBtn.layer.borderWidth = 1.0;
    
    self.visibleImageView.image = [UIImage imageNamed:@"icon-eye-hidden"];
    self.pwdTF.secureTextEntry = YES;
    
    self.accountTF.delegate = self;
    self.pwdTF.delegate = self;
    self.accountTF.tag = 1;
    self.pwdTF.tag = 2;
    
    [self.accountTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark ---- 监听文本变化 ----
- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            [self judgeTextFieldChange:textView];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldChange:textView];
    }
}

- (void)judgeTextFieldChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum = 0;
    if (textView.tag == 1) { //账号
        maxNum = 12;
    }else if (textView.tag == 2){ //密码
        maxNum = 12;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

#pragma mark ---- 选择子账号 ----
- (IBAction)selectSubAccountAction:(id)sender {
    
    UIButton *tempBut = (UIButton *)sender;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [tempBut convertRect:tempBut.bounds toView:window];
    
    NSMutableArray *cacheArray = [NSMutableArray arrayWithArray:[QWUserDefault getObjectBy:ISLOGINACCOUNTLIST]];
    if (cacheArray.count > 0) {
        self.returnIndexView = [ReturnIndexView sharedManagerTitle:cacheArray isHidden:NO frame:rect];
        self.returnIndexView.returnIndexViewDelegate = self;
        [self.returnIndexView show];
    }

}

- (void)RetunIndexView:(ReturnIndexView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath{
    [self.returnIndexView hide];
    
    NSMutableArray *cacheArray = [NSMutableArray arrayWithArray:[QWUserDefault getObjectBy:ISLOGINACCOUNTLIST]];
    if (cacheArray.count > 0) {
        RemAccountModel *model = cacheArray[indexPath.row];
        [self refreshAccountUI:model];
    }
}

#pragma mark ---- 设置密码是否可见 ----
- (IBAction)visiblePwdAction:(id)sender{
    if (isVisible){// 密码隐藏
        self.visibleImageView.image = [UIImage imageNamed:@"icon-eye-hidden"];
        self.pwdTF.secureTextEntry = YES;
        isVisible = NO;
    }else{// 密码可见
        self.visibleImageView.image = [UIImage imageNamed:@"icon-eye-open"];
        self.pwdTF.secureTextEntry = NO;
        isVisible = YES;
    }
}

#pragma mark ---- 忘记密码 Action ----
- (IBAction)forgetPwdAction:(id)sender
{
    XingHengForgetPasswordViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengForgetPasswordViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 记住密码 ----
- (IBAction)keepPwdAction:(id)sender{
    if (isRemPwd) {
        isRemPwd = NO;
        self.keepPwdImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-normal"];
    }else{
        isRemPwd = YES;
        self.keepPwdImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-active"];
    }
    
}

#pragma mark ---- 自动登录 ----
- (IBAction)autoLoginAction:(id)sender{
    if (isAutoLogin) {
        isAutoLogin = NO;
        self.autoLoginImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-normal"];
    }else{
        isAutoLogin = YES;
        self.autoLoginImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-active"];
    }
}

#pragma mark ---- 注册 Action ----
- (IBAction)registerAction:(id)sender {
    XingHengRegisterViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengRegisterViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- login Action ----
- (IBAction)loginAction:(id)sender
{
    NSString *accountStr = [self.accountTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr = [self.pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (StrIsEmpty(accountStr)) {
        [SVProgressHUD showErrorWithStatus:@"请输入账号"];
        return;
    }
    
    if (StrIsEmpty(passwordStr)) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self accountLogin:accountStr pwd:passwordStr];
    
}

- (void)accountLogin:(NSString *)account pwd:(NSString *)password
{
    NSMutableDictionary *loginSetting = [NSMutableDictionary dictionary];
    loginSetting[@"username"] = StrFromObj(account);
    loginSetting[@"password"] = StrFromObj(password);
    
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
            QWGLOBALMANAGER.configure.passwordloginAccount = account;
            [QWGLOBALMANAGER saveAppConfigure];
            
            QWGLOBALMANAGER.loginStatus = YES;
            [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
            [QWGLOBALMANAGER loginSucess];
            [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
            
    
            if (self->isAutoLogin) {
                [QWUserDefault setBool:YES key:ISAUTOLOGIN];
            }else{
                [QWUserDefault setBool:NO key:ISAUTOLOGIN];
            }
            
            
            //缓存下拉账号列表
            NSMutableArray *cacheArray = [NSMutableArray arrayWithArray:[QWUserDefault getObjectBy:ISLOGINACCOUNTLIST]];
            for (RemAccountModel *cache in cacheArray) {
                if ([cache.userName isEqualToString:account]) {
                    [cacheArray removeObject:cache];
                    break;
                }
            }
            RemAccountModel *mm = [RemAccountModel new];
            mm.userName = account;
            mm.password = password;
            mm.isRemPwd = self->isRemPwd;
            [cacheArray insertObject:mm atIndex:0];
            [QWUserDefault setObject:cacheArray key:ISLOGINACCOUNTLIST];
            
            
            if(self.loginSuccessBlock){
                self.loginSuccessBlock();
            }
            
            if (self.passTokenBlock) {
                self.passTokenBlock(loginModel.token);
            }
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:baseModel.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
