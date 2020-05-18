//
//  QWBaseTableCell.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseTableCell.h"

@implementation QWBaseTableCell

/**
 *  无xib调用initWithStyle，需要在此初始化控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**
         *  不在xib的控件在此初始化
         */
        
    }
    return self;
}


/**
 *  对控件颜色，字体，字体大小写在此方法体内
 */
- (void)UIGlobal{
    [super UIGlobal];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = RGBAHex(qwColor5, 1);
    self.separatorLine.backgroundColor = RGBAHex(0xdfdfdf, 1);
}

/**
 *  控件加载数据
 *
 *  @param data 来源数据，默认都是已定义model
 */
- (void)setCell:(id)data{
    [super setCell:data];
    
}


@end
