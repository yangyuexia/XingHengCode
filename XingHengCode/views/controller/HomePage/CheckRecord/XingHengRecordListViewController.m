//
//  XingHengRecordListViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengRecordListViewController.h"
#import "XingHengRecordListCell.h"
#import "XingHengRecordDetailViewController.h"

@interface XingHengRecordListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UILabel *sectionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionNumLabel;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) CheckRecordPageModel *page;

@end

@implementation XingHengRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    
    currentPage = 1;
    
    //分页加载
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRereshing];
    }];
    
    [self footerRereshing];
    
}

- (void)footerRereshing
{
    if (currentPage > 1) {
        HttpClientMgr.progressEnabled = NO;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"pageCurrent"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageNumber"] = @"10";
    
    if (self.type == 1) {
        //故障列表
        [IndexApi EqpAbnormalWithParams:setting success:^(id obj) {
            [self.tableView.mj_footer endRefreshing];
            [self handleData:obj];
        } failure:^(HttpException *e) {
            [self.tableView.mj_footer endRefreshing];
        }];
        
    }else if (self.type == 2){
        //正常列表
        [IndexApi EqpNormalWithParams:setting success:^(id obj) {
            [self.tableView.mj_footer endRefreshing];
            [self handleData:obj];
        } failure:^(HttpException *e) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
    
}

- (void)handleData:(id)obj{
    [self removeInfoView];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"code"] = obj[@"code"];
    dic[@"message"] = obj[@"message"];
    
    NSDictionary *dd = [NSDictionary dictionaryWithDictionary:obj[@"mn"]];
    if ([[dd allKeys] count] > 0) {
        dic[@"dateText"] = [dd allKeys][0];
    }
    if ([[dd allValues] count] > 0) {
        dic[@"number"] = [dd allValues][0];
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    NSArray *array = obj[@"data"];
    for (NSDictionary *d in array) {
        NSMutableDictionary *mud = [NSMutableDictionary dictionaryWithDictionary:d];
        mud[@"neww_bar_code"] = d[@"new_bar_code"];
        [tempArr addObject:mud];
    }
    
    dic[@"data"] = tempArr;
    
    
    CheckRecordPageModel *page = [CheckRecordPageModel parse:dic Elements:[CheckRecordListModel class] forAttribute:@"data"];
    
    if ([page.code integerValue] == 200){
        self.page = page;
        NSArray *arr = page.data;
        if (arr.count == 0) {
            if (self->currentPage == 1) {
                [self showInfoView:@"暂无数据" image:@"nodata_nodata-1"];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (self->currentPage == 1) {
                [self.dataList removeAllObjects];
            }
            self->currentPage++;
            [self.dataList addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:page.message];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.sectionDateLabel.text = self.page.dateText;
    self.sectionNumLabel.text = [NSString stringWithFormat:@"共维修：%@组电池",self.page.number];
    return self.sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XingHengRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengRecordListCell"];
    [cell setCell:self.dataList[indexPath.row] type:self.type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CheckRecordListModel *model = self.dataList[indexPath.row];
    
    XingHengRecordDetailViewController *vc = [[UIStoryboard storyboardWithName:@"CheckRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengRecordDetailViewController"];
    vc.type = self.type;
    vc.listModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
