//
//  XingHengBindBatteryViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/5/4.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengBindBatteryViewController.h"
#import "XingHengScanQueryViewController.h"

@interface XingHengBindBatteryViewController ()

@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

- (IBAction)makeAction:(id)sender;
- (IBAction)scanAction:(id)sender;

@end

@implementation XingHengBindBatteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更换电池信息绑定";
    
    self.textField.delegate = self;
    self.textBg.layer.cornerRadius = 8.0;
    self.textBg.layer.masksToBounds = YES;
    self.textBg.layer.borderColor = RGBHex(0xE6E6EB).CGColor;
    self.textBg.layer.borderWidth = 1.0;
    self.makeBtn.layer.cornerRadius = 8;
    self.makeBtn.layer.masksToBounds = YES;
    
}

#pragma mark ---- 扫码 ----
- (IBAction)scanAction:(id)sender {
    XingHengScanQueryViewController *vc = [[UIStoryboard storyboardWithName:@"WarrantyQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengScanQueryViewController"];
    vc.scanBlock = ^(NSString *barCode) {
        self.textField.text = barCode;
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 查询 ----
- (IBAction)makeAction:(id)sender {
    if (StrIsEmpty(self.textField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入电池编码"];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"old_bar_code"] = self.oldBarCode;
    setting[@"bar_code"] = self.textField.text;
    [IndexApi EqpBandWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.code integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"更换成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
