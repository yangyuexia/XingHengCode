//
//  XingHengAddAccountViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengAddAccountViewController : QWBaseVC

@property (assign, nonatomic) BOOL isAddAccount;
@property (strong, nonatomic) SubAccountListModel *listModel;

@end

NS_ASSUME_NONNULL_END
