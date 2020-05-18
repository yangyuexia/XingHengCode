//
//  ReturnIndexView.m
//  wenyao
//
//  Created by qwfy0006 on 15/3/2.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "ReturnIndexView.h"
#import "AccountModel.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "ReturnIndexCell.h"

#define  BOUNDS [[UIScreen mainScreen] bounds]

@interface ReturnIndexView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, weak) UIView *headerView;

@end

@implementation ReturnIndexView

+ (ReturnIndexView *)sharedManagerTitle:(NSArray *)titles isHidden:(BOOL)isHidden frame:(CGRect)frame{
    return [[self alloc] initWithTitle:titles isHidden:isHidden frame:frame];
}


- (id)initWithTitle:(NSArray *)titles isHidden:(BOOL)isHidden frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        NSArray *arrayyy = [[NSBundle mainBundle ] loadNibNamed:@"ReturnIndexView" owner:self options:nil];
        self = arrayyy[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-44-STATUS_H);
        self.backgroundColor = [UIColor clearColor];
        
        self.titleArray = (NSMutableArray *)[NSArray arrayWithArray:titles];
        [self setUpTableView:frame];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.bgView addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:@"hiddenAllCustomView" object:nil];
        
    }
    return self;
}

- (void)tapAction{
    [self hide];
}

- (void)setUpTableView:(CGRect)frame
{
    CGFloat x = 24;
    CGFloat y = frame.origin.y + frame.size.height-5;
    CGFloat width = APP_W-24-80;
    CGFloat height = 35*self.titleArray.count;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.borderColor = RGBHex(qwColor12).CGColor;
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.shadowColor = RGBAHex(0xffffff, 0.3).CGColor;
    self.tableView.layer.shadowOffset = CGSizeMake(6, 6);
    self.tableView.layer.shadowOpacity = 1;
    self.tableView.clipsToBounds = false;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    [self.tableView reloadData];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ReturnIndexCellIdentifier = @"ReturnIndexCell";
    ReturnIndexCell *cell = (ReturnIndexCell *)[tableView dequeueReusableCellWithIdentifier:ReturnIndexCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"ReturnIndexCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ReturnIndexCellIdentifier];
        cell = (ReturnIndexCell *)[tableView dequeueReusableCellWithIdentifier:ReturnIndexCellIdentifier];
        
    }
    if (indexPath.row == 0) {
        cell.sepLine.hidden = YES;
    }else{
        cell.sepLine.hidden = NO;
    }
    
    
    RemAccountModel *model = self.titleArray[indexPath.row];
    cell.titleLabel.text = model.userName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
    
    if ([self.returnIndexViewDelegate respondsToSelector:@selector(RetunIndexView:didSelectedIndex:)]) {
        [self.returnIndexViewDelegate RetunIndexView:self didSelectedIndex:indexPath];
        [self hide];
    }
}



- (void)dismissSelf
{
    [self hide];
}

- (void)show
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.frame = CGRectMake(0, 0, BOUNDS.size.width, BOUNDS.size.height);
    [UIView animateWithDuration:0.8 animations:^{
        [app.window addSubview:self];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)hide
{
    [UIView animateWithDuration:0.8 animations:^{
        self.returnIndexViewDelegate = nil;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }];
}


@end
