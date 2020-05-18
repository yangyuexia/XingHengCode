//
//  XingHengRegisterViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengRegisterViewController.h"
#import "AccountModel.h"
#import "SBJson.h"
#import "CustomCityView.h"
#import "XingHengRegisterCodeViewController.h"

@interface XingHengRegisterViewController () <CustomCityViewDelegaet>
{
    BOOL haveRead;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBg_layout_height;

@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *circle2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *readImage;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) NSString *provinceText;
@property (strong, nonatomic) NSString *cityText;
@property (strong, nonatomic) NSString *provinceCode;
@property (strong, nonatomic) NSString *cityCode;

- (IBAction)backAction:(id)sender;
- (IBAction)selectCityAction:(id)sender;
- (IBAction)readAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)checkProtocolAction:(id)sender;

@end


@implementation XingHengRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    haveRead = NO;
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
    
    self.registerBtn.layer.cornerRadius = 8;
    self.registerBtn.layer.masksToBounds = YES;
    
    self.accountTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.mobileTextField.delegate = self;
    
    [self.accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark ---- 监听文本变化 ----
- (void)textFieldDidChange:(UITextField *)textField{
    UITextField *textView = textField;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            [self judgeTextFieldChange:textView];
        }
    }else{
        [self judgeTextFieldChange:textView];
    }
}

- (void)judgeTextFieldChange:(UITextField *)textField{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    int maxNum = 0;
    if (textView.tag == 1) { //account
        maxNum = 12;
    }else if (textView.tag == 2){ //name
        maxNum = 8;
    }else if (textView.tag == 3){ //pwd
        maxNum = 12;
    }else if (textView.tag == 4){ //mobile
        maxNum = 11;
    }
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.accountTextField) {
        [self checkHasAccount];
    }
}

- (void)checkHasAccount{
    HttpClientMgr.progressEnabled = NO;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"username"] = self.accountTextField.text;
    [IndexApi CtmHasAccountWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.code integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:@"账号已被使用"];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)readAction:(id)sender {
    if (haveRead) {
        haveRead = NO;
        self.readImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-normal"];
    }else{
        haveRead = YES;
        self.readImage.image = [UIImage imageNamed:@"icon-public-checkbox-circle-active"];
    }
}

#pragma mark ---- 选择城市 ----
- (IBAction)selectCityAction:(id)sender {
    [self.view endEditing:YES];
    CustomCityView *view = [CustomCityView sharedManager];
    view.delegate = self;
    [view show];
}

#pragma mark ---- 省市区代理 ----
- (void)getProvinceName:(NSString *)province provinceCode:(NSString *)provinceCode cityName:(NSString *)city cityCode:(NSString *)cityCode countryName:(NSString *)country countryCode:(NSString *)countryCode{
    self.cityLabel.textColor = RGBHex(qwColor1);
    self.cityLabel.text = [NSString stringWithFormat:@"%@ %@",province,city];
    self.provinceText = province;
    self.cityText = city;
    self.provinceCode = provinceCode;
    self.cityCode = cityCode;
}

#pragma mark ---- 查看用户协议 ----
- (IBAction)checkProtocolAction:(id)sender{
    
    
}

#pragma mark ---- 注册 Action ----
- (IBAction)registerAction:(id)sender{
    NSString *account = [self.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *mobile = [self.mobileTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (StrIsEmpty(account)) {
        [SVProgressHUD showErrorWithStatus:@"请输入账号"];
        return;
    }
    
    if (![QWGLOBALMANAGER judgePassWordLegal:account]) {
        [SVProgressHUD showErrorWithStatus:@"账号为6～12位的英文字母或数字"];
        return;
    }
    
    if (StrIsEmpty(name)) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的姓名"];
        return;
    }
    
    if (name.length < 2 || ![QWGLOBALMANAGER isChinese:name]) {
        [SVProgressHUD showErrorWithStatus:@"姓名长度为2～8个汉字"];
        return;
    }
    
    if (StrIsEmpty(password)) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (![QWGLOBALMANAGER judgePassWordLegal:password]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6～12位的英文字母或数字"];
        return;
    }
    
    if (StrIsEmpty(mobile)) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:mobile]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
        return;
    }
    
    if (StrIsEmpty(self.provinceText) || StrIsEmpty(self.cityText)) {
        [SVProgressHUD showErrorWithStatus:@"请选择省份/城市"];
        return;
    }
    
    if (!haveRead) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并接受用户协议"];
        return;
    }
    
    [self.view endEditing:YES];
    
    //调注册接口
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"username"] = account; //用户名
    setting[@"nickname"] = name; //姓名
    setting[@"password"] = password;
    setting[@"phone"] = mobile;
    setting[@"province"] = self.provinceCode;
    setting[@"city"] = self.cityCode;
    setting[@"area"] = @"";
    setting[@"addr"] = [NSString stringWithFormat:@"%@%@",self.provinceText,self.cityText]; //省市区全称
    setting[@"info"] = @""; //详细地址
    setting[@"id_card"] = @""; //身份证
    
    [System CtmRegisterWithParams:setting success:^(id obj) {
        RegisterInfoModel *registerModel = [RegisterInfoModel parse:obj];
        if ([registerModel.code integerValue] == 200) {
            
            XingHengRegisterCodeViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengRegisterCodeViewController"];
            vc.tokenCode = registerModel.token;
            vc.username = account;
            vc.password = password;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:registerModel.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
