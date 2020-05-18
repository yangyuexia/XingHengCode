//
//  QWBaseVC.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseVC.h"
#import "AppDelegate.h"
#import "QWGlobalManager.h"

static float kTopBarItemWidth = 40;
static float kTopBackBtnMargin = -13.f;
static float kTopBtnMargin = -16.f;

@interface QWBaseVC ()<UIGestureRecognizerDelegate,UINavigationBarDelegate>

@property (strong, nonatomic) NSString *strChannel;

@end

@implementation QWBaseVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (self.navigationController.viewControllers.count<=1 && _backButtonEnabled == NO)
        return;
    else
        [self naviBackBotton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if ([self isKindOfClass:[LeYunIndexViewController class]] || [self isKindOfClass:[MasterViewController class]]) {
//        HttpClientMgr.progressEnabled = NO;
//        [CaiDiApi DiActRedAllActiveWithParams:nil success:^(id obj) {
//            MasterRedAllModel *model = [MasterRedAllModel parse:obj];
//            if ([model.code intValue] == 0) {
//                if (!model.picked && model.id > 0) {
//                    NSArray *redArr = [QWUserDefault getObjectBy:@"redAll"];
//                    if (redArr && [redArr containsObject:StrFromInt(model.id)]) {
//                    }else{
//                        NSMutableArray *arr = [NSMutableArray arrayWithArray:redArr];
//                        [arr addObject:StrFromInt(model.id)];
//                        [QWUserDefault setObject:arr key:@"redAll"];
//
//                        PopMasterRedRemindView *view = [PopMasterRedRemindView sharedManagerWithActivityData:model];
//                        [view show];
//                    }
//                }
//            }
//        } failure:^(HttpException *e) {
//        }];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
//    if ([self isKindOfClass:[LeYunMasterOrderDetailViewController class]] || [self isKindOfClass:[LeCpbMasterDetailViewController class]]) {
//
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenAllCustomView" object:nil];
//    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self UIGlobal];
    
    
}


#pragma mark - 全局界面UI
- (void)UIGlobal{
    [super UIGlobal];
    
    self.view.backgroundColor = RGBHex(0xF2F4F7);
    
    if (self.tableMain==nil) {
        self.tableMain = [[UITableView alloc]initWithFrame:self.view.bounds];
    }
    
    _tableMain.backgroundColor=RGBAHex(qwColor4, 1);
    _tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - 导航返回按钮自定义
- (void)naviBackBotton
{
    [self naviLeftBottonImage:[UIImage imageNamed:@"nav_btn_back"] highlighted:[UIImage imageNamed:@"nav_btn_back"] action:@selector(popVCAction:)];
    
}

#pragma mark - 左上按钮
- (void)naviLeftBottonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action{
    
    CGFloat margin=10;
    
    if (@available(iOS 11.0, *)) {
        margin = 0;
    } else {
        
    }
    
    CGFloat ww=kTopBarItemWidth, hh=44;
    CGFloat bw,bh;

    bw=aImg.size.width;
    bh=aImg.size.height;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    [btn setImage:aImg forState:UIControlStateNormal];
    if (hImg)
        [btn setImage:hImg forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake((hh-bh)/2, margin, (hh-bh)/2, ww-margin-bw)];
    
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBackBtnMargin;
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}

#pragma mark 全局通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    
}

#pragma mark - tmp
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

#pragma mark - 无数据页面水印---有选择框的

-(void)showInfoView:(NSString *)text image:(NSString*)imageName flatY:(NSInteger)y {
    [self showInfoView:text image:imageName tag:0 flatY:(NSInteger)y];
}


-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag flatY:(NSInteger)y
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
//        self.vInfo.backgroundColor = RGBHex(qwColor14);
        self.vInfo.backgroundColor = [UIColor whiteColor];
    }
    CGRect rect = self.view.bounds;
    rect.origin.y = y;
    
    
    self.vInfo.frame = rect;
    
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS2);
    lblInfo.textColor = RGBHex(qwColor3);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
}



#pragma mark - 无数据页面水印

-(void)showInfoView:(NSString *)text image:(NSString*)imageName {
    [self showInfoView:text image:imageName tag:0];
}

-(void)showInfoViewAttribute:(NSMutableAttributedString *)text image:(NSString*)imageName
{
    [self showInfoViewAttribute:text image:imageName tag:0];
}

-(void)showInfoViewAttribute:(NSMutableAttributedString *)text image:(NSString*)imageName tag:(NSInteger)tag
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
        self.vInfo.backgroundColor = RGBHex(qwColor14);
    }
    
    self.vInfo.frame = self.view.bounds;
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS2);
    lblInfo.textColor = RGBHex(qwColor3);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text.string font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.attributedText = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
}

-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
//        self.vInfo.backgroundColor = RGBHex(qwColor14);
        self.vInfo.backgroundColor = [UIColor whiteColor];
    }
    
    self.vInfo.frame = self.view.bounds;
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(15);
    lblInfo.textColor = RGBHex(qwColor3);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
}

- (void)removeInfoView{
    [self.vInfo removeFromSuperview];
}

- (IBAction)viewInfoClickAction:(id)sender{
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark －
#pragma mark 返回上一页
- (IBAction)popVCAction:(id)sender{
    [QWLOADING removeLoading];
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.navigationController.viewControllers.count>1)
            [self.navigationController popViewControllerAnimated:YES];
        else if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark 用来slide的View
- (void)viewDidCurrentView{
    
}


- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait  | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark ---- 关于首次安装app网络权限的优化 ----
-(void)showNetAuthorView{
    if (self.netAuthorView==nil) {
        self.netAuthorView = [[NetAuthorView alloc]initWithFrame:self.view.bounds];
    }
    self.netAuthorView.frame = self.view.bounds;
    
    __weak typeof (self) weakSelf = self;
    self.netAuthorView.CheckNetworkBlock = ^(){
        [weakSelf.netAuthorView removeFromSuperview];
        [weakSelf clickNetAuthorAction];
    };
    [self.view addSubview:self.netAuthorView];
    [self.view bringSubviewToFront:self.netAuthorView];
}

- (void)clickNetAuthorAction{
    
}


- (NSMutableArray *)sortSubmitArray:(NSMutableArray *)list
{
    if (list == nil) {
        return [NSMutableArray array];
    }
    
    NSMutableArray *arr = (NSMutableArray *)[list sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [[NSNumber numberWithInteger:[obj1 integerValue]] compare:[NSNumber numberWithInteger:[obj2 integerValue]]];
    }];
    return arr;
}

@end

