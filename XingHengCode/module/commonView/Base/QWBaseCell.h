//
//  QWBaseCell.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWConstant.h"
#import "QWcss.h"
#import <objc/runtime.h>
#import "QWButton.h"

@interface QWBaseCell : UITableViewCell

@property(nonatomic, assign) id delegate;

/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, assign) id delegatePopVC;

@property (assign) BOOL separatorHidden;

@property (nonatomic, retain) UIView* separatorLine;

+ (CGFloat)getCellHeight:(id)data;

- (void)setCell:(id)data;

- (void)UIGlobal;

- (void)setSeparatorMargin:(CGFloat)margin edge:(Enum_Edge)edge;

@end
