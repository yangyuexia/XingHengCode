//
//  XingHengScanViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/18.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengScanViewController.h"
#import "XingHengSaleCheckViewController.h"

@interface XingHengScanViewController () <IOSScanViewDelegate>

//扫码
@property (weak, nonatomic) IBOutlet UIView *lineContainer;
@property (weak, nonatomic) IBOutlet UIView *readView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
- (IBAction)torchAction:(id)sender;

//手动
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
- (IBAction)makeAction:(id)sender;



@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
- (IBAction)switchAction:(id)sender;

@end

@implementation XingHengScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"识别电池型号";
    self.width.constant = self.height.constant = APP_W-105;
    self.torchMode = NO;
    self.inputView.hidden = YES;
    
    CGRect rect = CGRectMake(0, 0, APP_W, SCREEN_H);
    self.iosScanView = [[IOSScanView alloc] initWithFrame:rect];
    self.iosScanView.delegate = self;
    [self.readView addSubview:self.iosScanView];
    [self setupDynamicScanFrame];
    
    self.textField.delegate = self;
    self.textBg.layer.cornerRadius = 8.0;
    self.textBg.layer.masksToBounds = YES;
    self.textBg.layer.borderColor = RGBHex(0xE6E6EB).CGColor;
    self.textBg.layer.borderWidth = 1.0;
    self.makeBtn.layer.cornerRadius = 8;
    self.makeBtn.layer.masksToBounds = YES;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    if (self.iosScanView) {
        [self.iosScanView startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
    self.torchMode = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.iosScanView) {
        [self.iosScanView stopRunning];
    }
}

- (void)setupDynamicScanFrame{
    UIImageView *scanLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_W-105, 6)];
    [scanLineImage setImage:[UIImage imageNamed:@"scan_line"]];
    scanLineImage.center = CGPointMake((APP_W-105)/2, 0);
    [self.lineContainer addSubview:scanLineImage];
    [self runSpinAnimationOnView:scanLineImage duration:3 positionY:APP_W-105 repeat:CGFLOAT_MAX];
}

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration positionY:(CGFloat)positionY repeat:(float)repeat;{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: positionY];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    rotationAnimation.autoreverses = YES;
    [view.layer addAnimation:rotationAnimation forKey:@"position"];
}


#pragma mark ---- 闪光灯 ----
- (IBAction)torchAction:(id)sender {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (!self.torchMode) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                self.torchMode = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                self.torchMode = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (IBAction)switchAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        self.image1.image = [UIImage imageNamed:@"icon-sao-sao"];
        self.image2.image = [UIImage imageNamed:@"icon-input"];
        self.label1.textColor = RGBHex(qwColor24);
        self.label2.textColor = RGBHex(qwColor5);
        self.inputView.hidden = YES;
        
    }else if (btn.tag == 2){
        self.image1.image = [UIImage imageNamed:@"icon-sao-sao-white"];
        self.image2.image = [UIImage imageNamed:@"icon-input-active"];
        self.label1.textColor = RGBHex(qwColor5);
        self.label2.textColor = RGBHex(qwColor24);
        self.inputView.hidden = NO;
    }
}

#pragma mark ---- 扫码结果回调 ----
- (void) IOSScanResult: (NSString*) scanCode WithType:(NSString *)type{
    //进行业务逻辑处理
    [self postCode:scanCode];
}

- (IBAction)makeAction:(id)sender {
    if (StrIsEmpty(self.textField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入电池编码"];
        return;
    }
    
    [self postCode:self.textField.text];
}

- (void)postCode:(NSString *)code{
    
    NSString *boxCode = @"";
    if (code.length == 20) {
        NSString *s1 = [code substringWithRange:NSMakeRange(11, 1)];
        NSString *s2 = [code substringWithRange:NSMakeRange(12, 1)];
        if ([QWGLOBALMANAGER isPureNum:s1] && [QWGLOBALMANAGER isPureNum:s2]) {
            boxCode = [NSString stringWithFormat:@"%@%@",s1,s2];
        }
    }
    
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"bar_code"] = code;
    [IndexApi EqpInfoWithParams:setting success:^(id obj) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"info"]];
        dic[@"code"] = obj[@"code"];
        dic[@"message"] = obj[@"message"];
        dic[@"neww_bar_code"] = obj[@"info"][@"new_bar_code"];
        BatteryInfoModel *model = [BatteryInfoModel parse:dic];

        if ([model.code integerValue] == 200) {
            
            XingHengSaleCheckViewController *vc = [[UIStoryboard storyboardWithName:@"Check" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengSaleCheckViewController"];
            vc.batteryInfoModel = model;
            vc.boxCode = boxCode;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:model.message];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];
    
}

- (void)reStartScan{
    if (self.timer) {
        self.timer = nil;
    }
    if (self.iosScanView) {
        [self.iosScanView startRunning];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
