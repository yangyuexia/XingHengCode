//
//  XingHengBLEConfigureViewController.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectConfigureBlock)(NSString *code);

@interface XingHengBLEConfigureViewController : QWBaseVC

@property (copy, nonatomic) SelectConfigureBlock configureBlock;

@end

NS_ASSUME_NONNULL_END
