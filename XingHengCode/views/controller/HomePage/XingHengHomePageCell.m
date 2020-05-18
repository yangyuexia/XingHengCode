//
//  XingHengHomePageCell.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/16.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengHomePageCell.h"

@implementation XingHengHomePageCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.borderColor = RGBHex(qwColor11).CGColor;
}

@end
