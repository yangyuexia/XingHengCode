//
//  CheckResultView.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/5/4.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "CheckResultView.h"

@implementation CheckResultView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CheckResultView" owner:self options:nil];
        self = array[0];
        self.frame = frame;
    }
    return self;
}

@end
