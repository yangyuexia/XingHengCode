//
//  CustomHeaderView.h
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomHeaderViewDelegate <NSObject>

- (void)checkBatteryAction;

@end

@interface CustomHeaderView : UIView

@property (weak, nonatomic) id <CustomHeaderViewDelegate> customHeaderViewDelegate ;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UILabel *connectStateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectState_layout_left;
@property (weak, nonatomic) IBOutlet UILabel *connnectDescLabel;

@property (weak, nonatomic) IBOutlet UIView *bg1;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *deviceImage1;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage2;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage3;

@property (weak, nonatomic) IBOutlet UIImageView *dottedLine;
@property (weak, nonatomic) IBOutlet UIView *connentedView1;
@property (weak, nonatomic) IBOutlet UIView *connentedView2;
@property (weak, nonatomic) IBOutlet UIView *halfGreenView;
@property (weak, nonatomic) IBOutlet UIView *halfGreenView2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *half_layout_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *half_layout_width2;

@property (strong, nonatomic) CADisplayLink *link;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkAction:(id)sender;

- (void)configureData:(id)data;
- (void)updateConnentStateView:(NSInteger)state;
- (void)checkingState;

@end

NS_ASSUME_NONNULL_END
