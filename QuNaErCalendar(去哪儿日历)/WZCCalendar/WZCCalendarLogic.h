//
//  WZCCalendarLogic.h
//  QuNaErCalendar(去哪儿日历)
//
//  Created by wziMAC on 16/10/12.
//  Copyright © 2016年 WZC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZCCalendarDayModel.h"
#import "NSDate+WZCCalendarLogic.h"

@interface WZCCalendarLogic : NSObject

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;
- (void)selectLogic:(WZCCalendarDayModel *)day;
@end
