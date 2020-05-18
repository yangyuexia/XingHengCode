//
//  QWBaseCell.m
//  RepeatCode
//
//  Created by Yang Yuexia on 2018/6/27.
//  Copyright © 2018年 Yang Yuexia. All rights reserved.
//

#import "QWBaseCell.h"

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}


@implementation QWBaseCell

+ (CGFloat)getCellHeight:(id)obj{
    return 40;
}

- (void)setCell:(id)data{
    
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setHighlighted:NO animated:NO];
    [self UIGlobal];
}

-  (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

#pragma mark - 全局UI
- (void)UIGlobal{
    CGRect frm=self.bounds;
    if (_separatorLine==nil) {
        _separatorLine=[[UIView alloc]init];
    }
    
    frm.origin.y=CGRectGetHeight(self.bounds)-0.5f;
    frm.size.height=.5f;
    _separatorLine.frame=frm;
    
    [self.contentView addSubview:_separatorLine];
    [self.contentView bringSubviewToFront:_separatorLine];
    _separatorLine.hidden=self.separatorHidden;
    
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSeparatorMargin:(CGFloat)margin edge:(Enum_Edge)edge{
    [GLOBALMANAGER setObject:_separatorLine margin:margin edge:edge];
}

@end
