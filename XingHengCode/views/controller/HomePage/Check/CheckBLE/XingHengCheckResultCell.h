//
//  XingHengCheckResultCell.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "QWBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XingHengCheckResultCellDelegate <NSObject>

- (void)applyAction;

@end

@interface XingHengCheckResultCell : QWBaseTableCell

@property (weak, nonatomic) id <XingHengCheckResultCellDelegate> xingHengCheckResultCellDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImage;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desc_layout_height;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)applyAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
