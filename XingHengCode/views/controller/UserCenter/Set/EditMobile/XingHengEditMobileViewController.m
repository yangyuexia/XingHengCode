//
//  XingHengEditMobileViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengEditMobileViewController.h"

@interface XingHengEditMobileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

- (IBAction)submitAction:(id)sender;

@end

@implementation XingHengEditMobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.type == 1) {
        self.title = @"修改姓名";
        self.tipLabel.text = @"姓名";
        self.textField.placeholder = @"请输入姓名，长度为2～8个汉字";
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.tag = 1;
        self.textField.text = QWGLOBALMANAGER.configure.nickname;
        
    }else if (self.type == 2){
        self.title = @"修改手机号";
        self.tipLabel.text = @"手机号码";
        self.textField.placeholder = @"请输入手机号码";
        self.textField.keyboardType = UIKeyboardTypePhonePad;
        self.textField.tag = 2;
        self.textField.text = QWGLOBALMANAGER.configure.phone;
    }
    
    self.makeBtn.layer.cornerRadius = 8.0;
    self.makeBtn.layer.masksToBounds = YES;
    
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
    if (textView.tag == 2) { //手机号
        maxNum = 11;
    }else if (textView.tag == 1){ // name
        maxNum = 8;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
}

#pragma mark ---- 提交 ----
- (IBAction)submitAction:(id)sender
{
    NSString *textStr = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.type == 1) {
        
        if (StrIsEmpty(textStr)) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的姓名"];
            return;
        }
        
        if (textStr.length < 2 || ![QWGLOBALMANAGER isChinese:textStr]) {
            [SVProgressHUD showErrorWithStatus:@"姓名长度为2～8个汉字"];
            return;
        }
        
        //修改姓名接口
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"nickname"] = textStr;
        
        [System CtmUpdateWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                QWGLOBALMANAGER.configure.nickname = textStr;
                [QWGLOBALMANAGER saveAppConfigure];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.message];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
        }];
        
        
        
        
    }else if (self.type == 2){
        
        if (StrIsEmpty(textStr)) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
            return;
        }
        
        if (![QWGLOBALMANAGER isTelPhoneNumber:textStr]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
            return;
        }
        
        //修改手机号接口
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"phone"] = textStr;
        
        [System CtmUpdateWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                QWGLOBALMANAGER.configure.phone = textStr;
                [QWGLOBALMANAGER saveAppConfigure];
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
    [self. view endEditing:YES];
}

@end
