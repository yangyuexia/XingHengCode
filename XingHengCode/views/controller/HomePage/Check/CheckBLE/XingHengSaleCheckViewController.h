//
//  XingHengSaleCheckViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengSaleCheckViewController : QWBaseVC

@property (strong, nonatomic) BatteryInfoModel *batteryInfoModel;

@property (strong, nonatomic) NSString *boxCode;

@property (assign, nonatomic) BOOL fromHomePage;

@end

NS_ASSUME_NONNULL_END
