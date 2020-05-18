//
//  XingHengEditAdressViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengEditAdressViewController.h"
#import "CustomCityView.h"

@interface XingHengEditAdressViewController () <UITextViewDelegate,CustomCityViewDelegaet>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

@property (strong, nonatomic) NSString *provinceCode;
@property (strong, nonatomic) NSString *cityCode;

- (IBAction)selectCityAction:(id)sender;
- (IBAction)makeAction:(id)sender;

@end

@implementation XingHengEditAdressViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"编辑收货地址";
    
    self.cityLabel.text = QWGLOBALMANAGER.configure.addr;
    if (StrIsEmpty(QWGLOBALMANAGER.configure.info)) {
        self.detailTextView.text = @"";
        self.placeHolderLabel.text = @"请填写详细地址";
    }else{
        self.detailTextView.text = QWGLOBALMANAGER.configure.info;
        self.placeHolderLabel.text = @"";
    }
    
    
    self.detailTextView.delegate = self;
    
    self.makeBtn.layer.cornerRadius = 8.0;
    self.makeBtn.layer.masksToBounds = YES;
    
}

#pragma mark ---- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.text = @"请填写详细地址";
    }else{
        self.placeHolderLabel.text = @"";
        CGFloat length = textView.text.length;
        int len = length;
        if (len > 100) {
            textView.text = [textView.text substringToIndex:100];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 100) {
        textView.text = [temp substringToIndex:100];
        self.placeHolderLabel.text = @"";
        return NO;
    }
    return YES;
}


#pragma mark ---- 选择省市区 ----
- (IBAction)selectCityAction:(id)sender{
    CustomCityView *view = [CustomCityView sharedManager];
    view.delegate = self;
    [view show];
}

#pragma mark ---- 省市区代理 ----
- (void)getProvinceName:(NSString *)province provinceCode:(NSString *)provinceCode cityName:(NSString *)city cityCode:(NSString *)cityCode countryName:(NSString *)country countryCode:(NSString *)countryCode{
    
    self.cityLabel.textColor = RGBHex(qwColor1);
    self.cityLabel.text = [NSString stringWithFormat:@"%@%@",province,city];
    self.provinceCode = provinceCode;
    self.cityCode = cityCode;
}

#pragma mark ---- 保存 ----
- (IBAction)makeAction:(id)sender;
{
    if (StrIsEmpty(self.cityLabel.text)) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区"];
        return;
    }
    
    if (StrIsEmpty(self.detailTextView.text)) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    
    if (self.detailTextView.text.length < 5) {
        [SVProgressHUD showErrorWithStatus:@"详细地址不少于5个字"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    
    setting[@"province"] = self.provinceCode;
    setting[@"city"] = self.cityCode;
    setting[@"area"] = @"";
    setting[@"addr"] = self.cityLabel.text; //省市区全称
    setting[@"info"] = self.detailTextView.text; //详细地址
    
    [System CtmUpdateWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.code integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"编辑成功！"];
            QWGLOBALMANAGER.configure.addr = self.cityLabel.text;
            QWGLOBALMANAGER.configure.info = self.detailTextView.text;
            [QWGLOBALMANAGER saveAppConfigure];
            [self popVCAction:nil];
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
