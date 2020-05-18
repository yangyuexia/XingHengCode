//
//  XingHengRecordListCell.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XingHengRecordListCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *barCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

- (void)setCell:(id)data type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
