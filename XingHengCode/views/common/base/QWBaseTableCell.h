//
//  QWBaseTableCell.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseCell.h"
#import "Constant.h"
#import "QWGlobalManager.h"
#import "UIImageView+WebCache.h"

@interface QWBaseTableCell : QWBaseCell

@property(nonatomic, assign) id delegate;

/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, assign) id delegatePopVC;

@property (assign) BOOL separatorHidden;
@property (nonatomic, retain) UIView* separatorLine;

- (void)setCell:(id)data;

- (void)UIGlobal;

@end
