//
//  AddressModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/4/8.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface AddressModel : BaseAPIModel

@end

@interface ProvincePageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *provinces;
@end


@interface ProvinceModel : BaseAPIModel
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@end

@interface CityModel : BaseAPIModel
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@end

@interface CountryModel : BaseAPIModel
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSString *countyName;
@end
