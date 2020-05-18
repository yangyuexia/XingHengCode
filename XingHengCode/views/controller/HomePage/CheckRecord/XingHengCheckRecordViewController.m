//
//  XingHengCheckRecordViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengCheckRecordViewController.h"
#import "XingHengRecordListViewController.h"
#import "QCSlideSwitchView.h"

@interface XingHengCheckRecordViewController () <QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slideSwitchView;
@property (strong, nonatomic) NSMutableArray *controllerArray;

@end

@implementation XingHengCheckRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检测记录";
    self.controllerArray = [NSMutableArray array];
    [self setupViewController];
    [self setupSliderView];
    
}

#pragma mark ---- 初始化界面数组 ---
- (void)setupViewController{
    XingHengRecordListViewController *vc1 = [[UIStoryboard storyboardWithName:@"CheckRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengRecordListViewController"];
    vc1.title = @"故障列表";
    vc1.type = 1;
    vc1.navigationController = self.navigationController;
    
    XingHengRecordListViewController *vc2 = [[UIStoryboard storyboardWithName:@"CheckRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengRecordListViewController"];
    vc2.title = @"正常列表";
    vc2.type = 2;
    vc2.navigationController = self.navigationController;
    
    self.controllerArray = [NSMutableArray array];
    self.controllerArray = [NSMutableArray arrayWithObjects:vc1,vc2, nil];
}

- (void)setupSliderView{
    if (self.slideSwitchView) {
        [self.slideSwitchView removeFromSuperview];
        self.slideSwitchView = nil;
    }
    
    CGFloat height = SCREEN_H-STATUS_H-44;
    if (IS_IPHONE_X) {
        height = SCREEN_H-STATUS_H-44-34;
    }
    
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, height)];
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwColor5)];
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor2);
    self.slideSwitchView.tabItemSelectedColor = RGBHex(0x1975cf);
    self.slideSwitchView.tabItemNormalFont = fontSystem(14);
    self.slideSwitchView.tabItemSelectFont = fontSystemBold(14);
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:96.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 38.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(0xe6e6e6);
    [self.slideSwitchView addSubview:line];
    [self.view addSubview:self.slideSwitchView];
    
    self.slideSwitchView.topScrollView.scrollEnabled = NO;
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
}


#pragma mark ---- QCSlideSwitchView 代理 ----
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view{
    return self.controllerArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    return self.controllerArray[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number{
    [self.controllerArray[number] viewDidCurrentView];
}


@end
