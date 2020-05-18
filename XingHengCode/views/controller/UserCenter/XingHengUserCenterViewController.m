//
//  XingHengUserCenterViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengUserCenterViewController.h"
#import "LoginViewController.h"
#import "XingHengUserCenterCell.h"
#import "XingHengSetMainViewController.h"
#import "UserInfoModel.h"
#import "AccountModel.h"
#import "XingHengAboutViewController.h"
#import "XingHengSubAccountViewController.h"
#import "XingHengSetBlueToothViewController.h"

@interface XingHengUserCenterViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *imageList;

- (IBAction)setAction:(id)sender;

@end

@implementation XingHengUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    self.dataList = [NSMutableArray arrayWithObjects:@[@"锂电检测仪蓝牙设置"],@[@"子账号管理",@"关于APP"],@[@"退出登录"], nil];
    self.imageList = [NSMutableArray arrayWithObjects:@[@"icon-mine-lanya"],@[@"icon-mine-zhanghao-manage",@"icon-mine-about-us"],@[@"icon-mine-log-out"], nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpHeaderView];
    [self queryUserInfo];
    [self.tableView reloadData];
    
}

#pragma mark ---- 获取用户详情 ----
- (void)queryUserInfo{
    HttpClientMgr.progressEnabled = NO;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    [System CtmInfoWithParams:setting success:^(id obj) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"ctm"]];
        dic[@"code"] = obj[@"code"];
        dic[@"message"] = obj[@"message"];
        
        AccountModel *accountModel = [AccountModel parse:dic];
        if ([accountModel.code integerValue] == 200) {
            QWGLOBALMANAGER.configure.addr = accountModel.addr;
            QWGLOBALMANAGER.configure.area = accountModel.area;
            QWGLOBALMANAGER.configure.city = accountModel.city;
            QWGLOBALMANAGER.configure.province = accountModel.province;
            QWGLOBALMANAGER.configure.state = accountModel.state;
            QWGLOBALMANAGER.configure.info = accountModel.info;
            QWGLOBALMANAGER.configure.password = accountModel.password;
            [QWGLOBALMANAGER saveAppConfigure];
            
            [self setUpHeaderView];
        }else{
            [SVProgressHUD showErrorWithStatus:accountModel.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
    
}

- (void)setUpHeaderView{
    self.nickLabel.text = QWGLOBALMANAGER.configure.nickname;
    self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",QWGLOBALMANAGER.configure.username];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 16)];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 12.0;
    cell.backgroundColor = [UIColor clearColor];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, 16, 0);
    
    if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        
    }else{
        if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
        }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }else{
            CGPathAddRect(pathRef, nil, bounds);
        }
    }
    
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = RGBHex(0xE6E6EB).CGColor;
    layer.lineWidth = 1.0;
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = roundView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XingHengUserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengUserCenterCell"];
    cell.titleLabel.text = self.dataList[indexPath.section][indexPath.row];
    cell.icon.image = [UIImage imageNamed:self.imageList[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //蓝牙设置
        XingHengSetBlueToothViewController *vc = [[UIStoryboard storyboardWithName:@"SetBlueTooth" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengSetBlueToothViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        //子账号管理
        XingHengSubAccountViewController *vc = [[UIStoryboard storyboardWithName:@"SubAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengSubAccountViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        //关于app
        XingHengAboutViewController *vc = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengAboutViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        //退出登录
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //[System SubjectLogoutWithParams:nil success:nil failure:nil];
            [QWGLOBALMANAGER clearAccountInformation:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}


#pragma mark ---- 设置 ----
- (IBAction)setAction:(id)sender {
    XingHengSetMainViewController *vc = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengSetMainViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
