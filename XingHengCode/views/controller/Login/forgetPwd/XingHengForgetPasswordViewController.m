//
//  XingHengForgetPasswordViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/15.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengForgetPasswordViewController.h"
#import "XingHengSubmitPasswordViewController.h"

@interface XingHengForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBg_layout_height;

@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *circle2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


- (IBAction)backAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end

@implementation XingHengForgetPasswordViewController

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
    
    self.registerBtn.layer.cornerRadius = 8;
    self.registerBtn.layer.masksToBounds = YES;
    
    self.accountTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.mobileTextField.delegate = self;
    
    [self.accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    }else if (textView.tag == 3){ //mobile
        maxNum = 11;
    }
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 下一步 Action ----
- (IBAction)registerAction:(id)sender{
    NSString *account = [self.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    
    if (StrIsEmpty(mobile)) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:mobile]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
        return;
    }
    
    
    
    
    //调校验用户信息接口
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"username"] = account; //用户名
    setting[@"nickname"] = name; //姓名
    setting[@"phone"] = mobile;
    
    [System CtmForgetPwdCheckWithParams:setting success:^(id obj) {
        ForgetPwdModel *registerModel = [ForgetPwdModel parse:obj];
        if ([registerModel.code integerValue] == 200) {
            
            XingHengSubmitPasswordViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengSubmitPasswordViewController"];
            vc.tokenCode = registerModel.token;
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
