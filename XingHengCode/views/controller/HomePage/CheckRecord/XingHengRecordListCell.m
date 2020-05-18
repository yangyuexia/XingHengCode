//
//  XingHengRecordListCell.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengRecordListCell.h"

@implementation XingHengRecordListCell

- (void)setCell:(id)data type:(NSInteger)type{
    
    CheckRecordListModel *model = (CheckRecordListModel *)data;
    
    self.dateLabel.text = [self getDate:model.repair_time];
    
    self.cityLabel.text = model.city;
    
    self.barCodeLabel.text = [NSString stringWithFormat:@"电池条码：%@",model.bar_code];
    
    if (type == 1) {
        self.personLabel.text = [NSString stringWithFormat:@"检验员：%@    故障代码：%@",model.overhaul_clerk,StrIsEmpty(model.param_value)?@"":model.param_value];
    }else{
        self.personLabel.text = [NSString stringWithFormat:@"检验员：%@",model.overhaul_clerk];
    }
    
    
    if ([model.warranty_status containsString:@"超出质保期限"]) {
        self.stateLabel.text = @"过保电池";
        self.stateLabel.textColor = [UIColor redColor];
    }else {
        if ([model.warranty_status containsString:@"时间在15个月以内"]) {
            self.stateLabel.text = @"保修电池\n（15个月内）";
            self.stateLabel.textColor = RGBHex(0x5DEF0E);
        }else if ([model.warranty_status containsString:@"时间超出15个月"]){
            self.stateLabel.text = @"保修电池\n（15个月外）";
            self.stateLabel.textColor = RGBHex(qwColor1);
        }
    }
    

}

- (NSString *)getDate:(NSString *)time{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dd = [formatter1 dateFromString:time];
    
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM月dd日"];
    NSString* dateString = [formatter2 stringFromDate:dd];
    return dateString;
}

@end
