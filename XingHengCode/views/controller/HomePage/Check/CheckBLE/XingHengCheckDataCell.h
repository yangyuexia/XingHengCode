//
//  XingHengCheckDataCell.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "FzhDrawChart.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengCheckDataCell : QWBaseTableCell

@property (strong, nonatomic, nonnull)FzhDrawChart *drawView;

- (void)setCell:(NSMutableArray *)nameArray :(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
