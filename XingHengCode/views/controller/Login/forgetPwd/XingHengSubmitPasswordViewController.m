//
//  XingHengSubmitPasswordViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/15.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengSubmitPasswordViewController.h"
#import "System.h"
#import "LoginViewController.h"

@interface XingHengSubmitPasswordViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBg_layout_height;

@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *circle2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)backAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end

@implementation XingHengSubmitPasswordViewController

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
    
    self.submitBtn.layer.cornerRadius = 8;
    self.submitBtn.layer.masksToBounds = YES;
    
    self.passwordTF.delegate = self;
    self.confirmPwdTF.delegate = self;
    self.passwordTF.tag = 1;
    self.confirmPwdTF.tag = 2;
    
    [self.passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmPwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    
    int maxNum = 12;
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

#pragma mark ---- 提交新密码 ----
- (IBAction)submitAction:(id)sender
{
    
    if (StrIsEmpty(self.passwordTF.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (StrIsEmpty(self.confirmPwdTF.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    
    if (![self.passwordTF.text isEqual:self.confirmPwdTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    
    
    if (![QWGLOBALMANAGER judgePassWordLegal:self.passwordTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6～12位的英文字母或数字"];
        return;
    }
    
    
    //调提交密码接口
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(self.tokenCode);
    setting[@"password"] = StrFromObj(self.passwordTF.text);
    setting[@"pass"] = StrFromObj(self.confirmPwdTF.text);
    
    [System CtmChangePwdWithParams:setting success:^(id obj) {
        BaseAPIModel *mdoel = [BaseAPIModel parse:obj];
        if ([mdoel.code integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
            
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIViewController *viewController = (UIViewController *)obj;
                if ([viewController isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                    
                }else if (idx == (self.navigationController.viewControllers.count-1)){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:mdoel.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
