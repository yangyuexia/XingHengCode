//
//  XingHengCheckResultCell.m
//  XingHengCode
//
//  Created by Yang Yuexia on 2020/4/19.
//  Copyright © 2020年 Young. All rights reserved.
//

#import "XingHengCheckResultCell.h"
#import "CheckResultView.h"

@implementation XingHengCheckResultCell

+ (CGFloat)getCellHeight:(id)data{
    FaultDiagnosisPageModel *page = (FaultDiagnosisPageModel *)data;
    if (page.info.count == 0) {
        return 130+30;
    }else{
        if ([QWGLOBALMANAGER.powerInfoModel.check containsObject:@"2002"]) {
            return 270-35+page.info.count*20;
        }else{
            return 270-35+page.info.count*20-60;
        }
    }
}

- (void)UIGlobal{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.separatorLine.hidden = YES;
    
    self.applyBtn.layer.cornerRadius = 23;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.borderColor = RGBHex(0xB6B6B9).CGColor;
    self.applyBtn.layer.borderWidth = 1.0;
    self.applyBtn.backgroundColor = [UIColor clearColor];
    
    UIImage *norImage = [UIImage imageNamed:@"img-query-result-bg"];
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, h, w) resizingMode:UIImageResizingModeStretch];
    self.shadowImage.image = newImage;
    
}

- (void)setCell:(id)data{
    [super setCell:data];
    FaultDiagnosisPageModel *page = (FaultDiagnosisPageModel *)data;
    if (page.info.count == 0) {
        self.resultLabel.text = @"检测正常";
        self.resultLabel.textColor = RGBHex(0x7ED321);
        self.descLabel.text = @"经检测电池各项功能指标均正常，请放心使用";
        self.desc_layout_height.constant = 20;
        self.applyBtn.hidden = self.containerView.hidden = YES;
        
    }else{
        self.resultLabel.text = @"存在故障";
        self.resultLabel.textColor = RGBHex(0xF8415B);
        self.descLabel.text = @"经检测发现电池存在故障，需要进行售后处理";
        self.desc_layout_height.constant = 20;
        self.applyBtn.hidden = self.containerView.hidden = NO;
        
        if ([QWGLOBALMANAGER.powerInfoModel.check containsObject:@"2002"]) {
            self.applyBtn.hidden = NO;
        }else{
            self.applyBtn.hidden = YES;
        }
        
        //故障列表
        [self setUpFault:page.info];
    }
    
}

- (void)setUpFault:(NSArray *)faultList{
    for (UIView * subview in [self.containerView subviews]) {
        if([subview isKindOfClass:[CheckResultView class]]){
            [subview removeFromSuperview];
        }
    }
    
    for(int i=0; i<faultList.count; i++) {
        int totalColumns = 1;
        CGFloat cellW = APP_W-70;
        CGFloat cellH = 20;
        
        int row = i / totalColumns;
        
        CGFloat cellX = 0;
        CGFloat cellY = row * cellH;
        
        CheckResultView *view = [[CheckResultView alloc] initWithFrame:CGRectMake(cellX, cellY, cellW, cellH)];
        [self.containerView addSubview:view];
        
        FaultDiagnosisListModel *model = faultList[i];
        view.codeLabel.text = model.fault_code;
        view.descLabel.text = model.fault_desc;
    }
}

- (IBAction)applyAction:(id)sender {
    if (self.xingHengCheckResultCellDelegate && [self.xingHengCheckResultCellDelegate respondsToSelector:@selector(applyAction)]) {
        [self.xingHengCheckResultCellDelegate applyAction];
    }
}

@end
