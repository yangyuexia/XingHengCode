//
//  XingHengRecordDetailViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengRecordDetailViewController : QWBaseVC

@property (strong, nonatomic) CheckRecordListModel *listModel;

@property (assign, nonatomic) NSInteger type;

@end

NS_ASSUME_NONNULL_END
