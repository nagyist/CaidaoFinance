//
//  GZDatePickView.h
//  Maintainer
//
//  Created by RebornAce on 15/2/11.
//  Copyright (c) 2015年 RebornAce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GZDatePickerViewDelegate;

enum datePickerViewType{
    
    allType = 0,
    afterType = 1,
    nextType = 2
    
};


@interface GZDatePickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSCalendar *calendar;
    NSDate *startDate;
    
    NSArray *monthArray;
    NSArray *dayArray;
    NSCalendarUnit unitFlags;
  
}

@property (assign, nonatomic) NSInteger dateType;

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;

@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) UIColor *dateColor;
@property (strong, nonatomic) UIColor *noDateColor;

@property (strong, nonatomic) UIFont *dateFont;

@property (assign, nonatomic) NSInteger selectMonth;
@property (assign, nonatomic) NSInteger selectDay;

@property (nonatomic,strong) id<GZDatePickerViewDelegate>delegate;

//@property (assign, nonatomic) BOOL isBrithday;
@end

@protocol GZDatePickerViewDelegate <NSObject>

-(void)datePickerView:(GZDatePickView*)pickerView didSelectedRow:(NSInteger)row inComponent:(NSInteger)component date:(NSDate*)date;

@end
