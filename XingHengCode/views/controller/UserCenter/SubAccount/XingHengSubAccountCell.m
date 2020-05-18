//
//  XingHengSubAccountCell.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengSubAccountCell.h"

@implementation XingHengSubAccountCell

- (void)setCell:(id)data{
    [super setCell:data];
    
    SubAccountListModel *model = (SubAccountListModel *)data;
    
    self.accountLabel.text = model.username;
    
    self.nameLabel.text = model.nickname;
    
}

@end
