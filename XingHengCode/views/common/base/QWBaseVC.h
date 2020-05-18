//
//  QWBaseVC.h
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/28.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseViewController.h"
#import "Constant.h"
#import "QWGlobalManager.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "NetAuthorView.h"

@interface QWBaseVC : QWBaseViewController <UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UIButton *btnPopVC;
}

@property (nonatomic, strong) UIView *vInfo;
@property (nonatomic, strong) IBOutlet UITableView               *tableMain;

@property (nonatomic, strong) UIButton* LeftItemBtn;
@property (nonatomic, strong) UIButton* RightItemBtn;

@property (strong, nonatomic) NetAuthorView *netAuthorView;

- (void)showNetAuthorView;
- (void)clickNetAuthorAction;


@property (assign) BOOL backButtonEnabled;
/**
 *  app的UI全局设置，包括背景色，top bar背景等
 */
- (void)UIGlobal;

/**
 *  获取全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param obj  通知来源
 */
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj;

/**
 *  touch up inside动作，返回上一页
 *
 *  @param sender 触发返回动作button
 */
- (IBAction)popVCAction:(id)sender;

//滑动
- (void)viewDidCurrentView;

- (void)naviBackBotton;

/**
 *  显示无数据状态，断网状态
 *
 *  @param text      说明文字
 *  @param imageName 图片名字
 */
-(void)showInfoView:(NSString *)text image:(NSString*)imageName;
-(void)showInfoViewAttribute:(NSMutableAttributedString *)text image:(NSString*)imageName;
- (void)removeInfoView;
- (IBAction)viewInfoClickAction:(id)sender;
//cj
-(void)showInfoView:(NSString *)text image:(NSString*)imageName flatY:(NSInteger)y;


#pragma mark - 右侧文字按钮
#pragma mark - 左上按钮
- (void)naviLeftBottonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action;


- (NSMutableArray *)sortSubmitArray:(NSMutableArray *)list;

@end
