//
//  XingHengAboutViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengAboutViewController.h"
#import "XingHengAboutCell.h"

#define KFMobile @"400-8228-077"
#define JSMobile @"0512-87811178"

@interface XingHengAboutViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) NSString *versionText;

@end

@implementation XingHengAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于APP";
    
    self.versionText = @"(已是最新版本)";
    self.titleList = @[@"检测更新",@"客服电话",@"技术支持",@"技术电话"];
    
    self.versionLabel.text = [NSString stringWithFormat:@"版本号:%@",APP_VERSION];
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.logo.layer.cornerRadius = 5.0;
    self.logo.layer.masksToBounds = YES;
    
    [self checkVersion];
    
}

- (void)checkVersion{
    HttpClientMgr.progressEnabled=NO;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"version"] = APP_VERSION;
    [System SysVersionWithParams:setting success:^(id obj) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"version"]];
        dic[@"code"] = obj[@"code"];
        dic[@"message"] = obj[@"message"];
        VersionModel *model = [VersionModel parse:dic];
        if ([model.code integerValue] == 200) {
            self.versionText = @"(检测到最新版本)";
            [self.tableView reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XingHengAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengAboutCell"];
    cell.titleLabrl.text = self.titleList[indexPath.row];
    if (indexPath.row == 0) {
        cell.contentLabel.text = self.versionText;
        cell.contentLabel.textColor = RGBHex(qwColor3);
    }else if (indexPath.row == 1){
        cell.contentLabel.text = KFMobile;
        cell.contentLabel.textColor = RGBHex(qwColor1);
    }else if (indexPath.row == 2){
        cell.contentLabel.text = @"苏州三洲网络科技有限公司";
        cell.contentLabel.textColor = RGBHex(qwColor1);
    }else if (indexPath.row == 3){
        cell.contentLabel.text = JSMobile;
        cell.contentLabel.textColor = RGBHex(qwColor1);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //系统更新
        HttpClientMgr.progressEnabled=NO;
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"version"] = APP_VERSION;
        [System SysVersionWithParams:setting success:^(id obj) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"version"]];
            dic[@"code"] = obj[@"code"];
            dic[@"message"] = obj[@"message"];
            
            VersionModel *model = [VersionModel parse:dic];
            if ([model.code integerValue] == 200) {
                QWGLOBALMANAGER.installUrl = model.downLoadUrl;
                if (model.compel) {
                    [QWGLOBALMANAGER showForceUpdateAlert:model];
                } else {
                    [QWGLOBALMANAGER showNormalUpdateAlert:model];
                }
            }
            
        } failure:^(HttpException *e) {
            
        }];
        
    }else if (indexPath.row == 1) {
        //客服电话
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:KFMobile, nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        
    }else if (indexPath.row == 3){
        //k技术电话
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:JSMobile, nil];
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *mobile = @"";
        if (actionSheet.tag == 1) {
            mobile = KFMobile;
        }else if (actionSheet.tag == 2){
            mobile = JSMobile;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobile]]];
    }
}

@end
