//
//  CalendarDatePickerView.h
//  Calendar
//
//  Created by LJ on 15/2/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSDate+WQCalendarLogic.h"
#import "GZDatePickView.h"

@protocol CalendarDatePickerDelegate;


@interface CalendarDatePickerView : UIView<GZDatePickerViewDelegate>

@property (nonatomic,strong) UIDatePicker * datePicker;

@property (nonatomic,strong) NSDate * currnetDate;

@property (nonatomic,retain) UILabel * dateLabel;

@property (nonatomic,retain) UIButton * sureButton;

@property (nonatomic,strong) id<CalendarDatePickerDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;


#pragma mark dateLabelProperty
@property (nonatomic,strong) UIColor * dateColor;
@property (nonatomic,strong) UIFont * dateFont;

#pragma mark sureButtonProperty
@property (nonatomic,strong)UIImage * sureButtonImageNormal;
@property (nonatomic,strong)UIImage * sureButtonImageHighlighted;


@end

@protocol CalendarDatePickerDelegate <NSObject>

-(void)calendarDatePickerView:(CalendarDatePickerView*)pickerView didSelectedDate:(NSDate*)date;

-(void)calendarDatePickerView:(CalendarDatePickerView *)pickerView didChangeDate:(NSDate*)date;

@end