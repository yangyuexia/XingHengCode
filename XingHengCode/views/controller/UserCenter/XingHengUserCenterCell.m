//
//  XingHengUserCenterCell.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/13.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengUserCenterCell.h"

@implementation XingHengUserCenterCell

- (void)UIGlobal{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self setSeparatorMargin:36 edge:EdgeLeft | EdgeRight];
    self.separatorLine.backgroundColor = RGBHex(0xE6E6EB);
}

@end
