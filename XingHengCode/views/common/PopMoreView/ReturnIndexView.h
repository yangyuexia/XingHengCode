//
//  ReturnIndexView.h
//  wenyao
//
//  Created by qwfy0006 on 15/3/2.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReturnIndexView;

@protocol ReturnIndexViewDelegate <NSObject>

- (void)RetunIndexView:(ReturnIndexView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath;

@end

@interface ReturnIndexView : UIView

@property (assign, nonatomic) id <ReturnIndexViewDelegate> returnIndexViewDelegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *titleArray;

+ (ReturnIndexView *)sharedManagerTitle:(NSArray *)titles isHidden:(BOOL)isHidden frame:(CGRect)frame;

- (void)show;

- (void)hide;

@end
