//
//  XingHengWarrantyQueryViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/18.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengWarrantyQueryViewController : QWBaseVC

@property (assign, nonatomic) BOOL fromHomePage;

@property (strong, nonatomic) NSMutableArray *voltageArray;
@property (strong, nonatomic) BatteryInfoModel *batteryInfoModel;
@property (strong, nonatomic) BatteryCheckDataModel *checkDataModel;
@property (strong, nonatomic) FaultDiagnosisPageModel *diagnosisPageModel;

@end

NS_ASSUME_NONNULL_END
