//
//  QWBaseTabBar.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseTabBar.h"
#import "Constant.h"
#import "QWGlobalManager.h"

@implementation QWTabbarItem

@end

@interface QWBaseTabBar()
{
    NSMutableArray * arrBadges,*arrRed;
    NSMutableArray * arrTabItems;
    UIView *vBG;
}
@end

@interface QWBaseTabBar ()

@end

@implementation QWBaseTabBar

- (void)addTabBarItem:(QWTabbarItem*)firstObject, ...{
    
    arrTabItems=nil;
    arrTabItems = [NSMutableArray array];
    
    NSMutableArray * arrTags = [NSMutableArray array];
    
    UINavigationController * nav = nil;
    
    if (firstObject)
    {
        
        va_list args;
        va_start(args, firstObject);
        for (QWTabbarItem *obj = firstObject; obj != nil; obj = va_arg(args,QWTabbarItem*)) {
            
            if (obj.storyBoardName && ![obj.storyBoardName isEqualToString:@""]) {
                nav = [[QWBaseNavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:obj.storyBoardName bundle:nil] instantiateViewControllerWithIdentifier:obj.clazz]];
            }
            else if (obj.clazz && ![obj.clazz isEqualToString:@""])
            {
                nav = [[QWBaseNavigationController alloc] initWithRootViewController:[[NSClassFromString(obj.clazz) alloc] init]];
            }else
            {
                nav = [[QWBaseNavigationController alloc] init];
            }
            
            UITabBarItem *item = [self createTabBarItem:obj.title normalImage:obj.picNormal selectedImage:obj.picSelected itemTag:obj.tag.integerValue];
            nav.tabBarItem = item;
            [arrTabItems addObject:nav];
            [arrTags addObject:obj.tag];
        }
        va_end(args);
        
        [self addBadge:arrTags];
        self.viewControllers = arrTabItems;
        
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
        [[UITabBar appearance] setTranslucent:NO];
        [[UITabBar appearance] setTintColor:RGBHex(qwColor6)];
    }
}


- (UITabBarItem *)createTabBarItem:(NSString *)strTitle normalImage:(NSString *)strNormalImg selectedImage:(NSString *)strSelectedImg itemTag:(NSInteger)intTag
{
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:strTitle image:nil tag:intTag];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwColor24), NSForegroundColorAttributeName,fontSystem(kFontS7), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwColor6), NSForegroundColorAttributeName,fontSystem(kFontS7), NSFontAttributeName,  nil] forState:UIControlStateSelected];
    
    if (iOSv7) {
        [item setImage:[[UIImage imageNamed:strNormalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:strSelectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        [item setFinishedSelectedImage:[UIImage imageNamed:strSelectedImg] withFinishedUnselectedImage:[UIImage imageNamed:strNormalImg]];
#endif
    }
        
    return item;
}


- (void)backgroundColor:(UIColor*)color{
    vBG=[[UIView alloc]initWithFrame:self.view.bounds];
    vBG.backgroundColor=color;
    
    [self.tabBar insertSubview:vBG atIndex:0];
}

- (void)separatorLine:(UIColor*)color{
    CGRect frm = self.view.bounds;
    frm.size.width=APP_W;
    frm.size.height = 0.5;
    UIView *bg=[[UIView alloc]initWithFrame:frm];
    bg.backgroundColor=color;
    
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    [self.tabBar insertSubview:bg aboveSubview:vBG];
}


/**
 *  按钮添加红点
 *
 *  @param tags 所有按钮的tag
 */
- (void)addBadge:(NSArray*)tags{
    arrBadges = nil;
    arrBadges = [NSMutableArray array];
    
    arrRed = nil;
    arrRed = [NSMutableArray array];
    
    CGFloat ww = APP_W/tags.count;
    CGRect frm=(CGRect){0,7,8,8};
    CGRect frm2=(CGRect){0,7,20,20};
    int i = 0;
    
    for (NSString *obj in tags) {
        
        frm.origin.x=ww*i+AutoValue(44.f);
        UIImageView *imgIcon;
        imgIcon = [[UIImageView alloc] initWithFrame:frm];
        imgIcon.tag=obj.integerValue;
        imgIcon.layer.cornerRadius = 4.0f;
        imgIcon.layer.masksToBounds = YES;
        imgIcon.backgroundColor = RGBHex(0xff5240);
        imgIcon.hidden = YES;
        [self.tabBar addSubview:imgIcon];
        [arrRed addObject:imgIcon];
        
        frm2.origin.x=ww*i+AutoValue(45.f);
        UILabel *rp=[[UILabel alloc]initWithFrame:frm2];
        rp.tag=obj.integerValue;
        rp.hidden = YES;
        rp.backgroundColor=RGBHex(0xff5240);
        rp.textColor=RGBHex(qwColor5);
        rp.textAlignment=NSTextAlignmentCenter;
        rp.font=fontSystem(kFontS6);
        rp.layer.cornerRadius = 10.0;
        rp.layer.masksToBounds = YES;
        
        [self.tabBar addSubview:rp];
        [arrBadges addObject:rp];
        i++;
    }
    
}

- (void)showBadgePoint:(BOOL)enabled itemTag:(NSInteger)intTag
{
    for (UIImageView *obj in arrRed) {
        if (obj.tag==intTag) {
            [self.tabBar bringSubviewToFront:obj];
            obj.hidden=!enabled;
        }
    }
}

- (void)showBadgeNum:(NSInteger)num itemTag:(NSInteger)intTag{
    //    int i = 0;
    for (UILabel *obj in arrBadges) {
        if (obj.tag==intTag) {
            obj.hidden=NO;
            
            if (num<=0)
                obj.hidden=YES;
            else if(num>99)
                obj.text=@"99";//obj.tabBarItem.badgeValue=@"99";
            else
                obj.text=[NSString stringWithFormat:@"%i",num];
            //            obj.text=@"99";
            [self.tabBar bringSubviewToFront:obj];
        }
    }
    //    for (UINavigationController *obj in arrTabItems) {
    //        if (obj.tabBarItem.tag==intTag) {
    //            if (num<=0)
    //                obj.tabBarItem.badgeValue=nil;
    //            else if(num>99)
    //                obj.tabBarItem.badgeValue=@"99";
    //            else
    //                obj.tabBarItem.badgeValue=[NSString stringWithFormat:@"%i",num];
    //        }
    //        i++;
    //    }
}


@end
