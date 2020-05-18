//
//  ReturnIndexCell.h
//  wenyao
//
//  Created by qwfy0006 on 15/3/2.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"

@interface ReturnIndexCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UIView *sepLine;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_layout_bottom;

@end
