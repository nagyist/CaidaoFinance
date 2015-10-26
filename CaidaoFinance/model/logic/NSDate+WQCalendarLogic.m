//
//  IndexViewController.h
//  Calendar
//
//  Created by LJ on 15/1/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "NSDate+WQCalendarLogic.h"

@implementation NSDate (WQCalendarLogic)


/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

+ (NSUInteger)numberOfDaysByMonth:(NSDate*)date
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

+(NSInteger)numberOfDaysInMonth:(NSDate *)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    
    NSInteger count = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:month].length;
    return count;
}

+(NSDate *)dateByMonthAndYear:(NSInteger)year month:(NSInteger)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    dateComponents.year = year;
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/*计算某个月的第一天是礼拜几*/
+(NSUInteger)weeklyOrdinality:(NSDate*)date
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
}

+(NSDate*)currentDate
{
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

//获取某年每个月的天数 以字符串形式放入数组
-(NSMutableArray*)numberOfDaysInMonthAtYear:(NSInteger)year
{
    NSMutableArray*daysCount = [NSMutableArray new];
    for (int i = 1; i <= 12; i++) {
        NSDate*date = [self getFirstDateByYear:year month:i];
        NSInteger count = [NSDate numberOfDaysInMonth:date];
        [daysCount addObject:[NSString stringWithFormat:@"%ld",(long)count]];
    }
    
    return daysCount;
}



//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

+(NSDate *)dayInThePreviousTime:(double)seconds withDate:(NSDate*)date
{
    NSDate*newDate = [date dateByAddingTimeInterval:seconds];
    
    return newDate;
}

/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}



//计算这个月第一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}


- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:
            NSYearCalendarUnit|
            NSMonthCalendarUnit|
            NSDayCalendarUnit|
            NSWeekdayCalendarUnit fromDate:self];
}


//-----------------------------------------
//
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

//NSString转NSDate
- (NSDate *)dateFromStringTypeTwo:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    

    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

-(NSDate*)dateFromStringChinese:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];

    NSCalendar *defaultCalender = [[NSCalendar alloc]
                                   initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *components = [defaultCalender components:unitFlags fromDate:destDate];
    [components setHour:9];
    NSDate *date2 = [defaultCalender dateFromComponents:components];
    return date2;
}

//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

//获取某年某月的第一天
-(NSDate*)getFirstDateByYear:(NSInteger)year month:(NSInteger)month
{
    NSDateComponents*component = [[NSDateComponents alloc] init];
    component.year = year;
    component.month = month;
    component.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:component];
}


+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//日历控件对象
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    NSNumber*days = [NSNumber numberWithInteger:day];
    
    return [days intValue];
}


//周日是“1”，周一是“2”...
-(int)getWeekIntValueWithDate
{
    int weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps= [calendar components:(NSYearCalendarUnit |
                                                   NSMonthCalendarUnit |
                                                   NSDayCalendarUnit |
                                                   NSWeekdayCalendarUnit) fromDate:self];
    
    NSNumber*days = [NSNumber numberWithInteger:[comps weekday]];

    return weekIntValue = [days intValue];
}

+(NSMutableArray*)getDatesStart:(NSDate *)start end:(NSDate *)end
{
    NSMutableArray * dates = [NSMutableArray new];
    NSCalendar *defaultCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * startCom = [start YMDComponents];
    NSDateComponents * endCom = [end YMDComponents];
    NSInteger startYear = startCom.year;
    NSInteger startMonth = startCom.month;
    NSInteger startDay = startCom.day;
    NSInteger endYear = endCom.year;
    
    //如果不是在同一年的情况下
    if (startYear < endYear) {
       NSDate * lastDate = [NSDate getLastDayInThisYear:startYear];
        NSTimeInterval secondsBetweenDates= [lastDate timeIntervalSinceDate:start];
        NSUInteger spDays = secondsBetweenDates/3600/24;
        for (int i = 0; i <= spDays; i++) {
            NSDateComponents * com = [[NSDateComponents alloc] init];
            com.year = startYear;
            com.month = startMonth;
            com.day = startDay + i;
            [dates addObject:[defaultCalender dateFromComponents:com]];
        }
    }
    else if (startYear == endYear)
    {
        NSTimeInterval secondsBetweenDates= [end timeIntervalSinceDate:start];
        NSUInteger spDays = secondsBetweenDates/3600/24;
        for (int i = 0; i <= spDays; i++) {
            NSDateComponents * com = [[NSDateComponents alloc] init];
            com.year = startYear;
            com.month = startMonth;
            com.day = startDay + i;
            [dates addObject:[defaultCalender dateFromComponents:com]];
        }
    }
    return dates;
}

//获取今年最后一天
+(NSDate*)getLastDayInThisYear:(NSInteger)year
{
    NSCalendar *defaultCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * com = [[NSDateComponents alloc] init];
    com.year = year+1;
    com.month = 1;
    com.day = 0;
    NSDate * date = [defaultCalender dateFromComponents:com];
    return date;
}

+(NSDateComponents*)componentsOfDate:(NSDate*)date
{
    NSCalendar *defaultCalender = [[NSCalendar alloc]
                                   initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps_today= [defaultCalender components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSWeekdayCalendarUnit) fromDate:date];
    return comps_today;
}

//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate:(NSDate*)date
{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps_today= [calendar components:(NSYearCalendarUnit |
                                                   NSMonthCalendarUnit |
                                                   NSDayCalendarUnit |
                                                   NSWeekdayCalendarUnit) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSWeekdayCalendarUnit) fromDate:date];
    
    
    //获取星期对应的数字
    int weekIntValue = [self getWeekIntValueWithDate];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -1){
        return @"明天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -2){
        return @"后天";
        
    }else{
        //直接返回当时日期的字符串(这里让它返回空)
        return [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }
}



//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week
{
    NSString *str_week;
    
    switch (week) {
        case 1:
            str_week = @"周日";
            break;
        case 2:
            str_week = @"周一";
            break;
        case 3:
            str_week = @"周二";
            break;
        case 4:
            str_week = @"周三";
            break;
        case 5:
            str_week = @"周四";
            break;
        case 6:
            str_week = @"周五";
            break;
        case 7:
            str_week = @"周六";
            break;
    }
    return str_week;
}


@end
