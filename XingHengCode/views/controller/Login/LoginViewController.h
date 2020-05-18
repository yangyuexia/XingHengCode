//
//  LoginViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 17/2/22.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "QWBaseVC.h"

typedef void (^PassTokenBlock)(NSString *token);

@interface LoginViewController : QWBaseVC

@property (nonatomic, copy)  PassTokenBlock passTokenBlock;

@property (nonatomic, copy) void(^loginSuccessBlock)(void);

@end
