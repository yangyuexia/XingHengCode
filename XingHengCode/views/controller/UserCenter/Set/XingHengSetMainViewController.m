//
//  XingHengSetMainViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengSetMainViewController.h"
#import "XingHengUpdatePasswordViewController.h"
#import "XingHengEditMobileViewController.h"
#import "XingHengEditAdressViewController.h"

@interface XingHengSetMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)editNameAction:(id)sender;
- (IBAction)editMobileAction:(id)sender;
- (IBAction)setPwdAction:(id)sender;
- (IBAction)addressAction:(id)sender;

@end

@implementation XingHengSetMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑个人资料";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.accountLabel.text = QWGLOBALMANAGER.configure.username;
    self.nameLabel.text = QWGLOBALMANAGER.configure.nickname;
    self.mobileLabel.text = QWGLOBALMANAGER.configure.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",QWGLOBALMANAGER.configure.addr,QWGLOBALMANAGER.configure.info];
}

#pragma mark ---- 编辑姓名 ----
- (IBAction)editNameAction:(id)sender{
    XingHengEditMobileViewController *vc = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengEditMobileViewController"];
    vc.type = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 手机号码 ----
- (IBAction)editMobileAction:(id)sender{
    XingHengEditMobileViewController *vc = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengEditMobileViewController"];
    vc.type = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 设置密码 ----
- (IBAction)setPwdAction:(id)sender{
    XingHengUpdatePasswordViewController *vc = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengUpdatePasswordViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 收货地址 ----
- (IBAction)addressAction:(id)sender{
    XingHengEditAdressViewController *vc = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengEditAdressViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
