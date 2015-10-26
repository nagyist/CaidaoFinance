//
//  GZDatePickView.m
//  Maintainer
//
//  Created by RebornAce on 15/2/11.
//  Copyright (c) 2015年 RebornAce. All rights reserved.
//

#import "GZDatePickView.h"

@implementation GZDatePickView


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if (self) {
        _dateType=allType;
        
        //初始化生日选择界面pickView
        monthArray = @[@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月"];
        dayArray =@[@"01日",@"02日",@"03日",@"04日",@"05日",@"06日",@"07日",@"08日",@"09日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"];
        
        
        startDate=[NSDate date];
        calendar=[NSCalendar currentCalendar];
        unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startDate];
        
        _year = [dateComponents year];
        _month = [dateComponents month];
        _day = [dateComponents day];
        _selectMonth = _month;
        _selectDay = _day;
        
        _pickView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickView.dataSource=self;
        _pickView.delegate=self;
        [self addSubview:_pickView];
        
        [_pickView selectRow:_year-1 inComponent:0 animated:NO];
        [_pickView selectRow:(_month-1)+12*500 inComponent:1 animated:NO];
        [_pickView selectRow:(_day-1)+31*200 inComponent:2 animated:NO];
        
        
        _noDateColor=[UIColor darkGrayColor];
        _dateColor=[UIColor darkGrayColor];
        _dateFont=[UIFont systemFontOfSize:16.0];
    }
    
    return self;
}

#pragma mark 生日列表初始化
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        dateLabel.font=_dateFont;
        dateLabel.textColor=_dateColor;
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (component) {
        case 0: {
            NSString *currentYear = [NSString stringWithFormat:@"%i年",(int)row+1];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 1: {
            [dateLabel setText:[monthArray objectAtIndex:row%12]];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            
            NSRange dayRang=[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:startDate];
            
            if (row%31>(dayRang.length-1)) {
                dateLabel.textColor=_noDateColor;
            }
            [dateLabel setText:[dayArray objectAtIndex:row%31]];
            dateLabel.textAlignment = NSTextAlignmentLeft;
            break;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (_dateType == afterType) {
        switch (component) {
            case 0: {
                if (row+1>_year) {
                    [pickerView selectRow:_year-1 inComponent:0 animated:YES];
                }
                break;
            }
            case 1: {
                UILabel *monthLabel=(UILabel *)[pickerView viewForRow:row forComponent:1];
                NSString *monthString=monthLabel.text;
                monthString=[monthString substringWithRange:NSMakeRange(0, monthString.length-1)];
                _selectMonth=[monthString integerValue];
                
                if ([pickerView selectedRowInComponent:0]+1>=_year && _selectMonth>_month) {
                    [pickerView selectRow:(_month-1)+500*12 inComponent:1 animated:YES];
                }
                
                break;
            }
            case 2: {
                UILabel *dayLabel=(UILabel *)[pickerView viewForRow:row forComponent:2];
                NSString *dayString=dayLabel.text;
                dayString=[dayString substringWithRange:NSMakeRange(0, dayString.length-1)];
                _selectDay=[dayString integerValue];
                
                if ([pickerView selectedRowInComponent:0]+1>=_year && [pickerView selectedRowInComponent:1]+1>=_month &&_selectDay>_day) {
                    [pickerView selectRow:(_day-1)+200*31 inComponent:2 animated:YES];
                }
                
                break;
            }
            default:
                break;
        }
    }
    else if (_dateType ==nextType){
        
        switch (component) {
            case 0: {
                
                if (row+1<=_year) {
                    [pickerView selectRow:_year-1 inComponent:0 animated:YES];
                }
                
                break;
            }
            case 1: {
                
                UILabel *monthLabel=(UILabel *)[pickerView viewForRow:row forComponent:1];
                NSString *monthString=monthLabel.text;
                monthString=[monthString substringWithRange:NSMakeRange(0, monthString.length-1)];
                _selectMonth=[monthString integerValue];
                
                if ([pickerView selectedRowInComponent:0]+1<=_year && _selectMonth<_month) {
                    [pickerView selectRow:(_month-1)+500*12 inComponent:1 animated:YES];
                    _selectMonth=_month;
                }
            
                break;
            }
            case 2: {
                UILabel *dayLabel=(UILabel *)[pickerView viewForRow:row forComponent:2];
                NSString *dayString=dayLabel.text;
                dayString=[dayString substringWithRange:NSMakeRange(0, dayString.length-1)];
                _selectDay=[dayString integerValue];
                
                if ([pickerView selectedRowInComponent:0]+1<=_year && ([pickerView selectedRowInComponent:1]+1)%12<=_month &&_selectDay<_day) {
                    [pickerView selectRow:(_day-1)+200*31 inComponent:2 animated:YES];
                        _selectDay=_day;
                }
                
                break;
            }
            default:
                break;
        }
        

    }
    else{
        switch (component) {
            case 0: {
                UILabel *monthLabel=(UILabel *)[pickerView viewForRow:row forComponent:0];
                NSString *monthString=monthLabel.text;
                _year = [[monthString substringWithRange:NSMakeRange(0, monthString.length-1)] integerValue];
                [pickerView selectRow:row inComponent:0 animated:YES];
                break;
            }
            case 1: {
                
                UILabel *monthLabel=(UILabel *)[pickerView viewForRow:row forComponent:1];
                NSString *monthString=monthLabel.text;
                monthString=[monthString substringWithRange:NSMakeRange(0, monthString.length-1)];
                _selectMonth=[monthString integerValue];
                
                break;
            }
            case 2: {
                UILabel *dayLabel=(UILabel *)[pickerView viewForRow:row forComponent:2];
                NSString *dayString=dayLabel.text;
                dayString=[dayString substringWithRange:NSMakeRange(0, dayString.length-1)];
                _selectDay=[dayString integerValue];
                
                break;
            }
            default:
                break;
        }
    }
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:_selectDay];
    [components setMonth:_selectMonth];
    [components setYear:_year];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:components];
    NSLog(@"%@",date);
    if ([_delegate respondsToSelector:@selector(datePickerView:didSelectedRow:inComponent:date:)]) {
        [_delegate datePickerView:self didSelectedRow:row inComponent:component date:date];
    }
    [pickerView reloadAllComponents];

}

@end
