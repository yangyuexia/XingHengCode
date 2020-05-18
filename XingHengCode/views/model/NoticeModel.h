//
//  NoticeModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 2017/4/11.
//  Copyright © 2017年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface NoticeModel : BaseAPIModel

@end

@interface NoticePageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *item;
@end

@interface NoticeListModel : BaseAPIModel
@property (strong, nonatomic) NSString *Content;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *CreateTime;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *Link;
@property (assign, nonatomic) BOOL unread;

@end
