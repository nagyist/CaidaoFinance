//
//  IndexViewController.h
//  Calendar
//
//  Created by LJ on 15/1/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+WQCalendarLogic.h"

@interface CalendarLogic : NSObject

+(CalendarLogic*)sharedLogic;

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;
- (void)selectLogic:(CalendarDayModel *)day;

//获取某年所有月份的数据，分别放入12个数组中
-(NSMutableArray*)calendarMonthsByYear:(NSInteger)year;

@end
