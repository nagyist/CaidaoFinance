//
//  IndexViewController.h
//  Calendar
//
//  Created by LJ on 15/1/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WQCalendarLogic)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天


- (NSDateComponents *)YMDComponents;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSDate *)dateFromStringTypeTwo:(NSString *)dateString;

///年月日格式转换  如：2014年5月1日
- (NSDate *)dateFromStringChinese:(NSString *)dateString;


- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

-(int)getWeekIntValueWithDate;

+(NSDate *)dayInThePreviousTime:(double)seconds withDate:(NSDate*)date; //获取当前时间之前多少秒的日期

///NSdate转NSDateComponents
+(NSDateComponents*)componentsOfDate:(NSDate*)date;

//根据年月获取日期
+(NSDate *)dateByMonthAndYear:(NSInteger)year month:(NSInteger)month;

//获取当前时间 已避免时区问题
+(NSDate*)currentDate;
//获取某月的天数
+(NSInteger)numberOfDaysInMonth:(NSDate*)month;

//计算某个月的第一天是星期几
+(NSUInteger)weeklyOrdinality:(NSDate*)date;

//获取某年的每个月的长度，分别放入12个数组中
-(NSMutableArray*)numberOfDaysInMonthAtYear:(NSInteger)year;

//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;

//根据两个NSDate 获取这时间段内所有的日期
+(NSMutableArray*)getDatesStart:(NSDate*)start end:(NSDate*)end;

-(NSDate*)getFirstDateByYear:(NSInteger)year month:(NSInteger)month;


@end
