//
//  XingHengScanQueryViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengScanQueryViewController.h"

@interface XingHengScanQueryViewController ()

//扫码
@property (weak, nonatomic) IBOutlet UIView *lineContainer;
@property (weak, nonatomic) IBOutlet UIView *readView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
- (IBAction)torchAction:(id)sender;

@end

@implementation XingHengScanQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"识别电池型号";
    self.width.constant = self.height.constant = APP_W-105;
    self.torchMode = NO;
    
    CGRect rect = CGRectMake(0, 0, APP_W, SCREEN_H);
    self.iosScanView = [[IOSScanView alloc] initWithFrame:rect];
    self.iosScanView.delegate = self;
    [self.readView addSubview:self.iosScanView];
    [self setupDynamicScanFrame];
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

#pragma mark ---- 扫码结果回调 ----
- (void) IOSScanResult: (NSString*) scanCode WithType:(NSString *)type{
    if (self.scanBlock) {
        self.scanBlock(scanCode);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
