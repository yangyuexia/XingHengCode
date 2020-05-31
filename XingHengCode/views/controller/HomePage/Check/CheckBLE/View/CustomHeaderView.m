//
//  CustomHeaderView.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "CustomHeaderView.h"

@implementation CustomHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"CustomHeaderView" owner:self options:nil];
        self = array[0];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bg1.layer.cornerRadius = self.checkBtn.layer.cornerRadius =  8.0;
    self.bg1.layer.masksToBounds = self.checkBtn.layer.masksToBounds = YES;
    self.bg1.layer.borderColor = RGBHex(qwColor14).CGColor;
    self.bg1.layer.borderWidth = 1.0;
    self.bg1.backgroundColor = [UIColor whiteColor];
    self.dottedLine.image = [QWGLOBALMANAGER drawLineByImageView:self.dottedLine];
    self.half_layout_width.constant = self.half_layout_width2.constant = (APP_W-220)/4;
}

- (void)configureData:(id)data{
    BatteryInfoModel *model = (BatteryInfoModel *)data;
    NSString *v = @"";
    if (model) {
        v = model.V;
    }
    NSString *str = [NSString stringWithFormat:@"%@电池",v];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = [str rangeOfString:@"电池"];
    [attributed addAttributes:@{NSForegroundColorAttributeName:RGBHex(qwColor1)} range:range1];
    self.batteryLabel.attributedText = attributed;
}

- (void)updateConnentStateView:(NSInteger)state{
        
    //0蓝牙关闭 1蓝牙未连接 2蓝牙连接 3连接
    if (state == 0) {
        [self.checkBtn setTitle:@"未连接" forState:UIControlStateNormal];
        self.checkBtn.backgroundColor = RGBHex(0xE6E6EB);
        self.checkBtn.enabled = NO;
        self.deviceImage1.image = [UIImage imageNamed:@"icon-mobile-unconnect"];
        self.deviceImage2.image = [UIImage imageNamed:@"icon-liDian-unconnect"];
        self.deviceImage3.image = [UIImage imageNamed:@"icon-dianchi-unconnect"];
        self.dottedLine.hidden = NO;
        self.connentedView1.hidden = self.connentedView2.hidden = self.halfGreenView.hidden = self.halfGreenView2.hidden = YES;
        self.connectStateLabel.text = @"未连接";
        self.connnectDescLabel.text = @"手机与锂电检测仪没有正确连接";
        self.connectState_layout_left.constant = 32;
        [self end];
        self.circleImage.hidden = YES;
    
    }else if (state == 1) {
        [self.checkBtn setTitle:@"设备连接中..." forState:UIControlStateNormal];
        self.checkBtn.backgroundColor = RGBHex(0xE6E6EB);
        self.checkBtn.enabled = NO;
        self.deviceImage1.image = [UIImage imageNamed:@"icon-mobile-connected"];
        self.deviceImage2.image = [UIImage imageNamed:@"icon-liDian-unconnect"];
        self.deviceImage3.image = [UIImage imageNamed:@"icon-dianchi-unconnect"];
        self.dottedLine.hidden = self.halfGreenView.hidden = NO;
        self.connentedView1.hidden = self.connentedView2.hidden = self.halfGreenView2.hidden = YES;
        self.connectStateLabel.text = @"未连接";
        self.connnectDescLabel.text = @"手机与锂电检测仪没有正确连接";
        self.connectState_layout_left.constant = 68;
        [self start];
        self.circleImage.hidden = NO;
        
    }else if (state == 2){
        [self.checkBtn setTitle:@"设备连接中..." forState:UIControlStateNormal];
        self.checkBtn.backgroundColor = RGBHex(0xE6E6EB);
        self.checkBtn.enabled = NO;
        self.deviceImage1.image = [UIImage imageNamed:@"icon-mobile-connected"];
        self.deviceImage2.image = [UIImage imageNamed:@"icon-liDian-connected"];
        self.deviceImage3.image = [UIImage imageNamed:@"icon-dianchi-unconnect"];
        self.dottedLine.hidden = self.connentedView1.hidden = self.halfGreenView2.hidden = NO ;
        self.halfGreenView.hidden = self.connentedView2.hidden = YES;
        self.connectStateLabel.text = @"连接中";
        self.connnectDescLabel.text = @"手机与检测仪正在尝试连接";
        self.connectState_layout_left.constant = 68;
        [self start];
        self.circleImage.hidden = NO;
        
    }else if (state == 3){
        if (QWGLOBALMANAGER.isChecking) {
            return;
        }
        [self.checkBtn setTitle:@"智能电池检测" forState:UIControlStateNormal];
        self.checkBtn.backgroundColor = RGBHex(qwColor6);
        self.checkBtn.enabled = YES;
        self.deviceImage1.image = [UIImage imageNamed:@"icon-mobile-connected"];
        self.deviceImage2.image = [UIImage imageNamed:@"icon-liDian-connected"];
        self.deviceImage3.image = [UIImage imageNamed:@"icon-dianchi-connected"];
        self.dottedLine.hidden = self.halfGreenView.hidden = self.halfGreenView2.hidden = YES;
        self.connentedView1.hidden = self.connentedView2.hidden = NO;
        self.connectStateLabel.text = @"已连接";
        self.connnectDescLabel.text = @"检测设备与电池之间连接正常";
        self.connectState_layout_left.constant = 32;
        [self end];
        self.circleImage.hidden = YES;
    }
    
}

- (void)checkingState{
    [self.checkBtn setTitle:@"智能电池检测中..." forState:UIControlStateNormal];
    self.checkBtn.backgroundColor = RGBHex(0xE6E6EB);
    self.checkBtn.enabled = NO;
}

- (void)start{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.link) {
            self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(up)];
        }
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    });
}

- (void)end{
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
}

- (void)up{
    // 1/60秒 * 45
    // 规定时间内转动的角度 == 时间 * 速度
    CGFloat ang = self.link.duration * M_PI * 1.5;
    self.circleImage.transform = CGAffineTransformRotate(self.circleImage.transform, ang);
}

- (IBAction)checkAction:(id)sender {
    if (self.customHeaderViewDelegate && [self.customHeaderViewDelegate respondsToSelector:@selector(checkBatteryAction)]) {
        [self.customHeaderViewDelegate checkBatteryAction];
    }
}

@end
