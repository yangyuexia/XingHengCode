//
//  XingHengSaleCheckViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengSaleCheckViewController.h"
#import "XingHengCheckResultCell.h"
#import "XingHengCheckDataCell.h"
#import "CustomHeaderView.h"
#import "XingHengBLEConfigureViewController.h"
#import "CustomFooterView.h"
#import "XingHengWarrantyQueryViewController.h"
#import "XingHengScanViewController.h"

NSString * const RESULT23 = @"3A16230039000D0A";
NSString * const RESULT24 = @"3A1624010B46000D0A";
NSString * const RESULT25 = @"3A1625010B47000D0A";
NSString * const RESULT22 = @"3A1622010039000D0A";
NSString * const RESULT7E = @"3A167E010095000D0A";
NSString * const RESULT0A = @"3A160A010021000D0A";
NSString * const RESULT0D = @"3A160D010024000D0A";
NSString * const RESULT99 = @"3A16990100B0000D0A";
NSString * const RESULT08 = @"3A160801001F000D0A";
NSString * const RESULT09 = @"3A1609010020000D0A";
NSString * const RESULT0F = @"3A160F010026000D0A";
NSString * const RESULT10 = @"3A1610010027000D0A";
NSString * const RESULT17 = @"3A161701002E000D0A";
NSString * const RESULT0C = @"3A160C010023000D0A";
NSString * const RESULT7F = @"3A167F010096000D0A";
NSString * const RESULT980 = @"3A16980100AF000D0A";
NSString * const RESULT981 = @"3A16980101B0000D0A";
NSString * const RESULT982 = @"3A16980102B1000D0A";
NSString * const RESULT18 = @"3A161801002F000D0A";
NSString * const RESULT21 = @"3A1621010038000D0A";


@interface XingHengSaleCheckViewController () <UITableViewDataSource, UITableViewDelegate, CustomHeaderViewDelegate,XingHengCheckResultCellDelegate>
{
    dispatch_source_t   send23Timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (strong, nonatomic) CustomHeaderView *customHeaderView;
@property (strong, nonatomic) CustomFooterView *CustomFooterView;

@property (assign, nonatomic) NSInteger connectState;

@property (strong, nonatomic) CBPeripheral * peripheral;
@property (strong, nonatomic) CBCharacteristic *characteristic;

@property (strong, nonatomic) NSString *currentSendFF;
@property (strong , nonatomic) NSMutableArray *voltage ;

@property  (strong, nonatomic) NSMutableArray *voltageName;
@property (strong, nonatomic) NSMutableArray *voltageArray;

@property (strong, nonatomic) NSMutableDictionary *cacheOnceDic;
@property (strong, nonatomic) BatteryCheckDataModel *checkDataModel;
@property (strong, nonatomic) FaultDiagnosisPageModel *diagnosisPageModel;

@property (assign, nonatomic) BOOL sendFFSuccess;

@property (assign, nonatomic) NSInteger send23Once;

@property (strong, nonatomic) NSString *bleName;

@property (assign, nonatomic) BOOL getBoxCode;
@property (assign, nonatomic) NSInteger getBoxCodeIndex;

- (IBAction)backAction:(id)sender;
- (IBAction)configureAction:(id)sender;


@end

@implementation XingHengSaleCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
#else
    
#endif
    
    self.currentSendFF = @"";
    self.voltageName = [NSMutableArray array];
    self.voltageArray = [NSMutableArray array];
    self.cacheOnceDic = [NSMutableDictionary dictionary];
    self.checkDataModel = [BatteryCheckDataModel new];
    self.sendFFSuccess = NO;
    self.voltage = [NSMutableArray array];
    
    if (self.batteryInfoModel) {
        self.titleLabel.text = [NSString stringWithFormat:@"售后检测(%@)",self.batteryInfoModel.V];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];

    [self setUpHeader];
    [self updateHeaderUI:0];
    
    [self initVoltageData];
    
    
    if (QWGLOBALMANAGER.baby.centralManager.state == CBCentralManagerStatePoweredOn) {
        if ([QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING]) {
            NSString *uuid = [QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING];
            CBPeripheral * peripheral = [QWGLOBALMANAGER.baby retrievePeripheralWithUUIDString:uuid];
            self.peripheral = peripheral;
            QWGLOBALMANAGER.baby.cancelAllPeripheralsConnection;
            QWGLOBALMANAGER.baby.having(self.peripheral).and.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
        }
    }

}

- (void)setUpHeader{
    self.customHeaderView = [[CustomHeaderView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 290)];
    self.customHeaderView.customHeaderViewDelegate = self;
    [self.headerContainer addSubview:self.customHeaderView];
    [self.customHeaderView configureData:self.batteryInfoModel];
    
    self.headerView.frame = CGRectMake(0, 0, APP_W, 382-20+STATUS_H);
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setUpFooter{
    QWGLOBALMANAGER.isChecking = NO;
    self.CustomFooterView = [[CustomFooterView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 360)];
    [self.CustomFooterView configureData:self.checkDataModel];
    self.tableView.tableFooterView = self.CustomFooterView;
    [self.tableView reloadData];
}


- (void)updateHeaderUI:(NSInteger)state{
    if (state == 3 && QWGLOBALMANAGER.isChecking) {
        return;
    }else{
        QWGLOBALMANAGER.isChecking = NO;
    }
        
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == 0) { //蓝牙断开
            self.backgroundImage.image = [UIImage imageNamed:@"img-con-unconnect-img"];
        }else if (state == 1) { //蓝牙打开 尝试连接
            self.backgroundImage.image = [UIImage imageNamed:@"img-con-waiting-img"];
        }else if (state == 2){ //蓝牙已连接 电池未连接
            self.backgroundImage.image = [UIImage imageNamed:@"img-con-waiting-img"];
        }else if (state == 3){ //全部连接
            self.backgroundImage.image = [UIImage imageNamed:@"img-con-connected-img"];
        }
        [self.customHeaderView updateConnentStateView:state];
    });

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self babyDelegate];
//    [self create23Timer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self release23Timer];
}

- (void)create23Timer{
    send23Timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(send23Timer, dispatch_time(DISPATCH_TIME_NOW, 0), 0.5*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(send23Timer, ^{
        [self checkPeripheralState];
        [self send_23];
    });
    dispatch_resume(send23Timer);
}

- (void)release23Timer{
    if(send23Timer){
        dispatch_source_cancel(send23Timer);
        send23Timer = NULL;
    }
}

- (void)checkPeripheralState{
    if (!self.peripheral || self.peripheral.state != CBPeripheralStateConnected) {
        [self connectBLE];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && self.diagnosisPageModel) {
        return 1;
    }else if (section == 1 && self.voltageArray.count > 0) {
        if ([QWGLOBALMANAGER.powerInfoModel.check containsObject:@"2001"]) {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.diagnosisPageModel) {
        return [XingHengCheckResultCell getCellHeight:self.diagnosisPageModel];
    }else if (indexPath.section == 1 && self.voltageArray.count > 0) {
        return 250;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        XingHengCheckResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengCheckResultCell"];
        [cell setCell:self.diagnosisPageModel];
        cell.xingHengCheckResultCellDelegate = self;
        return cell;
        
    }else if (indexPath.section == 1){
        XingHengCheckDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XingHengCheckDataCell"];
        [cell setCell:self.voltageName :self.voltageArray];
        return cell;
    }
    return nil;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 快速申请售后 ----
- (void)applyAction{
    XingHengWarrantyQueryViewController *vc = [[UIStoryboard storyboardWithName:@"WarrantyQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengWarrantyQueryViewController"];
    vc.fromHomePage = NO;
    vc.bleName = self.bleName;
    vc.batteryInfoModel = self.batteryInfoModel;
    vc.checkDataModel = self.checkDataModel;
    vc.diagnosisPageModel = self.diagnosisPageModel;
    vc.voltageArray = [NSMutableArray arrayWithArray:self.voltageArray];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 智能电池检测 ----
- (void)checkBatteryAction{
    QWGLOBALMANAGER.isChecking = YES;
    [self release23Timer];
    [self.customHeaderView checkingState];
    [self clearAllData];
    [self.tableView reloadData];
    
    if (self.fromHomePage) {
        self.getBoxCode = NO;
        self.getBoxCodeIndex = 0;
        [self autoGetChengPinCode];
        
    }else{
        [self checkProcessAction];
    }
}

- (void)autoGetChengPinCode{

    //如果已经获取到条码 return
    if (!self.fromHomePage || self.getBoxCode) {
        return;
    }
    
    if (self.getBoxCodeIndex < 4) {
        //如果发送次数<4，延迟0.2s继续发送指令
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.getBoxCodeIndex ++;
            [self send_7E];
            [self autoGetChengPinCode];
        });
    }else{
        //如果发送次数>4
        //退回首页 跳转到扫码页面
        [self release23Timer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UITabBarController *vcTab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                if ([vcTab isKindOfClass:[QWTabBar class]]) {
                    UINavigationController *nav = (UINavigationController *)vcTab.selectedViewController;
                    XingHengScanViewController *vc = [[UIStoryboard storyboardWithName:@"Check" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengScanViewController"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:vc animated:YES];
                }
            });
        });
    }
}

#pragma mark ---- 正常检测流程 ----
- (void)checkProcessAction{
    QWGLOBALMANAGER.isChecking = YES;
    [self release23Timer];
    [self.customHeaderView checkingState];
    [self clearAllData];
    [self.tableView reloadData];
    [self send_24];
}


#pragma mark ---- 清空所有数据 ----
- (void)clearAllData{
    self.diagnosisPageModel = nil;
    [self.cacheOnceDic removeAllObjects];
    [self.voltageArray removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.tableFooterView = [UIView new];
        [self.tableView reloadData];
    });
}

#pragma mark ---- 通讯配置 ----
- (IBAction)configureAction:(id)sender {
    XingHengBLEConfigureViewController *vc = [[UIStoryboard storyboardWithName:@"Check" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengBLEConfigureViewController"];
    __weak typeof(self) weakSelf = self;
    vc.configureBlock = ^(NSString * _Nonnull code) {
        //转成16进制
        [QWUserDefault setObject:code key:BLETONGXUNCONFIGURE];
        [weakSelf.voltageName removeAllObjects];
        [weakSelf clearAllData];
        weakSelf.sendFFSuccess = NO;
        [weakSelf send_FF];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 连接蓝牙
- (void)connectBLE{
    if (QWGLOBALMANAGER.baby.centralManager.state == CBCentralManagerStatePoweredOn) {
        if ([QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING]) {
            NSString *uuid = [QWUserDefault getObjectBy:BLUETOOTHUUIDSTRING];
            CBPeripheral * peripheral = [QWGLOBALMANAGER.baby retrievePeripheralWithUUIDString:uuid];
            self.peripheral = peripheral;
            
            if (peripheral.state != CBPeripheralStateConnected) {
                [self clearAllData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateHeaderUI:1];
                });
                QWGLOBALMANAGER.baby.having(self.peripheral).and.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
            }
        }
    }
}

#pragma mark ---- 发送FF指令
- (void)send_FF{
    
    if (self.sendFFSuccess) {
        return;
    }
    
    NSString *code = @"20";
    if ([QWUserDefault getObjectBy:BLETONGXUNCONFIGURE]) {
        code = [QWUserDefault getObjectBy:BLETONGXUNCONFIGURE];
    }
    
    if (self.boxCode.length > 0) {
        code = self.boxCode;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateHeaderUI:1];
    });

    NSString *hexCode = [QWGLOBALMANAGER tenToHex:[code integerValue]];
    NSInteger a = [QWGLOBALMANAGER hexToTen:@"16"];
    NSInteger b = [QWGLOBALMANAGER hexToTen:@"FF"];
    NSInteger c = [QWGLOBALMANAGER hexToTen:@"01"];
    NSInteger d = [QWGLOBALMANAGER hexToTen:hexCode];
    NSInteger e = a+b+c+d;
    
    UInt16  Byte = e; //十进制转十六进制
    HTONS(Byte);      //字节翻转

    NSString *ff = [NSString stringWithFormat:@"3A16FF01%@%x0D0A",hexCode,Byte];
    ff = [ff lowercaseString];
    self.currentSendFF = ff;
    
    
    //发送数据
    NSMutableData *data = [QWGLOBALMANAGER convertHexStrToData:[ff lowercaseString]];
    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected && self.characteristic) {
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self send_FF];
    });
    
    
    
    
    
}

#pragma mark ---- 发送23指令
- (void)send_23{
    
    if (!self.peripheral || self.peripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    if (self.send23Once > 3) {//电池连接断开
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateHeaderUI:2];
        });
        [self clearAllData];
        
    }
    
    NSLog(@"=============%ld",self.send23Once);
    
    self.send23Once++;
    NSMutableData *data = [QWGLOBALMANAGER convertHexStrToData:[RESULT23 lowercaseString]];
    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected && self.characteristic) {
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark ---- 发送24指令
- (void)send_24{
    [self writeValue:RESULT24];
}

#pragma mark ---- 发送25指令
- (void)send_25{
    [self writeValue:RESULT25];
}

#pragma mark ---- 发送22指令
- (void)send_22{
    [self writeValue:RESULT22];
}

#pragma mark ---- 发送7E指令
- (void)send_7E{
    [self writeValue:RESULT7E];
}

#pragma mark ---- 发送0A指令
- (void)send_0A{
    [self writeValue:RESULT0A];
}

#pragma mark ---- 发送0D指令
- (void)send_0D{
    [self writeValue:RESULT0D];
}

#pragma mark ---- 发送99指令
- (void)send_99{
    [self writeValue:RESULT99];
}

#pragma mark ---- 发送08指令
- (void)send_08{
    [self writeValue:RESULT08];
}

#pragma mark ---- 发送09指令
- (void)send_09{
    [self writeValue:RESULT09];
}

#pragma mark ---- 发送0F指令
- (void)send_0F{
    [self writeValue:RESULT0F];
}

#pragma mark ---- 发送10指令
- (void)send_10{
    [self writeValue:RESULT10];
}

#pragma mark ---- 发送17指令
- (void)send_17{
    [self writeValue:RESULT17];
}

#pragma mark ---- 发送0C指令
- (void)send_0C{
    [self writeValue:RESULT0C];
}

#pragma mark ---- 发送7F指令
- (void)send_7F{
    [self writeValue:RESULT7F];
}

#pragma mark ---- 发送98指令
- (void)send_980{
    [self writeValue:RESULT980];
}

#pragma mark ---- 发送98指令
- (void)send_981{
    [self writeValue:RESULT981];
}

#pragma mark ---- 发送98指令
- (void)send_982{
    [self writeValue:RESULT982];
}

#pragma mark ---- 发送18指令
- (void)send_18{
    [self writeValue:RESULT18];
}

#pragma mark ---- 发送21指令
- (void)send_21{
    [self writeValue:RESULT21];
}

- (void)writeValue:(NSString *)orderText{
    if (StrIsEmpty(orderText)) {
        return;
    }
    
    NSInteger currentIndex = 0;
    if([[self.cacheOnceDic allKeys] containsObject:orderText]){
        currentIndex = [[self.cacheOnceDic objectForKey:orderText] integerValue];
    }
    
    if (currentIndex == 100) { //指令发送成功，不需重发
        return;
    }
    
    if (currentIndex >= 3) { //指令已发送三次，进入下一指令
        [self sendAllOrder:orderText];
        return;
    }
    
    //发送数据
    NSMutableData *data = [QWGLOBALMANAGER convertHexStrToData:[orderText lowercaseString]];
    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected && self.characteristic) {
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    currentIndex ++;
    [self.cacheOnceDic setObject:StrFromInt(currentIndex) forKey:orderText];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self writeValue:orderText];
    });

}

- (void)sendAllOrder:(NSString *)currentOrder{
    if ([currentOrder isEqualToString:RESULT24]) {
        [self send_25];
    }else if ([currentOrder isEqualToString:RESULT25]){
        [self send_22];
    }else if ([currentOrder isEqualToString:RESULT22]){
        [self send_7E];
    }else if ([currentOrder isEqualToString:RESULT7E]){
        [self send_0A];
    }else if ([currentOrder isEqualToString:RESULT0A]){
        [self send_0D];
    }else if ([currentOrder isEqualToString:RESULT0D]){
        [self send_99];
    }else if ([currentOrder isEqualToString:RESULT99]){
        [self send_08];
    }else if ([currentOrder isEqualToString:RESULT08]){
        [self send_09];
    }else if ([currentOrder isEqualToString:RESULT09]){
        [self send_0F];
    }else if ([currentOrder isEqualToString:RESULT0F]){
        [self send_10];
    }else if ([currentOrder isEqualToString:RESULT10]){
        [self send_17];
    }else if ([currentOrder isEqualToString:RESULT17]){
        [self send_0C];
    }else if ([currentOrder isEqualToString:RESULT0C]){
        [self send_7F];
    }else if ([currentOrder isEqualToString:RESULT7F]){
        [self send_980];
    }else if ([currentOrder isEqualToString:RESULT980]){
        [self send_981];
    }else if ([currentOrder isEqualToString:RESULT981]){
        [self send_982];
    }else if ([currentOrder isEqualToString:RESULT982]){
        [self send_18];
    }else if ([currentOrder isEqualToString:RESULT18]){
        [self send_21];
    }
}

#pragma mark ---- 蓝牙代理 ----
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    
    [QWGLOBALMANAGER.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateHeaderUI:1];
            });
            [weakSelf connectBLE];
        }else if (central.state == CBCentralManagerStatePoweredOff){
            [SVProgressHUD showErrorWithStatus:@"请打开蓝牙设备"];
            [weakSelf clearAllData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateHeaderUI:0];
            });
        }
    }];
    

    //连接Peripherals成功
    [QWGLOBALMANAGER.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateHeaderUI:1];
        });
        weakSelf.bleName = peripheral.name;
    }];


    //断开Peripherals的连接
    [QWGLOBALMANAGER.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateHeaderUI:1];
        });
    }];

    [QWGLOBALMANAGER.baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateHeaderUI:1];
        });
    }];


    //发现Characteristics
    [QWGLOBALMANAGER.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {

        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                weakSelf.characteristic = characteristic;

                //设置通信的波特率，设置成功之后，再连接电池
                weakSelf.sendFFSuccess = NO;
                [weakSelf send_FF];
            }
        }
    }];



    //读取characteristics 监听数据
    [QWGLOBALMANAGER.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf onReadValueCharacteristic:characteristic];
        });
    }];
 
}

- (void)onReadValueCharacteristic:(CBCharacteristic *)characteristic{
    
    NSString *receiveString = [QWGLOBALMANAGER hexStringFromData:characteristic.value];
    
//    NSLog(@"=============%@",receiveString);
    
    if ([receiveString isEqualToString:self.currentSendFF]) { //FF
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateHeaderUI:2];
        });
        
        self.sendFFSuccess = YES;
        [self create23Timer];
        
    }else if ([receiveString containsString:@"3a1623"]){ //23
        self.send23Once = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateHeaderUI:3];
        });
        [self handle23Data:characteristic.value];
        
        
    }else if ([receiveString containsString:@"3a1624"]){ //24
        [self.cacheOnceDic setObject:@"100" forKey:RESULT24];
        [self handle24Data:characteristic.value];
        [self sendAllOrder:RESULT24];
        
    }else if ([receiveString containsString:@"3a1625"]){ //25
        [self.cacheOnceDic setObject:@"100" forKey:RESULT25];
        [self handle24Data:characteristic.value];
        [self sendAllOrder:RESULT25];
        
    }else if ([receiveString containsString:@"3a1622"]){ //22
        [self.cacheOnceDic setObject:@"100" forKey:RESULT22];
        [self handle22Data:characteristic.value];
        [self sendAllOrder:RESULT22];
    
    }else if ([receiveString containsString:@"3a167e"]){ //7E
        [self.cacheOnceDic setObject:@"100" forKey:RESULT7E];
        [self handle7EData:characteristic.value];
        
    
        if (self.fromHomePage && !self.getBoxCode) {
            self.getBoxCode = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getChengPinCode:characteristic.value];
            });

        }else{
            [self sendAllOrder:RESULT7E];
        }
                
        
    }else if ([receiveString containsString:@"3a160a"]){ //0A
        [self.cacheOnceDic setObject:@"100" forKey:RESULT0A];
        [self handle0AData:characteristic.value];
        [self sendAllOrder:RESULT0A];
        
    }else if ([receiveString containsString:@"3a160d"]){ //0D
        [self.cacheOnceDic setObject:@"100" forKey:RESULT0D];
        [self handle0DData:characteristic.value];
        [self sendAllOrder:RESULT0D];
        
    }else if ([receiveString containsString:@"3a1699"]){ //99
        [self.cacheOnceDic setObject:@"100" forKey:RESULT99];
        [self handle99Data:characteristic.value];
        [self sendAllOrder:RESULT99];
        
    }else if ([receiveString containsString:@"3a1608"]){ //08
        [self.cacheOnceDic setObject:@"100" forKey:RESULT08];
        [self handle08Data:characteristic.value];
        [self sendAllOrder:RESULT08];
        
    }else if ([receiveString containsString:@"3a1609"]){ //09
        [self.cacheOnceDic setObject:@"100" forKey:RESULT09];
        [self handle09Data:characteristic.value];
        [self sendAllOrder:RESULT09];
        
    }else if ([receiveString containsString:@"3a160f"]){ //0F
        [self.cacheOnceDic setObject:@"100" forKey:RESULT0F];
        [self handle0FData:characteristic.value];
        [self sendAllOrder:RESULT0F];
        
    }else if ([receiveString containsString:@"3a1610"]){ //10
        [self.cacheOnceDic setObject:@"100" forKey:RESULT10];
        [self handle10Data:characteristic.value];
        [self sendAllOrder:RESULT10];
        
    }else if ([receiveString containsString:@"3a1617"]){ //17
        [self.cacheOnceDic setObject:@"100" forKey:RESULT17];
        [self handle17Data:characteristic.value];
        [self sendAllOrder:RESULT17];
        
    }else if ([receiveString containsString:@"3a160c"]){ //0C
        [self.cacheOnceDic setObject:@"100" forKey:RESULT0C];
        [self handle0CData:characteristic.value];
        [self sendAllOrder:RESULT0C];
        
    }else if ([receiveString containsString:@"3a167f"]){ //7F
        [self.cacheOnceDic setObject:@"100" forKey:RESULT7F];
        [self handle7FData:characteristic.value];
        [self sendAllOrder:RESULT7F];
        
    }else if ([receiveString containsString:@"3a1698"]){ //98
        NSMutableArray *arr = [self bleDataToArraySingle:characteristic.value];
        
        if ([arr[0] intValue] == 0) {
            [self.cacheOnceDic setObject:@"100" forKey:RESULT980];
            [self handle980Data:characteristic.value];
            [self sendAllOrder:RESULT980];
            
        }else if ([arr[0] intValue] == 1){
            [self.cacheOnceDic setObject:@"100" forKey:RESULT981];
            [self handle981Data:characteristic.value];
            [self sendAllOrder:RESULT981];
            
        }else if ([arr[0] intValue] == 2){
            [self.cacheOnceDic setObject:@"100" forKey:RESULT982];
            [self handle982Data:characteristic.value];
            [self sendAllOrder:RESULT982];
            
        }
        
    }else if ([receiveString containsString:@"3a1618"]){ //18
        [self.cacheOnceDic setObject:@"100" forKey:RESULT18];
        [self handle18Data:characteristic.value];
        [self sendAllOrder:RESULT18];
        
    }else if ([receiveString containsString:@"3a1621"]){ //21
        [self.cacheOnceDic setObject:@"100" forKey:RESULT21];
        [self handle21Data:characteristic.value];
        [self sendAllOrder:RESULT21];
        
    }
}

- (void)handle23Data:(NSData *)data{
    NSMutableArray *array = [self bleDataToArraySingle:data];
    if (array.count >= 4) {
        
         NSArray *secondArray = [self getBitFromInt:[array[2] intValue]];
           NSArray *thirdArray = [self getBitFromInt:[array[3] intValue]];

           self.checkDataModel.chg_mos_err = secondArray[0]; //充电MOS 失效
           self.checkDataModel.ovpf = secondArray[1]; //充电严重过压
           self.checkDataModel.bad_cell = secondArray[2]; //电芯故障
           self.checkDataModel.unbalance = secondArray[3]; //电芯不平
           self.checkDataModel.ntc_fail = thirdArray[4]; //温度探头损坏
           self.checkDataModel.fuse_cut = thirdArray[3]; //保险丝熔断
    }
   
}

- (NSArray *)getBitFromInt:(int)aaaa{
    Byte b = (Byte)(0XFF & aaaa);
    Byte arr[8] = {0};
    for (int i = 7; i >= 0; i--) {
        arr[i] = (Byte)(b & 1);
        b = (Byte) (b >> 1);
    }//8位bit的数组
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        [result addObject:[NSString stringWithFormat:@"%hhu",arr[i]]];
    }
    return result;
}

//智能取4位
- (void)handle24Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    for (NSString *str in arr) {
        float dd = [str floatValue];
        [self.voltageArray addObject:[NSString stringWithFormat:@"%.1fmV",dd]];
    }
    
    [self.voltageName removeAllObjects];
    for (int i=0; i<self.voltageArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        if (i+1<10) {
            str = [NSString stringWithFormat:@"0%d",i+1];
        }
        [self.voltageName addObject:[NSString stringWithFormat:@"#%@",str]];
    }
    

    float max =[[self.voltageArray valueForKeyPath:@"@max.floatValue"] floatValue];
    float min =[[self.voltageArray valueForKeyPath:@"@min.floatValue"] floatValue];
    float reduce = max-min;
    self.checkDataModel.zddyc = [NSString localizedStringWithFormat:@"%.1fmV",reduce];
    
    int soc = [self checkPercent:max/1000] - [self checkPercent:min/1000];
    self.checkDataModel.soc = [NSString stringWithFormat:@"%d%%",soc];
    self.checkDataModel.minsoc = [NSString stringWithFormat:@"%d%%",[self checkPercent:min/1000]];
    
}

- (void)handle22Data:(NSData *)data{
    NSMutableArray *array = [self bleDataToArraySingle:data];
    NSMutableString *result = [NSMutableString string];
    for (NSString *str in array) {
        int asciiCode = [str intValue];
        NSString *string =[NSString stringWithFormat:@"%c",asciiCode];
        [result appendString:string];
    }
    self.checkDataModel.bcpCode = result;
}

- (void)handle7EData:(NSData *)data{
    NSMutableArray *array = [self bleDataToArraySingle:data];
    NSMutableString *result = [NSMutableString string];
    for (NSString *str in array) {
        int asciiCode = [str intValue];
        NSString *string =[NSString stringWithFormat:@"%c",asciiCode];
        [result appendString:string];
    }
    self.checkDataModel.cpCode = result;
}

- (void)handle0AData:(NSData *)data{
    //3a160a04 00000000 24000d0
    NSMutableArray *arr = [self bleDataToArraySingle:data];

    NSInteger stepLow = [arr[0] integerValue];
    NSInteger stepHig = [arr[1] integerValue];
    NSInteger crt = stepHig+stepLow;
    if (crt > 32768) { //负数电流表示放电
        crt = (int)(char)~crt+1; //取反+1，获得补码值 电流数据就是带符号的f数据
        crt = -crt;
    }
    self.checkDataModel.ssdl = [NSString stringWithFormat:@"%ldmA",crt]; //mv

}

- (void)handle0DData:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    NSString *str = [arr componentsJoinedByString:@""];
    self.checkDataModel.xdrlbfb = [NSString stringWithFormat:@"%@%%",str];
}

- (void)handle99Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArraySingle:data];
    int a = [arr[2] intValue] - [arr[1] intValue];
    self.checkDataModel.soc = [NSString stringWithFormat:@"%d%%",a];
    self.checkDataModel.minsoc = [NSString stringWithFormat:@"%d%%",[arr[1] intValue]];
}

- (void)handle08Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    float aa = ([arr[0] intValue]-2731)/10.0;
    self.checkDataModel.wd = [NSString stringWithFormat:@"%.1f°C",aa];
}

- (void)handle09Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.zdy = [NSString stringWithFormat:@"%@mV",arr[0]];
}

- (void)handle0FData:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.syrl = [NSString stringWithFormat:@"%@mAh",arr[0]];
}

- (void)handle10Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.mdrl = [NSString stringWithFormat:@"%@mAh",arr[0]];
}

- (void)handle17Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.xhcs = [NSString stringWithFormat:@"%@次",arr[0]];
}

- (void)handle0CData:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArraySingle:data];
    self.checkDataModel.soh = [NSString stringWithFormat:@"%@%%",arr[0]];
}

- (void)handle7FData:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArraySingle:data];
    self.checkDataModel.rjbb = [NSString stringWithFormat:@"V%@",arr[1]];
    self.checkDataModel.yjbb = [NSString stringWithFormat:@"V%@",arr[2]];
}

- (void)handle980Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.jtyc = [NSString stringWithFormat:@"%@mV",arr[1]];
}

- (void)handle981Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.cdyc = [NSString stringWithFormat:@"%@mV",arr[1]];

    NSMutableArray *singleArr = [self bleDataToArraySingle:data];
    int dlbl = [singleArr[1] intValue];
    self.checkDataModel.cddlbl = [NSString stringWithFormat:@"%dC",dlbl/10];
}

- (void)handle982Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.fdyc = [NSString stringWithFormat:@"%@mV",arr[1]];

    NSMutableArray *singleArr = [self bleDataToArraySingle:data];
    int dlbl = [singleArr[1] intValue];
    self.checkDataModel.fddlbl = [NSString stringWithFormat:@"%dC",dlbl/10];
}

- (void)handle18Data:(NSData *)data{
    NSMutableArray *arr = [self bleDataToArrayDouble:data];
    self.checkDataModel.sjrl = [NSString stringWithFormat:@"%@mAh",arr[0]];;
}

- (void)handle21Data:(NSData *)data{
    NSMutableArray *array = [self bleDataToArraySingle:data];
    NSMutableString *result = [NSMutableString string];
    for (NSString *str in array) {
        int asciiCode = [str intValue];
        NSString *string =[NSString stringWithFormat:@"%c",asciiCode];
        [result appendString:string];
    }
    self.checkDataModel.dcname = result;
    [self create23Timer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUpFooter];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self faultDiagnosis];
    });
}

#pragma mark ---- 故障诊断 ----
- (void)faultDiagnosis{

    //故障测试
//    self.checkDataModel.soh = @"0.01";

    
    
    

    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"barcode"] = self.batteryInfoModel.bar_code; //电池条码
    setting[@"semiCode"] = self.checkDataModel.bcpCode; //成品条码
    setting[@"finishCode"] = self.checkDataModel.cpCode; //成品条码
    setting[@"month"] = StrFromInt(self.batteryInfoModel.difference); //使用月数
    setting[@"soh"] = self.checkDataModel.soh; //SHO值
    setting[@"deltaSoc"] = self.checkDataModel.soc; //ΔSOC差
    setting[@"chg_mos_err"] = self.checkDataModel.chg_mos_err; //充电MOS 失效
    setting[@"ovpf"] = self.checkDataModel.ovpf; //充电严重过压
    setting[@"ntc_fail"] = self.checkDataModel.ntc_fail; //温度探头损坏
    setting[@"fuse_cut"] = self.checkDataModel.fuse_cut; //保险丝熔断
    setting[@"bad_cell"] = self.checkDataModel.bad_cell; //电芯故障
    setting[@"unbalance"] = self.checkDataModel.unbalance; //电芯不平
    setting[@"minSoc"] = self.checkDataModel.minsoc; //最小电芯SOC
    setting[@"soc"] = self.checkDataModel.xdrlbfb; //相对容量百分比
    setting[@"cycle"] = self.checkDataModel.xhcs; //循环次数
    NSString *str = [self.voltageArray componentsJoinedByString:@","];
    str = [str stringByReplacingOccurrencesOfString:@"mV" withString:@""];
    setting[@"cellVoltages"] = str; //电芯电压数据数组
    setting[@"idleDiff"] = self.checkDataModel.jtyc; //静态压差
    setting[@"dsgDiff"] = self.checkDataModel.fdyc; //放电压差
    setting[@"chgDiff"] = self.checkDataModel.cdyc; //充电压差
    setting[@"dsgDiffRate"] = self.checkDataModel.fddlbl; //放电电流倍率
    setting[@"chgDiffRate"] = self.checkDataModel.cddlbl; //充电电流倍率
    setting[@"fullCap"] = self.checkDataModel.mdrl; //满电容量
    setting[@"designCap"] = self.checkDataModel.sjrl; //设计容量

    [IndexApi DrsInfoWithParams:setting success:^(id obj) {
        FaultDiagnosisPageModel *page = [FaultDiagnosisPageModel parse:obj Elements:[FaultDiagnosisListModel class] forAttribute:@"info"];
        if ([page.code integerValue] == 200) {
            self.diagnosisPageModel = page;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            [self submitData];
        }else{
            [SVProgressHUD showErrorWithStatus:page.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
    
}

#pragma mark ---- 检测数据提交 ----
- (void)submitData{
    //type 1
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"type"] = @"1";
    setting[@"bar_code"] = self.batteryInfoModel.bar_code; //设备条码
    setting[@"sku"] = self.batteryInfoModel.sku; //设备规格
    if (self.diagnosisPageModel.info.count > 0) {
        NSMutableArray *arr1 = [NSMutableArray array];
        NSMutableArray *arr2 = [NSMutableArray array];
        for (FaultDiagnosisListModel *list in self.diagnosisPageModel.info) {
            [arr1 addObject:list.fault_code];
            [arr2 addObject:list.fault_desc];
        }
        setting[@"fault_code"] = [arr1 componentsJoinedByString:@","]; //故障编码(正常数据没有,逗号隔开)
        setting[@"fault_name"] = [arr2 componentsJoinedByString:@","]; //故障名称(正常数据没有,逗号隔开)
    }

    setting[@"warranty_status"] = self.batteryInfoModel.status; //保修状态
    setting[@"discharge_voltage"] = @"0mV"; //加载放电口电压
    setting[@"detector"] = self.bleName; //检测仪ID
    setting[@"load_data"] = @{}; //详细负载检测数据(json)
    setting[@"no_load_data"] = [self getNo_load_dataJson]; //详细空载检测数据（json）
    
    [IndexApi EqpDetectionResultWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.code integerValue] == 200) {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (NSString *)getNo_load_dataJson{
    NSString *jsonStr = @"";
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    for (int i=0; i<self.voltageArray.count; i++) {
        NSString *value = self.voltageArray[i];
        NSString *key = [NSString stringWithFormat:@"电芯%d电压",i+1];
        setting[key] = value;
    }
    
    NSString *wd = self.checkDataModel.wd;
    if ([wd containsString:@"°C"]) {
        wd = [wd stringByReplacingOccurrencesOfString:@"°C" withString:@"度"];
    }
    
    setting[@"温度"] = wd;
    setting[@"最大电压差"] = self.checkDataModel.zddyc;
    setting[@"电芯总电压"] = self.checkDataModel.zdy;
    setting[@"SOH"] = self.checkDataModel.soh;
    setting[@"△SOC值"] = self.checkDataModel.soc;
    setting[@"剩余容量"] = self.checkDataModel.syrl;
    setting[@"循环次数"] = self.checkDataModel.xhcs;
    setting[@"满电容量"] = self.checkDataModel.mdrl;
    setting[@"硬件版本"] = self.checkDataModel.yjbb;
    setting[@"软件版本"] = self.checkDataModel.rjbb;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:setting options:NSJSONWritingPrettyPrinted error:&error];
    if(error == nil) {
        jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
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

- (NSMutableArray *)bleDataToArrayDouble:(NSData *)data{
    NSMutableArray *array = [NSMutableArray array];
    const unsigned char *hexBytesLight = [data bytes];
    int length = 0;
    
    for (int i = 4; i < data.length; i=i+2) {
        NSString *string = [NSString stringWithFormat:@"%02x%02x",hexBytesLight[i+1],hexBytesLight[i]];
        unsigned result = 0;
        [[NSScanner scannerWithString:string] scanHexInt:&result];
        
        if (i == 4) {
            NSString *string = [NSString stringWithFormat:@"%02x",hexBytesLight[i-1]];
            unsigned result2 = 0;
            [[NSScanner scannerWithString:string] scanHexInt:&result2];
            length = result2;
        }
        if (i <= length + 3) {
            [array addObject:[NSString stringWithFormat:@"%d",result]];
        }
    }
    return array;
}


#pragma mark ---- ASCII 转换 ----
- (NSMutableArray *)bleDataToArraySingle:(NSData *)data{
    NSMutableArray *array = [NSMutableArray array];
    const unsigned char *hexBytesLight = [data bytes];
    int length = 0;
    
    for (int i = 4; i < data.length; i++) {
        NSString *string = [NSString stringWithFormat:@"%02x",hexBytesLight[i]];
        unsigned result = 0;
        [[NSScanner scannerWithString:string] scanHexInt:&result];
        
        if (i == 4) {
            NSString *string = [NSString stringWithFormat:@"%02x",hexBytesLight[i-1]];
            unsigned result2 = 0;
            [[NSScanner scannerWithString:string] scanHexInt:&result2];
            length = result2;
        }
        if (i <= length + 3) {
            [array addObject:[NSString stringWithFormat:@"%d",result]];
        }
    }
    return array;
}

- (int) checkPercent :(float) value {
    int percent = 0;
    for(int k = _voltage.count - 1 ; k >= 0 ; k--){
        if(value <= [[_voltage objectAtIndex:k] floatValue]){
            percent = 100 - k ;
            break;
        }else{
            percent = 100;
        }
    }
    return percent;
}

#pragma mark ---- 接口获取电池信息 ----
- (void)getChengPinCode:(NSData *)data{
    
    NSMutableArray *array = [self bleDataToArraySingle:data];
    NSMutableString *result = [NSMutableString string];
    for (NSString *str in array) {
        int asciiCode = [str intValue];
        NSString *string =[NSString stringWithFormat:@"%c",asciiCode];
        [result appendString:string];
    }
    NSString *code = result;
    
    
    NSString *boxCode = @"";
    if (code.length == 20) {
        NSString *s1 = [code substringWithRange:NSMakeRange(11, 1)];
        NSString *s2 = [code substringWithRange:NSMakeRange(12, 1)];
        if ([QWGLOBALMANAGER isPureNum:s1] && [QWGLOBALMANAGER isPureNum:s2]) {
            boxCode = [NSString stringWithFormat:@"%@%@",s1,s2];
        }
    }
    
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"bar_code"] = code;
    [IndexApi EqpInfoWithParams:setting success:^(id obj) {
                
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"info"]];
        dic[@"code"] = obj[@"code"];
        dic[@"message"] = obj[@"message"];
        dic[@"neww_bar_code"] = obj[@"info"][@"new_bar_code"];
        BatteryInfoModel *model = [BatteryInfoModel parse:dic];

        if ([model.code integerValue] == 200) {
            self.boxCode = boxCode;
            self.batteryInfoModel = model;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.batteryInfoModel) {
                    self.titleLabel.text = [NSString stringWithFormat:@"售后检测(%@)",self.batteryInfoModel.V];
                }
                
                if (self.customHeaderView) {
                    [self.customHeaderView configureData:self.batteryInfoModel];
                }
                
                [self checkProcessAction];
                
            });
            
        }else if ([model.code integerValue] == 404){
            [SVProgressHUD showErrorWithStatus:@"电池编码数据有错误。"];
        }else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
    
}


- (void)dealloc{
    [QWGLOBALMANAGER.baby setBlockOnReadValueForCharacteristic:nil];
    [QWGLOBALMANAGER.baby cancelAllPeripheralsConnection];
}


- (void)initVoltageData{
    if ([self.batteryInfoModel.V intValue] < 13) {
        [self initVoltage12Empty];
    }else if ([self.batteryInfoModel.V intValue] == 13){
        [self initVoltage13Empty];
    }else if ([self.batteryInfoModel.V intValue] == 15){
        [self initVoltage15Empty];
    }else{
        [self initVoltage];
    }
}

- (void)openLoadData{
    [_voltage removeAllObjects];
    if ([self.batteryInfoModel.V intValue] < 13) {
        [self initVoltage12Full];
    }else if ([self.batteryInfoModel.V intValue] == 13){
        [self initVoltage13Full];
    }else if ([self.batteryInfoModel.V intValue] == 15){
        [self initVoltage15Full];
    }else{
        [self initVoltage];
    }
}


- (void) initVoltage {
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.200",
                @"4.156",
                @"4.141",
                @"4.129",
                @"4.120",
                @"4.111",
                @"4.103",
                @"4.097",
                @"4.092",
                @"4.087",
                @"4.082",
                @"4.078",
                @"4.073",
                @"4.070",
                @"4.067",
                @"4.063",
                @"4.060",
                @"4.057",
                @"4.054",
                @"4.051",
                @"4.047",
                @"4.044",
                @"4.039",
                @"4.035",
                @"4.032",
                @"4.029",
                @"4.026",
                @"4.023",
                @"4.020",
                @"4.017",
                @"4.013",
                @"4.009",
                @"4.005",
                @"4.000",
                @"3.996",
                @"3.990",
                @"3.985",
                @"3.979",
                @"3.975",
                @"3.970",
                @"3.965",
                @"3.960",
                @"3.956",
                @"3.951",
                @"3.947",
                @"3.942",
                @"3.938",
                @"3.933",
                @"3.929",
                @"3.925",
                @"3.920",
                @"3.916",
                @"3.912",
                @"3.908",
                @"3.904",
                @"3.900",
                @"3.896",
                @"3.891",
                @"3.887",
                @"3.882",
                @"3.878",
                @"3.873",
                @"3.868",
                @"3.863",
                @"3.857",
                @"3.852",
                @"3.846",
                @"3.840",
                @"3.835",
                @"3.828",
                @"3.822",
                @"3.815",
                @"3.808",
                @"3.801",
                @"3.792",
                @"3.781",
                @"3.771",
                @"3.760",
                @"3.749",
                @"3.737",
                @"3.726",
                @"3.713",
                @"3.702",
                @"3.691",
                @"3.681",
                @"3.671",
                @"3.662",
                @"3.654",
                @"3.646",
                @"3.637",
                @"3.625",
                @"3.608",
                @"3.586",
                @"3.556",
                @"3.516",
                @"3.467",
                @"3.408",
                @"3.331",
                @"3.223",
                @"3.027",
                @"2.300",
                nil];
}

- (void) initVoltage12Empty{
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.191",
                @"4.170",
                @"4.153",
                @"4.138",
                @"4.126",
                @"4.116",
                @"4.107",
                @"4.100",
                @"4.093",
                @"4.087",
                @"4.082",
                @"4.077",
                @"4.073",
                @"4.069",
                @"4.066",
                @"4.063",
                @"4.059",
                @"4.057",
                @"4.054",
                @"4.051",
                @"4.049",
                @"4.046",
                @"4.043",
                @"4.040",
                @"4.038",
                @"4.035",
                @"4.032",
                @"4.029",
                @"4.025",
                @"4.020",
                @"4.015",
                @"4.009",
                @"4.002",
                @"3.995",
                @"3.987",
                @"3.978",
                @"3.970",
                @"3.961",
                @"3.954",
                @"3.947",
                @"3.940",
                @"3.934",
                @"3.928",
                @"3.922",
                @"3.917",
                @"3.912",
                @"3.908",
                @"3.904",
                @"3.900",
                @"3.896",
                @"3.892",
                @"3.889",
                @"3.885",
                @"3.882",
                @"3.878",
                @"3.875",
                @"3.872",
                @"3.868",
                @"3.864",
                @"3.860",
                @"3.857",
                @"3.852",
                @"3.848",
                @"3.843",
                @"3.839",
                @"3.833",
                @"3.827",
                @"3.820",
                @"3.812",
                @"3.804",
                @"3.796",
                @"3.786",
                @"3.776",
                @"3.766",
                @"3.755",
                @"3.742",
                @"3.728",
                @"3.712",
                @"3.696",
                @"3.678",
                @"3.661",
                @"3.643",
                @"3.627",
                @"3.611",
                @"3.596",
                @"3.581",
                @"3.568",
                @"3.556",
                @"3.547",
                @"3.538",
                @"3.529",
                @"3.519",
                @"3.505",
                @"3.480",
                @"3.442",
                @"3.396",
                @"3.340",
                @"3.269",
                @"3.172",
                @"3.018",
                @"2.767",
                nil];
}

- (void) initVoltage12Full {
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.183",
                @"4.070",
                @"4.049",
                @"4.034",
                @"4.022",
                @"4.013",
                @"4.003",
                @"3.995",
                @"3.988",
                @"3.982",
                @"3.976",
                @"3.971",
                @"3.966",
                @"3.962",
                @"3.958",
                @"3.954",
                @"3.950",
                @"3.946",
                @"3.942",
                @"3.939",
                @"3.935",
                @"3.932",
                @"3.928",
                @"3.924",
                @"3.920",
                @"3.915",
                @"3.911",
                @"3.907",
                @"3.902",
                @"3.898",
                @"3.893",
                @"3.888",
                @"3.884",
                @"3.879",
                @"3.875",
                @"3.870",
                @"3.865",
                @"3.861",
                @"3.857",
                @"3.852",
                @"3.848",
                @"3.843",
                @"3.838",
                @"3.834",
                @"3.829",
                @"3.823",
                @"3.818",
                @"3.813",
                @"3.809",
                @"3.804",
                @"3.800",
                @"3.796",
                @"3.792",
                @"3.787",
                @"3.783",
                @"3.780",
                @"3.776",
                @"3.772",
                @"3.768",
                @"3.764",
                @"3.759",
                @"3.755",
                @"3.750",
                @"3.746",
                @"3.741",
                @"3.736",
                @"3.731",
                @"3.726",
                @"3.721",
                @"3.716",
                @"3.710",
                @"3.705",
                @"3.698",
                @"3.692",
                @"3.685",
                @"3.678",
                @"3.670",
                @"3.661",
                @"3.652",
                @"3.642",
                @"3.631",
                @"3.620",
                @"3.607",
                @"3.592",
                @"3.576",
                @"3.560",
                @"3.543",
                @"3.527",
                @"3.510",
                @"3.495",
                @"3.480",
                @"3.464",
                @"3.447",
                @"3.426",
                @"3.398",
                @"3.363",
                @"3.326",
                @"3.269",
                @"3.214",
                @"3.132",
                @"2.611",
                nil];
}
- (void) initVoltage13Empty {
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.164",
                @"4.145",
                @"4.129",
                @"4.116",
                @"4.106",
                @"4.097",
                @"4.088",
                @"4.081",
                @"4.075",
                @"4.069",
                @"4.064",
                @"4.060",
                @"4.056",
                @"4.052",
                @"4.048",
                @"4.044",
                @"4.041",
                @"4.037",
                @"4.034",
                @"4.030",
                @"4.026",
                @"4.022",
                @"4.016",
                @"4.010",
                @"4.004",
                @"3.997",
                @"3.991",
                @"3.983",
                @"3.976",
                @"3.969",
                @"3.961",
                @"3.953",
                @"3.944",
                @"3.936",
                @"3.926",
                @"3.917",
                @"3.910",
                @"3.903",
                @"3.896",
                @"3.891",
                @"3.885",
                @"3.880",
                @"3.875",
                @"3.871",
                @"3.866",
                @"3.861",
                @"3.856",
                @"3.852",
                @"3.847",
                @"3.841",
                @"3.836",
                @"3.832",
                @"3.826",
                @"3.820",
                @"3.814",
                @"3.807",
                @"3.799",
                @"3.791",
                @"3.782",
                @"3.771",
                @"3.761",
                @"3.748",
                @"3.735",
                @"3.722",
                @"3.708",
                @"3.694",
                @"3.681",
                @"3.668",
                @"3.655",
                @"3.642",
                @"3.631",
                @"3.621",
                @"3.611",
                @"3.602",
                @"3.594",
                @"3.586",
                @"3.578",
                @"3.570",
                @"3.562",
                @"3.553",
                @"3.545",
                @"3.537",
                @"3.529",
                @"3.519",
                @"3.510",
                @"3.502",
                @"3.495",
                @"3.489",
                @"3.482",
                @"3.475",
                @"3.464",
                @"3.445",
                @"3.413",
                @"3.372",
                @"3.322",
                @"3.261",
                @"3.181",
                @"3.064",
                @"2.841",
                @"2.610",
                @"2.411",
                nil];
}

- (void) initVoltage13Full {
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.153",
                @"4.044",
                @"4.027",
                @"4.013",
                @"4.002",
                @"3.992",
                @"3.984",
                @"3.975",
                @"3.968",
                @"3.962",
                @"3.955",
                @"3.950",
                @"3.944",
                @"3.939",
                @"3.934",
                @"3.929",
                @"3.924",
                @"3.918",
                @"3.913",
                @"3.908",
                @"3.902",
                @"3.897",
                @"3.892",
                @"3.886",
                @"3.881",
                @"3.875",
                @"3.870",
                @"3.865",
                @"3.859",
                @"3.854",
                @"3.849",
                @"3.844",
                @"3.838",
                @"3.834",
                @"3.829",
                @"3.824",
                @"3.819",
                @"3.814",
                @"3.810",
                @"3.805",
                @"3.801",
                @"3.796",
                @"3.791",
                @"3.787",
                @"3.782",
                @"3.778",
                @"3.774",
                @"3.769",
                @"3.765",
                @"3.760",
                @"3.754",
                @"3.750",
                @"3.744",
                @"3.738",
                @"3.732",
                @"3.726",
                @"3.720",
                @"3.713",
                @"3.706",
                @"3.699",
                @"3.691",
                @"3.683",
                @"3.675",
                @"3.665",
                @"3.656",
                @"3.645",
                @"3.635",
                @"3.624",
                @"3.614",
                @"3.603",
                @"3.592",
                @"3.582",
                @"3.571",
                @"3.562",
                @"3.552",
                @"3.543",
                @"3.535",
                @"3.526",
                @"3.518",
                @"3.510",
                @"3.502",
                @"3.495",
                @"3.487",
                @"3.480",
                @"3.472",
                @"3.464",
                @"3.457",
                @"3.449",
                @"3.442",
                @"3.433",
                @"3.424",
                @"3.415",
                @"3.405",
                @"3.392",
                @"3.378",
                @"3.359",
                @"3.336",
                @"3.304",
                @"3.265",
                @"3.207",
                @"3.129",
                nil];
}
- (void) initVoltage15Empty{
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.182",
                @"4.165",
                @"4.150",
                @"4.136",
                @"4.122",
                @"4.110",
                @"4.097",
                @"4.084",
                @"4.072",
                @"4.060",
                @"4.048",
                @"4.037",
                @"4.026",
                @"4.015",
                @"4.004",
                @"3.994",
                @"3.983",
                @"3.973",
                @"3.962",
                @"3.952",
                @"3.942",
                @"3.931",
                @"3.921",
                @"3.912",
                @"3.902",
                @"3.892",
                @"3.883",
                @"3.873",
                @"3.863",
                @"3.854",
                @"3.844",
                @"3.834",
                @"3.824",
                @"3.814",
                @"3.803",
                @"3.792",
                @"3.780",
                @"3.757",
                @"3.748",
                @"3.740",
                @"3.729",
                @"3.721",
                @"3.713",
                @"3.706",
                @"3.699",
                @"3.693",
                @"3.687",
                @"3.682",
                @"3.677",
                @"3.672",
                @"3.667",
                @"3.663",
                @"3.659",
                @"3.656",
                @"3.653",
                @"3.650",
                @"3.646",
                @"3.643",
                @"3.639",
                @"3.636",
                @"3.633",
                @"3.630",
                @"3.627",
                @"3.623",
                @"3.620",
                @"3.616",
                @"3.612",
                @"3.607",
                @"3.601",
                @"3.594",
                @"3.588",
                @"3.582",
                @"3.576",
                @"3.570",
                @"3.564",
                @"3.559",
                @"3.553",
                @"3.548",
                @"3.536",
                @"3.530",
                @"3.523",
                @"3.516",
                @"3.508",
                @"3.501",
                @"3.493",
                @"3.484",
                @"3.475",
                @"3.468",
                @"3.461",
                @"3.455",
                @"3.448",
                @"3.440",
                @"3.430",
                @"3.412",
                @"3.380",
                @"3.340",
                @"3.293",
                @"3.235",
                @"3.161",
                @"3.057",
                @"2.792",
                nil];
}

- (void) initVoltage15Full{
    
    _voltage = [NSMutableArray arrayWithObjects:
                @"4.189",
                @"4.111",
                @"4.094",
                @"4.080",
                @"4.067",
                @"4.053",
                @"4.041",
                @"4.028",
                @"4.016",
                @"4.003",
                @"3.992",
                @"3.980",
                @"3.968",
                @"3.956",
                @"3.943",
                @"3.932",
                @"3.921",
                @"3.909",
                @"3.897",
                @"3.886",
                @"3.875",
                @"3.864",
                @"3.853",
                @"3.842",
                @"3.831",
                @"3.820",
                @"3.809",
                @"3.799",
                @"3.787",
                @"3.777",
                @"3.766",
                @"3.755",
                @"3.745",
                @"3.735",
                @"3.726",
                @"3.716",
                @"3.707",
                @"3.698",
                @"3.688",
                @"3.680",
                @"3.673",
                @"3.665",
                @"3.657",
                @"3.651",
                @"3.644",
                @"3.637",
                @"3.631",
                @"3.625",
                @"3.618",
                @"3.612",
                @"3.606",
                @"3.601",
                @"3.595",
                @"3.591",
                @"3.586",
                @"3.581",
                @"3.576",
                @"3.572",
                @"3.568",
                @"3.563",
                @"3.559",
                @"3.554",
                @"3.551",
                @"3.547",
                @"3.542",
                @"3.538",
                @"3.535",
                @"3.530",
                @"3.526",
                @"3.522",
                @"3.517",
                @"3.513",
                @"3.509",
                @"3.504",
                @"3.499",
                @"3.494",
                @"3.490",
                @"3.484",
                @"3.479",
                @"3.473",
                @"3.468",
                @"3.462",
                @"3.455",
                @"3.449",
                @"3.442",
                @"3.435",
                @"3.428",
                @"3.421",
                @"3.413",
                @"3.405",
                @"3.397",
                @"3.387",
                @"3.376",
                @"3.361",
                @"3.342",
                @"3.316",
                @"3.283",
                @"3.237",
                @"3.171",
                @"3.087",
                @"2.969",
                nil];
}


@end
