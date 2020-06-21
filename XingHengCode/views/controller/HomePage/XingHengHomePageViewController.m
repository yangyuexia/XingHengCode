//
//  XingHengHomePageViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengHomePageViewController.h"
#import "LoginViewController.h"
#import "XingHengHomePageCell.h"
#import "XLCycleScrollView.h"
#import "XingHengScanViewController.h"
#import "XingHengWarrantyQueryViewController.h"
#import "XingHengCheckRecordViewController.h"
#import "XingHengSaleCheckViewController.h"

#define BannerHeight  ((APP_W-20)*162/355)

@interface XingHengHomePageViewController () <UICollectionViewDataSource,UICollectionViewDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bannerBg;
@property (strong, nonatomic) XLCycleScrollView *cycScrollBanner;
@property (strong, nonatomic) NSMutableArray *bannerList;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

#import "XingHengHomePageViewController.h"

@implementation XingHengHomePageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"星恒锂电";
    
    self.collectionView.backgroundColor = RGBHex(0xF4F4F4);
    
    self.bannerList = [NSMutableArray array];
    [self.bannerList addObject:@"bg_banner_blue"];
    
    [self contentInsetHeaderView];
    [self setUpBannerView];
    
    [self configureData];
    
}

- (void)configureData{
    self.dataList = [NSMutableArray array];
    [self.dataList removeAllObjects];
    
    if (QWGLOBALMANAGER.powerInfoModel.check.count > 0) {
        HomeUIModel *model1 = [HomeUIModel new];
        model1.icon = @"icon-home-after-sale";
        model1.title = @"售后检测";
        model1.content1 = @"After-sale";
        model1.content2 = @"Testing";
        [self.dataList addObject:model1];
    }
    
    
    HomeUIModel *model2 = [HomeUIModel new];
    model2.icon = @"icon-home-test-records";
    model2.title = @"检测记录";
    model2.content1 = @"Test";
    model2.content2 = @"Records";
    [self.dataList addObject:model2];
    
    HomeUIModel *model3 = [HomeUIModel new];
    model3.icon = @"icon-home-warranty";
    model3.title = @"保修期查询";
    model3.content1 = @"Warranty";
    model3.content2 = @"Querying";
    [self.dataList addObject:model3];
    
    if (QWGLOBALMANAGER.powerInfoModel.logistics.count > 0) {
        HomeUIModel *model4 = [HomeUIModel new];
        model4.icon = @"icon-home-logistics";
        model4.title = @"物流管理";
        model4.content1 = @"Logistics";
        model4.content2 = @"Management";
        [self.dataList addObject:model4];
    }
    
    
    HomeUIModel *model5 = [HomeUIModel new];
    model5.icon = @"icon-home-data-report";
    model5.title = @"数据简报";
    model5.content1 = @"Data";
    model5.content2 = @"Report";
    [self.dataList addObject:model5];
    
    HomeUIModel *model6 = [HomeUIModel new];
    model6.icon = @"icon-home-user-guide";
    model6.title = @"新手指南";
    model6.content1 = @"User's";
    model6.content2 = @"Guide";
    [self.dataList addObject:model6];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.bannerList.count > 0){
        self.cycScrollBanner.scrollView.scrollEnabled = YES;
        [self.cycScrollBanner startAutoScroll:5.0f];
    }else{
        self.cycScrollBanner.scrollView.scrollEnabled = NO;
        [self.cycScrollBanner stopAutoScroll];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.cycScrollBanner stopAutoScroll];
}

#pragma mark - 设置表头方式一
- (void)contentInsetHeaderView {
    CGFloat header_y = BannerHeight+10;
    // CGFloat top, left, bottom, right;
    _collectionView.contentInset = UIEdgeInsetsMake(header_y, 0, 0, 0);
    _headerView.frame = CGRectMake(0, -header_y, [UIScreen mainScreen].bounds.size.width, header_y);
    [_collectionView addSubview:_headerView];
    [_collectionView setContentOffset:CGPointMake(0, -header_y)];
}

- (void)setUpBannerView{
    if(self.cycScrollBanner){
        [self.cycScrollBanner stopAutoScroll];
        [self.cycScrollBanner removeFromSuperview];
        self.cycScrollBanner = nil;
        self.cycScrollBanner.delegate = nil;
        self.cycScrollBanner.datasource = nil;
    }
    self.cycScrollBanner = [[XLCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_W-20, BannerHeight)];
    self.cycScrollBanner.backgroundColor = [UIColor clearColor];
    self.cycScrollBanner.scrollView.backgroundColor = [UIColor clearColor];
    self.cycScrollBanner.datasource = self;
    self.cycScrollBanner.delegate = self;
    self.cycScrollBanner.userInteractionEnabled = YES;
    [self.bannerBg addSubview:self.cycScrollBanner];
}

#pragma mark ---- XLCycScrollView Delegate ----
- (NSInteger)numberOfPages{
    if(self.bannerList.count > 1){
        [self.cycScrollBanner startAutoScroll:5.0];
        return self.bannerList.count;
    }else{
        [self.cycScrollBanner stopAutoScroll];
        return 1;
    }
}

- (UIView *)pageAtIndex:(NSInteger)index{
    if (index >= self.bannerList.count) {
        index = self.bannerList.count-1;
    }
    
    if(self.bannerList.count > 0) {
        NSString *model = self.bannerList[index];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_W-20, BannerHeight)];
        view.backgroundColor = [UIColor clearColor];
        view.image = [UIImage imageNamed:model];
        return view;
    }else{
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_W-20, BannerHeight)];
        view.image = [UIImage imageNamed:@"bg_banner_blue"];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

#pragma mark ----CollectionView 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XingHengHomePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XingHengHomePageCell" forIndexPath:indexPath];
    HomeUIModel *model = self.dataList[indexPath.row];
    cell.icon.image = [UIImage imageNamed:model.icon];
    cell.label1.text = model.title;
    cell.label2.text = model.content1;
    cell.label3.text = model.content2;
    return cell;
}

#pragma mark ---- 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(floorf((APP_W-30-18)/3), 140);
}

#pragma mark ---- 定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 9;
}

#pragma mark ---- 定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 14;
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //top, left, bottom, right
    return UIEdgeInsetsMake(8, 15,20, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HomeUIModel *uiModel = self.dataList[indexPath.row];
    
    
    if ([uiModel.title isEqualToString:@"售后检测"]) {
        //售后检测
        if (QWGLOBALMANAGER.baby.centralManager.state == CBCentralManagerStatePoweredOff) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"打开蓝牙来允许“星恒锂电”连接到配件" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                //将字符串转换为16进制
                 NSData *encryptString = [[NSData alloc] initWithBytes:(unsigned char []){0x41, 0x70, 0x70, 0x2d, 0x50, 0x72, 0x65, 0x66, 0x73, 0x3a, 0x72, 0x6f, 0x6f, 0x74, 0x3d, 0x42, 0x6c, 0x75, 0x65, 0x74, 0x6f, 0x6f, 0x74, 0x68} length:24];
                NSString *string = [[NSString alloc] initWithData:encryptString encoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:string];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
            return;
        }

        if (![QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING]) {
            [SVProgressHUD showErrorWithStatus:@"请先选择检测仪"];
            return;
        }
        
//        XingHengScanViewController *vc = [[UIStoryboard storyboardWithName:@"Check" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengScanViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        
        XingHengSaleCheckViewController *vc = [[UIStoryboard storyboardWithName:@"Check" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengSaleCheckViewController"];
        vc.fromHomePage = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([uiModel.title isEqualToString:@"检测记录"]){
        //检测记录
        XingHengCheckRecordViewController *vc = [[UIStoryboard storyboardWithName:@"CheckRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengCheckRecordViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([uiModel.title isEqualToString:@"保修期查询"]){
        //保修期查询
        XingHengWarrantyQueryViewController *vc = [[UIStoryboard storyboardWithName:@"WarrantyQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengWarrantyQueryViewController"];
        vc.fromHomePage = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([uiModel.title isEqualToString:@"物流管理"]){
        //物流管理
        
    }else if ([uiModel.title isEqualToString:@"数据简报"]){
        //数据简报
        
    }else if ([uiModel.title isEqualToString:@"新手指南"]){
        //新手指南
        
    }
    
}


- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (NotifKickOff == type || NotifTokenValide == type){
        [QWGLOBALMANAGER clearAccountInformation:YES];
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (type == NotifrefreshHomePage){
        [self configureData];
    }
    
}

- (void)dealloc{

}

@end
