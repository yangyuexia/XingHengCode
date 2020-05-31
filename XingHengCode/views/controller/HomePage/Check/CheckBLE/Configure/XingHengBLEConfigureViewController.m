//
//  XingHengBLEConfigureViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengBLEConfigureViewController.h"
#import "EBDropdownListView.h"

@interface XingHengBLEConfigureViewController ()

@property (weak, nonatomic) IBOutlet UIButton *restoreBtn;
- (IBAction)restoreAction:(id)sender;

@property (strong, nonatomic) EBDropdownListView *listView1;
@property (strong, nonatomic) EBDropdownListView *listView2;


@end

@implementation XingHengBLEConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯方式配置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.restoreBtn.layer.cornerRadius = 22;
    self.restoreBtn.layer.masksToBounds = YES;
    
    
    NSInteger code1 = 0;
    NSInteger code2 = 0;
    if ([QWUserDefault getObjectBy:BLETONGXUNCONFIGURE]) {
        NSString *code = [QWUserDefault getObjectBy:BLETONGXUNCONFIGURE];
        if (code.length == 2) {
            code1 = [[code substringToIndex:1] integerValue];
            code2 = [[code substringFromIndex:1] integerValue];
        }
    }
    
    
    // 通讯方式
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:[self getStyleDataSource]];
    _listView1 = [[EBDropdownListView alloc] initWithDataSource:array1];
    _listView1.frame = CGRectMake(100, 16, APP_W-130, 35);
    for (NSInteger i=0; i<array1.count; i++) {
        EBDropdownListItem *item = array1[i];
        if ([item.itemId integerValue] == code1) {
            _listView1.selectedIndex = i;
        }
    }
    [_listView1 setViewBorder:0.5 borderColor:RGBHex(qwColor4) cornerRadius:5];
    [self.view addSubview:_listView1];
    
    __weak typeof(self) weakSelf = self;
    [_listView1 setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        //根据通讯方式 更新参数列表
        NSArray *array = [weakSelf getParamDataSource:[dropdownListView.selectedItem.itemId intValue]];
        weakSelf.listView2.dataSource = array;
        [weakSelf.listView2.tbView reloadData];
        weakSelf.listView2.selectedIndex = 0;
    }];
    

    
    // 通讯参数
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:[self getParamDataSource:code1]];
    _listView2 = [[EBDropdownListView alloc] init];;
    _listView2.dataSource = array2;
    _listView2.frame = CGRectMake(100, 56, APP_W-130, 35);
    
    for (NSInteger i=0; i<array2.count; i++) {
        EBDropdownListItem *item = array2[i];
        if ([item.itemId integerValue] == code2) {
            _listView2.selectedIndex = i;
        }
    }
    
    [_listView2 setViewBorder:0.5 borderColor:RGBHex(qwColor4) cornerRadius:5];
    [self.view addSubview:_listView2];
    [_listView2 setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
  
    }];
    
}

- (void)popVCAction:(id)sender{
    NSString *code = [NSString stringWithFormat:@"%@%@",self.listView1.selectedItem.itemId,self.listView2.selectedItem.itemId];
    if (self.configureBlock) {
        self.configureBlock(code);
    }
    [super popVCAction:nil];
}


#pragma mark ---- 恢复默认配置 ----
- (IBAction)restoreAction:(id)sender {
    NSString *code = @"20";
    if (self.configureBlock) {
        self.configureBlock(code);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)getStyleDataSource{
    EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"0" itemName:@"0：单线通讯"];
    EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"2：UART"];
    EBDropdownListItem *item3 = [[EBDropdownListItem alloc] initWithItem:@"4" itemName:@"4：RS485"];
    EBDropdownListItem *item4 = [[EBDropdownListItem alloc] initWithItem:@"6" itemName:@"6：CAN"];
    NSArray *dataSource = @[item1, item2, item3, item4];
    return dataSource;
}

- (NSArray *)getParamDataSource:(int)itemID{
    
    NSArray *dataSource;
    if (itemID == 0) {
        EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"1：9600,8,无,1"];
        EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"2：2400,8,无,1"];
        dataSource = @[item1, item2];
        
    }else if (itemID == 2){
        EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"0" itemName:@"0：9600,8,无,1"];
        EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"1：2400,8,无,1"];
        dataSource = @[item1, item2];
        
    }else if (itemID == 4){
        EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"0" itemName:@"0：9600,8,无,1"];
        EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"1：9600,8,偶,1"];
        EBDropdownListItem *item3 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"2：9600,8,奇,1"];
        EBDropdownListItem *item4 = [[EBDropdownListItem alloc] initWithItem:@"3" itemName:@"3：19200,8,无,1"];
        EBDropdownListItem *item5 = [[EBDropdownListItem alloc] initWithItem:@"4" itemName:@"4：115200,8,无,1"];
        EBDropdownListItem *item6 = [[EBDropdownListItem alloc] initWithItem:@"5" itemName:@"5：115200,8,偶,1"];
        EBDropdownListItem *item7 = [[EBDropdownListItem alloc] initWithItem:@"6" itemName:@"6：115200,8,奇,1"];
        dataSource = @[item1, item2, item3, item4, item5, item6, item7];
        
    }else if (itemID == 6){
        EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"0" itemName:@"0：125K"];
        EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"1：250K"];
        EBDropdownListItem *item3 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"2：500K"];
        EBDropdownListItem *item4 = [[EBDropdownListItem alloc] initWithItem:@"3" itemName:@"3：1M"];
        dataSource = @[item1, item2, item3, item4];
    }
    
    return dataSource;
}


@end
