//
//  CalendarViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CalendarViewController.h"
#import "JTCalendar.h"
#import "JTCalendarContentView.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"
#import "CalendarDayModel.h"

@interface CalendarViewController ()<JTCalendarDataSource>
{
    NSMutableDictionary *eventsByDate;
    NSArray * lists;

}
@property (nonatomic,strong)JTCalendarContentView *calendarContentView;
@property (nonatomic,strong)JTCalendar *calendar;
@end

@implementation CalendarViewController

- (void)viewDidAppear:(BOOL)animated
{
    [self.calendar reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金日历";
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _bgImg2.image = [_bgImg2.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self creatContentView];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)creatContentView
{
    _calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectZero];
    [_calendarView addSubview:_calendarContentView];
    
    self.calendar = [JTCalendar new];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = _calendar.calendarAppearance.calendar.timeZone;
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
        {
        self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 0.6;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.weekDayTextFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
        self.calendar.calendarAppearance.menuMonthTextFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:7];
        self.calendar.calendarAppearance.dayTextFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
        self.calendar.calendarAppearance.dayBackgroundColor = [UIColor clearColor];
        self.calendar.calendarAppearance.weekDayTextColor = [UIColor clearColor];
        self.calendar.calendarAppearance.dayDotColorOtherMonth = [UIColor clearColor];
        self.calendar.calendarAppearance.dayTextColorOtherMonth = [UIColor clearColor];
        self.calendar.calendarAppearance.dayTextColorSelected = RGBCOLOR(167, 52, 49);
        self.calendar.calendarAppearance.dayTextColorActivity = [UIColor whiteColor];
        self.calendar.calendarAppearance.dayTextColorToday = [UIColor blackColor];
        self.calendar.calendarAppearance.dayDotColor = [UIColor clearColor];
        self.calendar.calendarAppearance.dayCircleColorToday = [UIColor whiteColor];
        self.calendar.calendarAppearance.dayCircleColorSelected = [UIColor whiteColor];
        self.calendar.calendarAppearance.activityDates = _activity;

        self.calendar.calendarAppearance.dayFormat = @"d";
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            NSLog(@"%@",monthText);
            
            return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
        };
    }
    
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
//    [self.calendar setCurrentDate:[NSDate date]];


    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@0);
         make.right.equalTo(@0);
         make.top.equalTo(@0);
         make.bottom.equalTo(@0);
     }];

    [self showText];
    
}

#pragma mark CalendarDelegate
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return YES;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date isActivity:(BOOL)isAct
{
    NSLog(@"%@", date);
    if (isAct) {
        [self showPrice:date];
    }
    else
    {
        [self hidePrice];
    }
}

- (void)showText
{
    NSDateComponents*component = [[NSDateComponents alloc] init];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    component = [gregorian components:unitFlags fromDate:self.calendar.currentDate];
    
    self.left.text = [NSString stringWithFormat:@"%li月",component.month - 1 == 0?12:component.month - 1];
    self.right.text = [NSString stringWithFormat:@"%li月",component.month + 1 == 13?1:component.month + 1];
    self.date.text = [NSString stringWithFormat:@"%li年%li月",component.year,component.month];
}

-(void)calendarDidLoadNextPage
{
    NSLog(@"calendarDidLoadNextPage");
    [self showText];

}

-(void)calendarDidLoadPreviousPage
{
    NSLog(@"calendarDidLoadPreviousPage");
    [self showText];
}

-(void)calendarDidSetCurrentDate:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = calendar.calendarAppearance.calendar.timeZone;
    NSLog(@"%@",date);
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
}

- (void)showPrice:(NSDate*)date
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString*dateStr = [formatter stringFromDate:date];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?BMstRtnDt=%@&UTYPE=T",TEST_NETADDRESS,CALENDARDETAIL,dateStr] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary*dic = [JSON(returnData) objectForKey:@"body"];
            
            [self.benjin countFrom:[[dic objectForKey:@"SUMMSTPRNAMT"] floatValue] to:[[dic objectForKey:@"SUMMSTPRNAMT"] floatValue]];
            [self.lixi countFrom:[[dic objectForKey:@"SUMMSTINTAMT"] floatValue] to:[[dic objectForKey:@"SUMMSTINTAMT"] floatValue]];
            [self.fuwu countFrom:[[dic objectForKey:@"SUMRST_PAY_AMT"] floatValue] to:[[dic objectForKey:@"SUMRST_PAY_AMT"] floatValue]];
            [self.zonge countFrom:[[dic objectForKey:@"AMOUNTMONEY"] floatValue] to:[[dic objectForKey:@"AMOUNTMONEY"] floatValue]];
        }
    }];
    
    _priceView.hidden = NO;
}

- (void)hidePrice
{
    _priceView.hidden = YES;
}


- (IBAction)leftAction:(id)sender {
    [self.calendar loadPreviousPage];
}

- (IBAction)rightAction:(id)sender {
    [self.calendar loadNextPage];
}
@end
