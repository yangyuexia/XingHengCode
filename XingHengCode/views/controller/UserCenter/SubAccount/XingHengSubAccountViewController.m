//
//  XingHengSubAccountViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/14.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengSubAccountViewController.h"
#import "XingHengAddAccountViewController.h"
#import "XingHengSubAccountCell.h"
#import "MGSwipeButton.h"
#import "XingHengChangeAccountPwdViewController.h"

@interface XingHengSubAccountViewController () <UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation XingHengSubAccountViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"子账号管理";
    self.dataList = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem  *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    [barButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontSystemBold(15),NSFontAttributeName, nil] forState:UIControlStateNormal];
    [barButtonItem setTintColor:RGBHex(qwColor1)];
    self.navigationItem.rightBarButtonItem =  barButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self queryData];
}

- (void)queryData{
    [self removeInfoView];
    [System CtmSubListWithParams:nil success:^(id obj) {
        SubAccountPageModel *page = [SubAccountPageModel parse:obj Elements:[SubAccountListModel class] forAttribute:@"data"];
        if ([page.code integerValue] == 200) {
            [self.dataList removeAllObjects];
            if (page.data.count > 0) {
                [self.dataList addObjectsFromArray:page.data];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"暂无数据" image:@"nodata_nodata-1"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:page.message];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XingHengSubAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengSubAccountCell"];
    cell.swipeDelegate = self;
    [cell setCell:self.dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    XingHengAddAccountViewController *vc = [[UIStoryboard storyboardWithName:@"SubAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengAddAccountViewController"];
//    vc.isAddAccount = NO;
//    vc.listModel = self.dataList[indexPath.row];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -
#pragma mark MGSwipeTableCellDelegate
-(NSArray *) createRightButtons: (int) number{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"删除",@"修改密码"};
    UIColor * colors[2] = {[UIColor redColor],[UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i){
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;{
    if (direction == MGSwipeDirectionRightToLeft){
        return [self createRightButtons:2];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *  indexPath = [self.tableView indexPathForCell:cell];
    SubAccountListModel *listModel = self.dataList[indexPath.row];
    
    if (index == 0) {
        //删除
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"id"] = listModel.id;
        [System CtmSubDeleteWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
                [self queryData];
            }else{
                [SVProgressHUD showErrorWithStatus:model.message];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
        }];
        
    }else if (index == 1){
        //修改密码
        XingHengChangeAccountPwdViewController *vc = [[UIStoryboard storyboardWithName:@"SubAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengChangeAccountPwdViewController"];
        vc.listModel = listModel;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return YES;
}

#pragma mark ---- 添加 ----
- (void)addAction{
    XingHengAddAccountViewController *vc = [[UIStoryboard storyboardWithName:@"SubAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengAddAccountViewController"];
    vc.isAddAccount = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
