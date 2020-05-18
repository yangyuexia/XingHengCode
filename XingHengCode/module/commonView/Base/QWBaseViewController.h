//
//  QWBaseViewController.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWConstant.h"
#import "QWcss.h"
#import "UIImageView+WebCache.h"

@interface QWBaseViewController : UIViewController

@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) id delegatePopVC;

- (void)UIGlobal;

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj;

@end
