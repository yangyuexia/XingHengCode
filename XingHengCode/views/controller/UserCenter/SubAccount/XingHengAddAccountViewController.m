//
//  XingHengAddAccountViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengAddAccountViewController.h"

@interface XingHengAddAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
- (IBAction)makeAction:(id)sender;

@end

@implementation XingHengAddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isAddAccount) {
        self.title = @"添加子账号";
        self.accountTextField.enabled = YES;
        self.pwdTextField.enabled = YES;
    }else{
        self.title = @"子账号详情";
        self.accountTextField.enabled = NO;
        self.pwdTextField.enabled = NO;
        self.accountTextField.text = self.listModel.username;
        self.nameTextField.text = self.listModel.nickname;
        self.pwdTextField.text = self.listModel.password;
        self.mobileTextField.text = self.listModel.phone;
    }
 
    [self configureUI];
}

- (void)configureUI{
    self.makeBtn.layer.cornerRadius = 8;
    self.makeBtn.layer.masksToBounds = YES;
    
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


#pragma mark ---- 注册 Action ----
- (IBAction)makeAction:(id)sender{
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
    
    if (self.isAddAccount) {
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"username"] = account; //用户名
        setting[@"nickname"] = name; //姓名
        setting[@"password"] = password;
        setting[@"phone"] = mobile;
        [System CtmSubAddWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.message];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
        }];
        
    }else{
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"id"] = self.listModel.id; //用户名
        setting[@"nickname"] = name; //姓名
        setting[@"phone"] = mobile;
        [System CtmSubUpdateWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.message];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
        }];
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}




@end
