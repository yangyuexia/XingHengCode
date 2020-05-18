//
//  IndexModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/3/24.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "BaseAPIModel.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface IndexModel : BaseAPIModel

@end


@interface SubAccountPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *data;
@end

@interface SubAccountListModel : BaseAPIModel
@property (strong, nonatomic) NSString *id; //": "主键ID",
@property (strong, nonatomic) NSString *username; //": "用户名",
@property (strong, nonatomic) NSString *phone; //": "移动电话",
@property (strong, nonatomic) NSString *email; //": "电子邮箱",
@property (strong, nonatomic) NSString *id_card; //": "身份证号码",
@property (strong, nonatomic) NSString *register_time; //": "注册时间",
@property (strong, nonatomic) NSString *nickname; //": "姓名",
@property (strong, nonatomic) NSString *password; //": "密码",
@property (assign, nonatomic) int sex; //": "性别（1：男；2：女）",
@property (strong, nonatomic) NSString *pic; //": "头像",
@property (assign, nonatomic) int state; //: "状态（0：未启用；1：已启用）"
@end

@interface HomeUIModel : BaseAPIModel
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content1;
@property (strong, nonatomic) NSString *content2;
@end

@interface BlueToothModel : BaseAPIModel
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSString *UUIDString;
@property (strong, nonatomic) NSString *name;
@end

@interface BatteryInfoModel : BaseAPIModel
@property (strong, nonatomic) NSString *id; //": 主键ID,
@property (strong, nonatomic) NSString *client; //": 客户名称,
@property (strong, nonatomic) NSString *sku; //": 电池型号,
@property (strong, nonatomic) NSString *bar_code; //": 电池条码,
@property (strong, nonatomic) NSString *neww_bar_code; //": 更换新的条码,
@property (strong, nonatomic) NSString *ex_factory_date; //": 出厂日期,
@property (assign, nonatomic) NSInteger warranty_num; //": 保修月数,
@property (strong, nonatomic) NSString *status; //":"当前保修状态",
@property (strong, nonatomic) NSString *V; //":"电压",
@property (strong, nonatomic) NSString *A; //":"电容"
@property (strong, nonatomic) NSString *prod_factory_date; //
@property (assign, nonatomic) NSInteger difference;
@end

@interface CheckRecordPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *dateText;
@property (strong, nonatomic) NSString *number;
@end

@interface CheckRecordListModel : BaseAPIModel
@property (strong, nonatomic) NSString *address; // = "\U91d1\U9e21";
@property (strong, nonatomic) NSString *bar_code; //" 设备条码;
@property (strong, nonatomic) NSString *city; // = "\U6c5f\U82cf\U7701\U82cf\U5dde\U5e02";
@property (strong, nonatomic) NSString *ctm_id; //" 人员ID;
@property (strong, nonatomic) NSString *detector; // = "";检测仪ID
@property (strong, nonatomic) NSString *discharge_voltage; //" = "0.0mV"; 加载放电口电压
@property (strong, nonatomic) NSString *id; // = 448815710991560704;
@property (strong, nonatomic) NSString *load_data; //"详细负载检测数据 = "{}";
@property (strong, nonatomic) NSString *neww_bar_code; //新条码" = "";
@property (strong, nonatomic) NSString *overhaul_clerk; //" = "\U8096\U6587\U4f1f";检修员姓名
@property (strong, nonatomic) NSString *phone; // = 18915432481;
@property (strong, nonatomic) NSString *repair_time; //" = "2020-04-18 09:14:29";
@property (strong, nonatomic) NSString *sku; // = "48V 14Ah";设备规格
@property (strong, nonatomic) NSString *warranty_status;
@property (strong, nonatomic) NSString *fault_name;//": "故障名称",
@property (strong, nonatomic) NSString *param_value; //":"故障CODE","
@property (strong, nonatomic) NSString *param_name;//":"故障名称"no_load_data
@property (strong, nonatomic) NSString *no_load_data; //详细空载检测数据" = "{\"SOH\": \"93.0%\", \"\U6e29\U5ea6\": \"21.3\U5ea6\", \"\U25b3SOC\U503c\": \"1.0%\", \"\U5269\U4f59\U5bb9\U91cf\": \"0.0mAh\", \"\U5faa\U73af\U6b21\U6570\": \"127.0\U6b21\", \"\U6ee1\U7535\U5bb9\U91cf\": \"12200.0mAh\", \"\U786c\U4ef6\U7248\U672c\": \"V100\", \"\U8f6f\U4ef6\U7248\U672c\": \"V202\", \"\U7535\U82af1\U7535\U538b\": \"3146.0mV\", \"\U7535\U82af2\U7535\U538b\": \"3136.0mV\", \"\U7535\U82af3\U7535\U538b\": \"3143.0mV\", \"\U7535\U82af4\U7535\U538b\": \"3174.0mV\", \"\U7535\U82af5\U7535\U538b\": \"3123.0mV\", \"\U7535\U82af6\U7535\U538b\": \"3260.0mV\", \"\U7535\U82af7\U7535\U538b\": \"3202.0mV\", \"\U7535\U82af8\U7535\U538b\": \"3253.0mV\", \"\U7535\U82af9\U7535\U538b\": \"3141.0mV\", \"\U7535\U82af10\U7535\U538b\": \"3203.0mV\", \"\U7535\U82af11\U7535\U538b\": \"3261.0mV\", \"\U7535\U82af12\U7535\U538b\": \"3297.0mV\", \"\U7535\U82af13\U7535\U538b\": \"3168.0mV\", \"\U6700\U5927\U7535\U538b\U5dee\": \"174.0mV\", \"\U7535\U82af\U603b\U7535\U538b\": \"41359.0mV\"}";




@end

@interface BatteryCheckDataModel : BaseAPIModel
@property (strong, nonatomic) NSString *bcpCode;
@property (strong, nonatomic) NSString *cpCode;
@property (strong, nonatomic) NSString *ssdl;
@property (strong, nonatomic) NSString *xdrlbfb;
@property (strong, nonatomic) NSString *soc;
@property (strong, nonatomic) NSString *minsoc;
@property (strong, nonatomic) NSString *wd;
@property (strong, nonatomic) NSString *zdy;
@property (strong, nonatomic) NSString *syrl;
@property (strong, nonatomic) NSString *mdrl;
@property (strong, nonatomic) NSString *xhcs;
@property (strong, nonatomic) NSString *zddyc;
@property (strong, nonatomic) NSString *soh;
@property (strong, nonatomic) NSString *rjbb;
@property (strong, nonatomic) NSString *yjbb;
@property (strong, nonatomic) NSString *jtyc;
@property (strong, nonatomic) NSString *cdyc;
@property (strong, nonatomic) NSString *cddlbl;
@property (strong, nonatomic) NSString *fdyc;
@property (strong, nonatomic) NSString *fddlbl;
@property (strong, nonatomic) NSString *sjrl;
@property (strong, nonatomic) NSString *dcname;

@property (strong, nonatomic) NSString *chg_mos_err; //充电MOS 失效
@property (strong, nonatomic) NSString *ovpf; //充电严重过压
@property (strong, nonatomic) NSString *ntc_fail; //温度探头损坏
@property (strong, nonatomic) NSString *fuse_cut; //保险丝熔断
@property (strong, nonatomic) NSString *bad_cell; //电芯故障
@property (strong, nonatomic) NSString *unbalance; //电芯不平

@end

@interface FaultDiagnosisPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *info;
@end

@interface FaultDiagnosisListModel : BaseAPIModel
@property (strong, nonatomic) NSString *fault_desc; //故障描述
@property (assign, nonatomic) NSInteger can_upgrade; //是否允许升级（0：否；1：是）
@property (strong, nonatomic) NSString *fault_code; //故障编码
@end

