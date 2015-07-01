//
//  CalendarDatePickerView.m
//  Calendar
//
//  Created by LJ on 15/2/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CalendarDatePickerView.h"
#import "GZDatePickView.h"

@implementation CalendarDatePickerView
{
    GZDatePickView * pickerView;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [_datePicker setDate:_currnetDate animated:YES];
    
}

-(void)initUI
{
    self.backgroundColor = RGBCOLOR(58, 58, 78);
    [self drawLine];
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:18];
    [self addSubview:_dateLabel];
    
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setFrame:CGRectMake(self.frame.size.width - 65,10 , 50, 20)];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitle:@"确定" forState:UIControlStateHighlighted];
    [_sureButton setTitle:@"确定" forState:UIControlStateSelected];
    [_sureButton setTitleColor:RGBCOLOR(131, 131, 138) forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureButton];
    
    pickerView = [[GZDatePickView alloc] initWithFrame:CGRectMake(0, 40, GZContent_Width, 200)];
    pickerView.delegate = self;
    [self addSubview:pickerView];
    
}


#pragma mark GZDatePickerViewDelegate
-(void)datePickerView:(GZDatePickView *)pickerView didSelectedRow:(NSInteger)row inComponent:(NSInteger)component date:(NSDate *)date
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年 MM月dd日"];
    if (date) {
        _currnetDate = date;
        _dateLabel.text = [formatter stringFromDate:date];
        if ([_delegate respondsToSelector:@selector(calendarDatePickerView:didChangeDate:)]) {
            [_delegate calendarDatePickerView:self didChangeDate:_currnetDate];
        }
    }
}

-(void)drawLine
{
    
}


#pragma mark  SET

-(void)setCurrnetDate:(NSDate *)currnetDate
{
    _currnetDate = currnetDate;
    
}

#pragma mark ACTION

-(void)sureAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(calendarDatePickerView:didSelectedDate:)]) {
        [_delegate calendarDatePickerView:self didSelectedDate:_currnetDate];
    }
}

-(void)datePickerValueChanged:(id)sender
{
    NSDate*date = [sender date];
    _currnetDate = date;
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年 MM月dd日"];
    _dateLabel.text = [formatter stringFromDate:date];
    if ([_delegate respondsToSelector:@selector(calendarDatePickerView:didChangeDate:)]) {
        [_delegate calendarDatePickerView:self didChangeDate:date];
    }
}
@end
