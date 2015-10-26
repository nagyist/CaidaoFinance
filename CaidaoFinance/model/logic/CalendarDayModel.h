//
//  IndexViewController.h
//  Calendar
//
//  Created by LJ on 15/1/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//


#define CAN_SHOW 1    //可以被点击
#define CANNOT_SHOW 0//不能被点击


#import <Foundation/Foundation.h>
#import "NSDate+WQCalendarLogic.h"



typedef NS_ENUM(NSInteger, CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick,   //被点击的日期
    CellDayTypeRemind,   //有提醒的日期
    CellDayTypeBlank   //空白
    
};

@interface CalendarDayModel : NSObject

@property (assign, nonatomic) CollectionViewCellDayType style;//显示的样式

@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年
@property (nonatomic, assign) NSUInteger week;//周
@property (nonatomic, assign) BOOL discount;//打折
@property (nonatomic, assign) BOOL isRemind;
@property (nonatomic, strong) NSString *Chinese_calendar;//农历
@property (nonatomic, strong) NSString *holiday;//节日

+ (CalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

+(CalendarDayModel*)calendarDayWithDate:(NSDate*)date;

- (NSDate *)date;//返回当前天的NSDate对象
- (NSString *)toString;//返回当前天的NSString对象
- (NSString *)getWeek; //返回星期


//- (BOOL)isEqualTo:(CalendarDayModel *)day;//判断是不是同一天


@end
