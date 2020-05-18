//
//  XingHengScanQueryViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"
#import "IOSScanView.h"

typedef void (^ScanCodeBlock)(NSString *barCode);

NS_ASSUME_NONNULL_BEGIN

@interface XingHengScanQueryViewController : QWBaseVC

@property (nonatomic, copy) ScanCodeBlock scanBlock;

@property (nonatomic, assign) BOOL torchMode;          //控制闪光灯的开关

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) IOSScanView *iosScanView;

@end

NS_ASSUME_NONNULL_END
