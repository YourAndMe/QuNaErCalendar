//
//  WZCMainViewController.m
//  QuNaErCalendar(去哪儿日历)
//
//  Created by wziMAC on 16/10/12.
//  Copyright © 2016年 WZC. All rights reserved.
//

#import "WZCMainViewController.h"
#import "Color.h"
#import "StartAndEndViewController.h"
#import "NoUseDateViewController.h"
#import "MBProgressHUD+XZ.h"
#import "UIViewExt.h"

//宏定义当前物理高度和物理宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface WZCMainViewController ()
{
    
}
@property(nonatomic ,strong) UILabel *noUseLab;
@property(nonatomic ,strong) NSMutableArray *selectArr;//选中的日期
@property(nonatomic ,strong) NSArray *selectNoUseArr;//不可用日期
@property(nonatomic ,strong) UILabel *startDateLab;//开始日期
@property(nonatomic ,strong) UILabel *endDateLab;//结束日期
@property(nonatomic ,strong) UILabel *betweenDayLab;//间隔天数
@end

@implementation WZCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = COLOR_THEME;
    self.navigationItem.title = @"";
    self.selectArr = [NSMutableArray arrayWithCapacity:0];
    [self makeMainView];
}

#pragma mark 主要界面
-(void)makeMainView
{
    UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120*2-65-10)/2.0, 120, 120, 44)];
    startDateLabel.backgroundColor = [UIColor orangeColor];
    startDateLabel.text = @"开始日期";
    startDateLabel.textColor = [UIColor blackColor];
    startDateLabel.font = [UIFont systemFontOfSize:16];
    startDateLabel.textAlignment = NSTextAlignmentCenter;
    startDateLabel.layer.cornerRadius = 5;
    startDateLabel.layer.borderWidth = 0.5;
    startDateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    startDateLabel.layer.masksToBounds = YES;
    [self.view addSubview:startDateLabel];
    self.startDateLab = startDateLabel;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(startDateLabel.right+5, startDateLabel.top+23, 65, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
    
    UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right+5, startDateLabel.top, 120, 44)];
    endDateLabel.backgroundColor = [UIColor orangeColor];
    endDateLabel.text = @"结束日期";
    endDateLabel.textColor = [UIColor blackColor];
    endDateLabel.font = [UIFont systemFontOfSize:16];
    endDateLabel.textAlignment = NSTextAlignmentCenter;
    endDateLabel.layer.cornerRadius = 5;
    endDateLabel.layer.borderWidth = 0.5;
    endDateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    endDateLabel.layer.masksToBounds = YES;
    [self.view addSubview:endDateLabel];
    self.endDateLab = endDateLabel;
    
    UILabel *dayNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.left, lineView.top-21, lineView.width, 21)];
    dayNumLabel.backgroundColor = [UIColor greenColor];
    dayNumLabel.text = @"间隔天数";
    dayNumLabel.textColor = [UIColor blackColor];
    dayNumLabel.font = [UIFont systemFontOfSize:14];
    dayNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dayNumLabel];
    self.betweenDayLab = dayNumLabel;
    
    UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(startDateLabel.left, startDateLabel.top, SCREEN_WIDTH-startDateLabel.left*2, startDateLabel.height)];
    but1.backgroundColor = [UIColor clearColor];
    [but1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    
    UILabel *noUseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startDateLabel.bottom+50, SCREEN_WIDTH-40, 150)];
    noUseDateLabel.backgroundColor = [UIColor cyanColor];
    noUseDateLabel.text = @"不可用日期";
    noUseDateLabel.textColor = [UIColor blackColor];
    noUseDateLabel.font = [UIFont systemFontOfSize:16];
    noUseDateLabel.textAlignment = NSTextAlignmentCenter;
    noUseDateLabel.layer.cornerRadius = 5;
    noUseDateLabel.layer.borderWidth = 0.5;
    noUseDateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    noUseDateLabel.layer.masksToBounds = YES;
    noUseDateLabel.userInteractionEnabled = YES;
    noUseDateLabel.numberOfLines = 0;
    [self.view addSubview:noUseDateLabel];
    self.noUseLab = noUseDateLabel;
    
    UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, noUseDateLabel.width, noUseDateLabel.height)];
    but2.backgroundColor = [UIColor clearColor];
    [but2 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    [noUseDateLabel addSubview:but2];
}

#pragma mark 行程日期选择
-(void)click:(UIButton *)but
{
    
    StartAndEndViewController *chvc = [[StartAndEndViewController alloc]init];
    
    chvc.title = @"日历";
    chvc.day = 365;
    if (self.selectArr.count) {
        chvc.selectDaysArr = [NSMutableArray arrayWithArray:self.selectArr];
        
    }else {
        chvc.selectDaysArr = [NSMutableArray arrayWithCapacity:0];
    }
    __unsafe_unretained WZCMainViewController *temp = self;
    chvc.calendarblock = ^(NSArray *selectDays){
        for (int i=0; i<selectDays.count; i++) {
            WZCCalendarDayModel *model = selectDays[i];
            WZCCalendarDayModel *modelTemp = [[WZCCalendarDayModel alloc] init];
            modelTemp.style = model.style;
            modelTemp.day = model.day;
            modelTemp.month = model.month;
            modelTemp.year = model.year;
            modelTemp.week = model.week;
            modelTemp.Chinese_calendar = model.Chinese_calendar;
            modelTemp.holiday = model.holiday;
            if (self.selectArr.count ==2) {
                [self.selectArr removeAllObjects];
            }
            [self.selectArr addObject:modelTemp];
            if (i==0) {
                temp.startDateLab.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[model toString]]];
            }else{
                temp.endDateLab.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[model toString]]];
            }
        }
        WZCCalendarDayModel *model1 = selectDays[0];
        WZCCalendarDayModel *model2 = selectDays[1];
        NSInteger dayss = [self numberOfDaysWithFromDate:[self changeDateAndYear:model1.year Month:model1.month Days:model1.day] toDate:[self changeDateAndYear:model2.year Month:model2.month Days:model2.day]];
        temp.betweenDayLab.text = [NSString stringWithFormat:@"%d天",dayss+1];
    };
    
    [self.navigationController pushViewController:chvc animated:YES];
    
}

#pragma mark 不可用日期选择
-(void)click1:(UIButton *)but
{
    
    if (self.selectArr.count) {
        NoUseDateViewController *chvc = [[NoUseDateViewController alloc]init];
        
        chvc.title = @"日历";
        chvc.day = 365;
        chvc.selectDaysArr = [NSMutableArray arrayWithArray:self.selectArr];
        if (self.selectNoUseArr.count) {
            chvc.selectDayNoUsesArr = [NSMutableArray arrayWithArray:self.selectNoUseArr];
        }else {
            chvc.selectDayNoUsesArr = [NSMutableArray arrayWithCapacity:0];
        }
        __unsafe_unretained WZCMainViewController *temp = self;
        chvc.calendarblock = ^(NSArray *selectDays){
            self.selectNoUseArr = selectDays;
            temp.noUseLab.text = [NSString stringWithFormat:@"不可用日期\n"];
            for (int i=0; i<selectDays.count; i++) {
                WZCCalendarDayModel *model = selectDays[i];
                
                temp.noUseLab.text = [NSString stringWithFormat:@"%@  %@",temp.noUseLab.text,[NSString stringWithFormat:@"%@",[model toString]]];
            }
        };
        
        [self.navigationController pushViewController:chvc animated:YES];
    }else{
        [MBProgressHUD showText:@"请先选择开始结束日期" withTime:1];
    }
    
    
}

- (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

-(NSDate *)changeDateAndYear:(NSInteger)year Month:(NSInteger)month Days:(NSInteger)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dates = [NSString stringWithFormat:@"%d/%d/%d",year,month,day];
    NSDate *postDate = [dateFormatter dateFromString:dates];
    return postDate;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
