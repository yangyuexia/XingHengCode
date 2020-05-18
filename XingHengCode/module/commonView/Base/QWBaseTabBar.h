//
//  QWBaseTabBar.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface QWTabbarItem : BaseModel
@property (nonatomic,strong) NSString *clazz;
@property (nonatomic,strong) NSString *picNormal;
@property (nonatomic,strong) NSString *picSelected;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSString *storyBoardName;
@end

@interface QWBaseTabBar : UITabBarController

- (void)addTabBarItem:(QWTabbarItem*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (void)backgroundColor:(UIColor*)color;

- (void)separatorLine:(UIColor*)color;

/**
 *  按钮上的红点
 *
 *  @param enabled 显示/关闭红点
 *  @param intTag  按钮tag值
 */
- (void)showBadgePoint:(BOOL)enabled itemTag:(NSInteger)intTag;

/**
 *  显示按钮badge数字
 *
 *  @param num    要显示的数字，<=0不显示，大于99显示"..."
 *  @param intTag 按钮tag值
 */
- (void)showBadgeNum:(NSInteger)num itemTag:(NSInteger)intTag;

@end
