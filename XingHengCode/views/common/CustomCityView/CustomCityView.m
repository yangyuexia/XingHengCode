//
//  CustomCityView.m
//  wenYao-store
//
//  Created by YYX on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CustomCityView.h"
#import "AppDelegate.h"
#import "AddressModel.h"

@implementation CustomCityView
{
    UIWindow *window;
}

+ (CustomCityView *)sharedManager
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"CustomCityView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        self.provinceArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        self.countyArray = [NSMutableArray array];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"hiddenAllCustomView" object:nil];
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        [self loadProvinceAndCityList];

        
    }
    return self;
}


#pragma mark ---- 获取省市列表 ----

- (NSArray *)readLocalFileWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        //DLog(@"JSON解码失败");
        return nil;
    } else {
        return jsonObj;
    }
}

- (void)loadProvinceAndCityList{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self readLocalFileWithName:@"area"]];
    NSMutableDictionary *obj = [NSMutableDictionary dictionary];
    obj[@"provinces"] = array;;
    
    NSMutableArray *keyArr = [NSMutableArray array];
    [keyArr addObject:NSStringFromClass([ProvinceModel class])];
    [keyArr addObject:NSStringFromClass([CityModel class])];
    NSMutableArray *valueArr = [NSMutableArray array];
    [valueArr addObject:@"provinces"];
    [valueArr addObject:@"cities"];
    ProvincePageModel *page = [ProvincePageModel parse:obj ClassArr:keyArr Elements:valueArr];
    
    [self.provinceArray removeAllObjects];
    [self.provinceArray addObjectsFromArray:page.provinces];
    
    if (self.provinceArray.count > 0) {
        ProvinceModel *pmodel = self.provinceArray[0];
        [self.cityArray removeAllObjects];
        [self.cityArray addObjectsFromArray:pmodel.cities];
    }
    
//    if (self.cityArray.count > 0) {
//        CityModel *cmodel = self.cityArray[0];
//        [self.countyArray removeAllObjects];
//        [self.countyArray addObjectsFromArray:cmodel.counties];
//    }
    
    [self.pickerView reloadAllComponents];

}

#pragma mark ---- UIPickerView Delegate ----

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1){
        return self.cityArray.count;
    }else{
        return self.countyArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (self.provinceArray.count > 0) {
            ProvinceModel *model = self.provinceArray[row];
            return model.name;
        }else{
            return @"";
        }
        
    }else if (component == 1){
        if (self.cityArray.count > 0) {
            CityModel *model = self.cityArray[row];
            return model.name;
        }else{
            return @"";
        }
    }else{
        if (self.countyArray.count > 0) {
            CountryModel *model = self.countyArray[row];
            return model.countyName;
        }else{
            return @"";
        }
        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        ProvinceModel *pmodel = self.provinceArray[row];
        [self.cityArray removeAllObjects];
        [self.cityArray addObjectsFromArray:pmodel.cities];
        [self.pickerView reloadComponent:1];

//        CityModel *cmodel = self.cityArray[0];
//        [self.countyArray removeAllObjects];
//        [self.countyArray addObjectsFromArray:cmodel.counties];
//        [self.pickerView reloadComponent:2];


    }else if (component == 1){
//        CityModel *cmodel = self.cityArray[row];
//        [self.countyArray removeAllObjects];
//        [self.countyArray addObjectsFromArray:cmodel.counties];
//        [self.pickerView reloadComponent:2];
    }
}

- (void)dismiss
{
    [self hidden];
}

-(void)show
{
    self.bgView.alpha = 0;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    self.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
    __weak CustomCityView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0.4;
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H - self.bg.frame.size.height, SCREEN_W, self.bg.frame.size.height);
    }];
}

-(void)hidden
{
    __weak CustomCityView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

#pragma mark ---- 确定 ----

- (IBAction)makeSureAction:(id)sender
{
    [self hidden];
    NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger selectedCityIndex = [self.pickerView selectedRowInComponent:1];
    //NSInteger selectedCountyIndex = [self.pickerView selectedRowInComponent:2];
    
    
    ProvinceModel *provinceModel = [ProvinceModel new];
    if (self.provinceArray.count > 0) {
        provinceModel = self.provinceArray[selectedProvinceIndex];
    }
    
    CityModel *cityModel = [CityModel new];
    if (self.cityArray.count > 0) {
        cityModel = self.cityArray[selectedCityIndex];
    }
    
    CountryModel *countyModel = [CountryModel new];
    if (self.countyArray.count > 0) {
        //countyModel = self.countyArray[selectedCountyIndex];
    }
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(getProvinceName:provinceCode:cityName:cityCode:countryName:countryCode:)]) {
        [self.delegate getProvinceName:provinceModel.name provinceCode:provinceModel.id cityName:cityModel.name cityCode:cityModel.id countryName:countyModel.countyName countryCode:countyModel.county];
    }
}

#pragma mark ---- 取消 ----

- (IBAction)cancelAction:(id)sender
{
    [self hidden];
}

@end
