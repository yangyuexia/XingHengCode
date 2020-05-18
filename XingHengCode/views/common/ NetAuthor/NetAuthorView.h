//
//  NetAuthorView.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2018/6/13.
//  Copyright © 2018年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CheckNetwork)();

@interface NetAuthorView : UIView

@property (nonatomic, copy)  CheckNetwork CheckNetworkBlock;

@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *check_layout_width;

- (IBAction)checkAction:(id)sender;

@end
