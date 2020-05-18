//
//  XingHengCheckDataCell.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengCheckDataCell.h"

@implementation XingHengCheckDataCell

- (void)UIGlobal{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.separatorLine.hidden = YES;
}

- (void)setCell:(NSMutableArray *)nameArray :(NSMutableArray *)dataArray{
    if (self.drawView) {
        [self.drawView removeFromSuperview];
        self.drawView = nil;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *str in dataArray) {
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@"mV" withString:@""];
        float ss = [str1 floatValue];
        float dd = ss/1000.0;
        [temp addObject:[NSString stringWithFormat:@"%.3fV",dd]];
    }
    self.drawView = [[FzhDrawChart alloc]initWithFrame:CGRectMake(0, 40, APP_W, 210)];
    self.drawView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.drawView];
    [self.drawView drawZhuZhuangTu:nameArray and:temp];
}


@end
