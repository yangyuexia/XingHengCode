//
//  CustomFooterView.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/22.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "CustomFooterView.h"
#import "CustomShadowView.h"

@implementation CustomFooterView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"CustomFooterView" owner:self options:nil];
        self = array[0];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 7.0;
    self.bgView.layer.masksToBounds = YES;
    [self setUpShadowView];
}

- (void)setUpShadowView{
    CustomShadowView *view = [[CustomShadowView alloc] initWithFrame:CGRectMake(15, 20, APP_W-30, 320)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [self bringSubviewToFront:self.bgView];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view addSubview:vv];
    [QWGLOBALMANAGER addShadowToView:vv withOpacity:0.3 shadowRadius:2 andCornerRadius:7.0];
}

- (void)configureData:(BatteryCheckDataModel *)model{
    self.label1.text = model.bcpCode ? model.bcpCode : @"";
    self.label2.text = model.cpCode ? model.cpCode : @"";
    self.label3.text = model.ssdl ? model.ssdl : @"";
    self.label4.text = model.xdrlbfb ? model.xdrlbfb : @"";
    self.label5.text = model.soc ? model.soc : @"";
    self.label6.text = model.wd ? model.wd : @"";
    self.label7.text = model.zdy ? model.zdy : @"";
    self.label8.text = model.syrl ? model.syrl : @"";
    self.label9.text = model.mdrl ? model.mdrl : @"";
    self.label10.text = model.xhcs ? model.xhcs : @"";
    self.label11.text = model.zddyc ? model.zddyc : @"";
    self.label12.text = model.soh ? model.soh : @"";
    self.label13.text = model.rjbb ? model.rjbb : @"";
    self.label14.text = model.yjbb ? model.yjbb : @"";
    self.label15.text = model.jtyc ? model.jtyc : @"N/A";
    self.label16.text = model.cdyc ? model.cdyc : @"N/A";
    self.label17.text = model.fdyc ? model.fdyc : @"N/A";
    self.label18.text = model.dcname ? model.dcname : @"";
}

@end
