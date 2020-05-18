//
//  XingHengSetBlueToothViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/16.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengSetBlueToothViewController.h"
#import "XingHengSetBlueToothCell.h"


@interface XingHengSetBlueToothViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) BlueToothModel *selectModel;

- (IBAction)deleteAction:(id)sender;
- (IBAction)searchAction:(id)sender;

@end

@implementation XingHengSetBlueToothViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"蓝牙设置";
    self.dataList = [NSMutableArray array];
    
    
    [self babyDelegate];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    
    self.deleteBtn.layer.cornerRadius = 5.0;
    self.deleteBtn.layer.masksToBounds = YES;
    
    [self setCacheBLE];
    
}

- (void)setCacheBLE{
    //判断是否有存储的蓝牙设备
    if ([QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING]) {
        NSString *uuid = [QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING];
        CBPeripheral * peripheral = [QWGLOBALMANAGER.baby retrievePeripheralWithUUIDString:uuid];
        BlueToothModel *mod = [BlueToothModel new];
        mod.peripheral = peripheral;
        mod.name = peripheral.name;
        mod.UUIDString = uuid;
        self.selectModel = mod;
        self.selectLabel.text = self.selectModel.peripheral.name;
        self.deleteBtn.hidden = NO;
        
    }else{
        self.selectLabel.text = @"暂无选择锂电检测仪";
        self.deleteBtn.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [QWGLOBALMANAGER.baby cancelScan];
    [QWGLOBALMANAGER.baby cancelAllPeripheralsConnection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XingHengSetBlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengSetBlueToothCell"];
    BlueToothModel *model = self.dataList[indexPath.row];
    cell.nameLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BlueToothModel *model = [self.dataList objectAtIndex:indexPath.row];
    self.selectModel = model;
    QWGLOBALMANAGER.baby.having(model.peripheral).then.connectToPeripherals(model.peripheral).begin();

}

#pragma mark ---- 删除 ----
- (IBAction)deleteAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectLabel.text = @"暂无选择锂电检测仪";
        self.deleteBtn.hidden = YES;
        [QWUserDefault removeObjectBy:BLUETOOTHUUIDSTRING];
        [QWGLOBALMANAGER.baby cancelAllPeripheralsConnection];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


#pragma mark ---- 搜索蓝牙设备 ----
- (IBAction)searchAction:(id)sender {
    if (QWGLOBALMANAGER.baby.centralManager.state == CBCentralManagerStatePoweredOff) {
        [SVProgressHUD showErrorWithStatus:@"请打开蓝牙设备"];
        return;
    }
    
    QWGLOBALMANAGER.baby.scanForPeripherals().begin();
    [self.searchBtn setTitle:@"正在扫描..." forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchBtn setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
    });
    
}

#pragma mark -蓝牙配置和操作
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    
    [QWGLOBALMANAGER.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            
        }else if (central.state == CBCentralManagerStatePoweredOff){
            [weakSelf.searchBtn setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
            [weakSelf.dataList removeAllObjects];
            [weakSelf.tableView reloadData];
        }
    }];
    
    
    //设置扫描到设备
    [QWGLOBALMANAGER.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    //设置查找设备的过滤器
    [QWGLOBALMANAGER.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    //连接Peripherals成功
    [QWGLOBALMANAGER.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        weakSelf.selectLabel.text = weakSelf.selectModel.peripheral.name;
        weakSelf.deleteBtn.hidden = NO;
        [QWUserDefault setObject:weakSelf.selectModel.peripheral.identifier.UUIDString key:BLUETOOTHUUIDSTRING];
    }];
    
    //断开Peripherals的连接
    [QWGLOBALMANAGER.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        NSArray * array = [NSArray arrayWithArray:weakSelf.dataList];
        for (BlueToothModel *model in array) {
            if ([model.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                [weakSelf.dataList removeObject:model];
                [weakSelf.tableView reloadData];
            }
        }
    }];
    
    [QWGLOBALMANAGER.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        [weakSelf.searchBtn setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
    }];
    

}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSArray *peripherals = [self.dataList valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        BlueToothModel *model = [[BlueToothModel alloc] init];
        model.peripheral = peripheral;
        model.UUIDString = peripheral.identifier.UUIDString;
        model.name = peripheral.name;
        [self.dataList addObject:model];
        [self.tableView reloadData];
    }
}


@end
