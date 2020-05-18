//
//  FzhDrawChart.m
//  DrawPicture
//
//  Created by fuzheng on 16/12/02.
//  Copyright © 2016年 fuzheng. All rights reserved.
//

#import "FzhDrawChart.h"

#define margin      11

@implementation FzhDrawChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.self.zzWidth = frame.size.width;
        self.self.zzHeight = frame.size.height;
    }
    return self;
}

//画柱状图
- (void)drawZhuZhuangTu:(NSArray *)x_itemArr and:(NSArray *)y_itemArr
{
    float max =[[y_itemArr valueForKeyPath:@"@max.floatValue"] floatValue];
    
    //画柱状图
    for (int i=0; i<y_itemArr.count; i++) {
        float a = [y_itemArr[i] floatValue];
        CGFloat x = 60;
        CGFloat y = (margin+5)*i;
        CGFloat w = a*(self.zzWidth-120)/max;
        CGFloat h = margin;
    
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = RGBHex(qwColor6).CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x+w+5,y,55,h)];
        lab.text = y_itemArr[i];
        lab.font = [UIFont systemFontOfSize:11];
        lab.textColor = RGBHex(qwColor3);
        lab.adjustsFontSizeToFitWidth = YES;
        lab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lab];
        
        
        
    }
    
    //给x轴加标注
    [self addXBiaoZhu:x_itemArr];
}


-(void)addXBiaoZhu:(NSArray *)x_itemArr{
    for (int i=0; i<x_itemArr.count; i++) {
        CGFloat x = 10;
        CGFloat y = (margin+5)*i;
        CGFloat w = 40;
        CGFloat h = margin;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x,y,w,h)];
        lab.text = x_itemArr[i];
        lab.font = [UIFont systemFontOfSize:11];
        lab.textColor = RGBHex(qwColor1);
        lab.adjustsFontSizeToFitWidth = YES;
        lab.textAlignment = NSTextAlignmentRight;
        [self addSubview:lab];
    }
}

- (void)initDrawView{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

@end
