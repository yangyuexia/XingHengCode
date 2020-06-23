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

//版本
- (NSString *)version{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

- (void)checkVersion{
    
    HttpClientMgr.progressEnabled = NO;
    [System storeVersionWithParams:nil success:^(id obj) {
        NSArray *array = obj[@"results"];
        if (array.count > 0) {
            NSString * version = obj[@"results"][0][@"version"];//线上最新版本
            NSString *currentVersion= [self version];//当前用户版本
            BOOL result= [currentVersion compare:version] == NSOrderedAscending;
            if (result) {//需要更新
                self.versionText = @"(检测到最新版本)";
                [self.tableView reloadData];
            }
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
        
        HttpClientMgr.progressEnabled = NO;
        [System storeVersionWithParams:nil success:^(id obj) {
            NSArray *array = obj[@"results"];
            if (array.count > 0) {
                NSString * version = obj[@"results"][0][@"version"];//线上最新版本
                NSString *currentVersion= [self version];//当前用户版本
                BOOL result= [currentVersion compare:version] == NSOrderedAscending;
                if (result) {//需要更新
                    //调用弹框
                    VersionModel *model = [VersionModel new];
                    model.remark = obj[@"results"][0][@"releaseNotes"];
                    model.downLoadUrl = @"http://itunes.apple.com/cn/lookup?id=1516850507";
                    model.version = version;
                    QWGLOBALMANAGER.installUrl = model.downLoadUrl;
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
