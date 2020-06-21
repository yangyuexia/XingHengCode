//
//  XingHengWarrantyQueryViewController.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/18.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengWarrantyQueryViewController.h"
#import "NSDate+Category.h"
#import "XingHengScanQueryViewController.h"
#import "XingHengBindBatteryViewController.h"

@interface XingHengWarrantyQueryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@property (weak, nonatomic) IBOutlet UIView *queryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *query_layout_height;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImage;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;


@property (weak, nonatomic) IBOutlet UILabel *userdDurationLabel;

@property (weak, nonatomic) IBOutlet UILabel *outTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *state_layout_height;


- (IBAction)makeAction:(id)sender;
- (IBAction)scanAction:(id)sender;
- (IBAction)applyAction:(id)sender;


@end

@implementation XingHengWarrantyQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"保修期查询";
    self.queryView.hidden = YES;
    
    if (self.fromHomePage) {
        self.tipLabel.text = @"电池产品编码：";
        self.textField.enabled = YES;
        self.scanBtn.hidden = NO;
        self.query_layout_height.constant = 250;
        self.applyBtn.hidden = YES;
        
    }else{
        self.tipLabel.text = @"故障电池产品编码：";
        self.textField.text = self.batteryInfoModel.bar_code;
        self.textField.enabled = NO;
        self.scanBtn.hidden = YES;
        self.query_layout_height.constant = 320;
        self.applyBtn.hidden = NO;
    }
    
    self.textField.delegate = self;
    self.textBg.layer.cornerRadius = 8.0;
    self.textBg.layer.masksToBounds = YES;
    self.textBg.layer.borderColor = RGBHex(0xE6E6EB).CGColor;
    self.textBg.layer.borderWidth = 1.0;
    self.makeBtn.layer.cornerRadius = 8;
    self.makeBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 23;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.borderColor = RGBHex(0xB6B6B9).CGColor;
    self.applyBtn.layer.borderWidth = 1.0;
    
    UIImage *norImage = [UIImage imageNamed:@"img-query-result-bg"];
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, h, w) resizingMode:UIImageResizingModeStretch];
    self.shadowImage.image = newImage;
    
    if (!StrIsEmpty(self.batteryInfoModel.bar_code)) {
        [self makeAction:nil];
    }
    
}

#pragma mark ---- 扫码 ----
- (IBAction)scanAction:(id)sender {
    XingHengScanQueryViewController *vc = [[UIStoryboard storyboardWithName:@"WarrantyQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengScanQueryViewController"];
    vc.scanBlock = ^(NSString *barCode) {
        self.textField.text = barCode;
        [self makeAction:nil];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 查询 ----
- (IBAction)makeAction:(id)sender {
    if (StrIsEmpty(self.textField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入电池编码"];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"bar_code"] = self.textField.text;
    [IndexApi EqpInfoWithParams:setting success:^(id obj) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj[@"info"]];
        dic[@"code"] = obj[@"code"];
        dic[@"message"] = obj[@"message"];
        dic[@"neww_bar_code"] = obj[@"info"][@"new_bar_code"];
        BatteryInfoModel *model = [BatteryInfoModel parse:dic];
        
        if ([model.code integerValue] == 200) {
            
            self.queryView.hidden = NO;
            
            
            self.userdDurationLabel.text = [self aaaaaaaaa:model.ex_factory_date];
            
            self.outTimeLabel.text = [self getOutFactoryDate:model.ex_factory_date];
            
            self.guaranteeLabel.text = [self getguaranteeDate:model.ex_factory_date withMonth:model.warranty_num];
            
            self.stateLabel.text = model.status;
            CGSize size = [QWGLOBALMANAGER sizeText:model.status font:fontSystem(15) limitWidth:APP_W-133];
            self.state_layout_height.constant = size.height+4;
            
            
        }else if ([model.code integerValue] == 404){
            [SVProgressHUD showErrorWithStatus:@"电池编码数据有错误。"];
        }else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
    }];
    
    
}

- (NSString *)aaaaaaaaa:(NSString *)outStr{
    NSString *str = [self getOutFactoryDate:outStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *fromDate = [formatter dateFromString:str];
    NSDate *toDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *complnents = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
   
    NSString *year = @"";
    NSString *month = @"";
    NSString *day = @"";
    
    if (complnents.year > 0) {
        year = [NSString stringWithFormat:@"%ld年",complnents.year];
    }
    if (complnents.month > 0) {
        month = [NSString stringWithFormat:@"%ld个月",complnents.month];
    }
    if (complnents.day > 0) {
        day = [NSString stringWithFormat:@"%ld天",complnents.day];
    }
    
    NSString *strTime = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    return strTime;
    
}


- (NSString *)getOutFactoryDate:(NSString *)date{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *dd = [formatter1 dateFromString:date];
    
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
    formatter2.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter2 setDateStyle:NSDateFormatterMediumStyle];
    [formatter2 setTimeStyle:NSDateFormatterShortStyle];
    [formatter2 setDateFormat:@"yyyy年MM月dd日"];
    NSString* dateString = [formatter2 stringFromDate:dd];
    return dateString;
}

-(NSString *)getguaranteeDate:(NSString *)outStr withMonth:(NSInteger)month{
    NSString *str = [self getOutFactoryDate:outStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:str];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return [formatter stringFromDate:mDate];
}


#pragma mark ---- 申请售后 ----
- (IBAction)applyAction:(id)sender {
    //type 0
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"type"] = @"0";
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
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"厂家授权售后服务" message:self.batteryInfoModel.status preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                XingHengBindBatteryViewController *vc = [[UIStoryboard storyboardWithName:@"WarrantyQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"XingHengBindBatteryViewController"];
                vc.oldBarCode = self.batteryInfoModel.bar_code;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }];
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:model.message];
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
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:setting options:NSJSONWritingPrettyPrinted error:nil];
    jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
