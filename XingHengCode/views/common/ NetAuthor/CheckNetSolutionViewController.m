//
//  CheckNetSolutionViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 2018/6/13.
//  Copyright © 2018年 carret. All rights reserved.
//

#import "CheckNetSolutionViewController.h"

@interface CheckNetSolutionViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CheckNetSolutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"解决方案";
    
    self.textView.editable = NO;
    self.textView.delegate = self;
    
    NSString *str1 = @"1. 检查网络权限是否打开\n\n";
    
    NSString *str2 = @"iOS10系统，需要打开APP使用网络的权限。如果您第一次打开本应用APP弹出下面对话框，请点击“允许”\n\n";
    
    NSString *str3 = @"\n\n如果您未遇到上述对话框，或已经选择了不允许。\n\n解决方法：打开【设置】-【蜂窝移动网络】-【使用无线局域网与蜂窝移动的应用】，找到【本app名称】，勾选【无线局域网与蜂窝移动数据】即可。\n\n如果在【使用无线局域网与蜂窝网移动的应用】中，未找到【本app名称】，请重启手机，打开本app后，再进入【设置】中尝试。\n\n如果您的手机不是中国版，则：打开【设置】-【蜂窝移动网络】，找到【本app名称】，启用开光即可。\n\n\n";
    
    NSString *str4 = @"2. 检查本地网络状况\n\n";
    
    NSString *str5 = @"请查看您本地的无线网络或手机信号情况，信号差的时候也无法正常获取数据。";
    
    
    NSMutableAttributedString *pre1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:fontSystem(kFontS2),NSForegroundColorAttributeName:RGBHex(qwColor1)}];
    
    NSMutableAttributedString *pre2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:fontSystem(kFontS3),NSForegroundColorAttributeName:RGBHex(qwColor2)}];
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"netAuthor"];
    attch.bounds = CGRectMake(10, 0, 270, 226);
    NSAttributedString *imageAtt = [NSAttributedString attributedStringWithAttachment:attch];
    
    NSMutableAttributedString *pre3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:@{NSFontAttributeName:fontSystem(kFontS3),NSForegroundColorAttributeName:RGBHex(qwColor2)}];
    
    NSMutableAttributedString *pre4 = [[NSMutableAttributedString alloc] initWithString:str4 attributes:@{NSFontAttributeName:fontSystem(kFontS2),NSForegroundColorAttributeName:RGBHex(qwColor1)}];
    
    NSMutableAttributedString *pre5 = [[NSMutableAttributedString alloc] initWithString:str5 attributes:@{NSFontAttributeName:fontSystem(kFontS3),NSForegroundColorAttributeName:RGBHex(qwColor2)}];

    
    [pre1 appendAttributedString:pre2];
    [pre1 appendAttributedString:imageAtt];
    [pre1 appendAttributedString:pre3];
    [pre1 appendAttributedString:pre4];
    [pre1 appendAttributedString:pre5];

    self.textView.attributedText = pre1;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
