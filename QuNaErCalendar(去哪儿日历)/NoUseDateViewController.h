//
//  NoUseDateViewController.h
//  QuNaErCalendar(去哪儿日历)
//
//  Created by wziMAC on 16/10/12.
//  Copyright © 2016年 WZC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZCCalendarLogic.h"

//回掉代码块
typedef void (^CalendarBlock)(NSArray *selectDays);

@interface NoUseDateViewController : UIViewController

@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图

@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组

@property(nonatomic ,strong) WZCCalendarLogic *Logic;

@property (nonatomic, copy) CalendarBlock calendarblock;//回调
@property (nonatomic, assign) NSInteger day;//回调
@property(nonatomic ,strong) NSMutableArray *selectDaysArr;//选中的日期
@property(nonatomic ,strong) NSMutableArray *selectDayNoUsesArr;//不可用日期
@end