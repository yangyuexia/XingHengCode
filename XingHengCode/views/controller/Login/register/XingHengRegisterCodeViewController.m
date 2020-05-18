//
//  XingHengRegisterCodeViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengRegisterCodeViewController.h"
#import "XingHengRegisterSuccessViewController.h"

@interface XingHengRegisterCodeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBg_layout_height;

@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *circle2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *keepBtn;

- (IBAction)backAction:(id)sender;
- (IBAction)keepAction:(id)sender;

@end


@implementation XingHengRegisterCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBg_layout_height.constant = 160-20+STATUS_H;
    self.codeTextField.text = StrFromInt(self.tokenCode);
    self.codeTextField.enabled = NO;
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
    
    self.keepBtn.layer.cornerRadius = 8;
    self.keepBtn.layer.masksToBounds = YES;
    
    self.codeTextField.delegate = self;
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    int maxNum = 100;
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 激活 Action ----
- (IBAction)keepAction:(id)sender;{
    
    NSString *code = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (StrIsEmpty(code)) {
        [SVProgressHUD showErrorWithStatus:@"请输入激活码"];
        return;
    }
    
    //调注册接口
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"id"] = code;
    
    [System CtmActivateWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.code integerValue] == 200) {

            XingHengRegisterSuccessViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengRegisterSuccessViewController"];
            vc.username = self.username;
            vc.password = self.password;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
