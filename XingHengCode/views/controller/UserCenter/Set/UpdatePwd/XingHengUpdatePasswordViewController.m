//
//  XingHengUpdatePasswordViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengUpdatePasswordViewController.h"

@interface XingHengUpdatePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *newwPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;

@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
- (IBAction)submitAction:(id)sender;

@end


@implementation XingHengUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码设置";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.oldPwdTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.newwPwdTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.confirmPwdTF];
    
    self.makeBtn.layer.cornerRadius = 8.0;
    self.makeBtn.layer.masksToBounds = YES;
    
}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldDidChange:(NSNotification *)notification
{
    UITextField *textView = (UITextField *)notification.object;
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
    UITextField *textView = (UITextField *)textField;
    NSString *toBeString = textView.text;
    
    int maxNUm = 12;
    if (toBeString.length > maxNUm) {
        textView.text = [toBeString substringToIndex:maxNUm];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)submitAction:(id)sender {
    
    if (StrIsEmpty(self.oldPwdTF.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入当前密码"];
        return;
    }
    
    if (StrIsEmpty(self.newwPwdTF.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    
    if (StrIsEmpty(self.confirmPwdTF.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    
    if (![self.newwPwdTF.text isEqualToString:self.confirmPwdTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    if (![QWGLOBALMANAGER judgePassWordLegal:self.newwPwdTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6～12位的英文字母或数字"];
        return;
    }
    
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"password"] = StrFromObj(self.oldPwdTF.text);
    setting[@"pass"] = StrFromObj(self.newwPwdTF.text);
    setting[@"checkPass"] = StrFromObj(self.newwPwdTF.text);
    
    [System CtmChangePToWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.code integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
    
}


@end
