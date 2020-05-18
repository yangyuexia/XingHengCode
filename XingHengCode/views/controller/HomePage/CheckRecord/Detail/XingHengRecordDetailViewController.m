//
//  XingHengRecordDetailViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengRecordDetailViewController.h"
#import "XingHengRecordDetailCell.h"

@interface XingHengRecordDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) NSMutableArray *contentList;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;


@end

@implementation XingHengRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentList = [NSMutableArray array];
    
    if (self.type == 1) {
        self.title = @"故障记录详情";
        self.titleList = @[@[@"电池条码",@"产品规格",@"故障名称",@"检修时间",@"保修状态",@"返厂状态",@"更换电池",@"检测仪ID",],@[@"检修员",@"检修城市",@"检修员手机号",]];
        NSMutableArray *arr1 = [NSMutableArray array];
        [arr1 addObject:StrFromObj(self.listModel.bar_code)];
        [arr1 addObject:StrFromObj(self.listModel.sku)];
        [arr1 addObject:StrFromObj(self.listModel.fault_name)];
        [arr1 addObject:StrFromObj(self.listModel.repair_time)];
        [arr1 addObject:StrFromObj(self.listModel.warranty_status)];
        [arr1 addObject:@""];
        [arr1 addObject:StrFromObj(self.listModel.neww_bar_code)];
        [arr1 addObject:StrFromObj(self.listModel.detector)];
        [self.contentList addObject:arr1];
        
    }else{
        self.title = @"正常记录详情";
        self.titleList = @[@[@"电池条码",@"产品规格",@"检修时间",@"保修状态",@"检测仪ID",],@[@"检修员",@"检修城市",@"检修员手机号",]];
        NSMutableArray *arr1 = [NSMutableArray array];
        [arr1 addObject:StrFromObj(self.listModel.bar_code)];
        [arr1 addObject:StrFromObj(self.listModel.sku)];
        [arr1 addObject:StrFromObj(self.listModel.repair_time)];
        [arr1 addObject:StrFromObj(self.listModel.warranty_status)];
        [arr1 addObject:StrFromObj(self.listModel.detector)];
        [self.contentList addObject:arr1];
    }
    
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr2 addObject:StrFromObj(self.listModel.overhaul_clerk)];
    [arr2 addObject:StrFromObj(self.listModel.city)];
    [arr2 addObject:StrFromObj(self.listModel.phone)];
    [self.contentList addObject:arr2];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setUpFooter];
    
}

- (void)setUpFooter{
    NSString *str = [self getResultArray:self.listModel.no_load_data];
    self.footerLabel.text = str;
        
    CGSize size = [QWGLOBALMANAGER sizeText:str font:fontSystem(13) limitWidth:APP_W-30];
    self.footerView.frame = CGRectMake(0, 0, APP_W, size.height+50);
    self.tableView.tableFooterView = self.footerView;
}

//1.转化为json
- (NSString *)getResultArray:(NSString *)result
{
    //1.转化为json
    if (result == nil) {
        return @"";
    }
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return @"";
    }
    
    //2.得到所有的key
    NSArray *keys = [dic allKeys];
    NSMutableDictionary *needDic = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        if ([result containsString:key]) {
            //3.取出字符串通过key 得到的前面的字符串 并保存到新的字典中
            NSArray *arr = [result componentsSeparatedByString:key];
            NSString *lenth = arr[0];
            [needDic setValue:key forKey:lenth];
        }
    }
    
    //4.遍历得到字符串中按照循序出现的keys
    NSMutableArray *needKeys = [NSMutableArray array];
    NSArray *a0 = [[needDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger len0 = [(NSString *)obj1 length];
        NSUInteger len1 = [(NSString *)obj2 length];
        return len0 > len1 ? NSOrderedDescending : NSOrderedAscending;
    }];
    [a0 enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [needKeys addObject:needDic[obj]];
    }];
    
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    
    //5.取出数据
    [needKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@：%@ \n",obj,dic[obj]];
        [mutableStr appendString:str];
    }];
    
    return mutableStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 20)];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XingHengRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengRecordDetailCell"];
    cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
    cell.contentLabel.text = self.contentList[indexPath.section][indexPath.row];
    return cell;
}


@end
