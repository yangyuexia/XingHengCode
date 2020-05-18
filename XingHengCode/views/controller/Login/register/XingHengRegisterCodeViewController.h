//
//  XingHengRegisterCodeViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengRegisterCodeViewController : QWBaseVC

@property (assign, nonatomic) NSInteger tokenCode;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@end

NS_ASSUME_NONNULL_END
