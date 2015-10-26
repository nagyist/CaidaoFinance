//
//  AccountInfoViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "CalendarViewController.h"
#import <PNChart.h>
#import "GZNetConnectManager.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "CalendarDayModel.h"

@interface AccountInfoViewController ()
{
    NSMutableArray * days;
    NSMutableArray * earns;
    NSArray * lists;
    NSMutableDictionary *  activity;
}

@end

@implementation AccountInfoViewController

- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, 510)];
}

- (id)initWithPersonData:(NSDictionary *)personData {
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户信息";
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,[USER_DEFAULT objectForKey:USER_AVATAR]]] placeholderImage:UIIMAGE(@"individual_avatar_female")];
    [_scrollView setDelaysContentTouches:NO];
    self.name.text = [NSString stringWithFormat:@"您好，%@",[USER_DEFAULT objectForKey:USER_NAME]];
    [self loadData];
    [self loadCalendarData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    days = [NSMutableArray new];
    earns = [NSMutableArray new];
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,WEEKEARNING] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            NSArray * list = [dic objectForKey:@"list"];
            for (int i = 0; i < [list count]; i++) {
                NSDictionary * dic = list[i];
                NSString * day = [dic objectForKey:@"STAT_DT"];
                [days addObject:[day substringWithRange:NSMakeRange(4, 4)]];
                CGFloat earn = [[dic objectForKey:@"TOT_INC_AMT"] floatValue]/1000;
                [earns addObject:[NSString stringWithFormat:@"%f",earn]];
            }
            [self setup];
        }
    }];
}

- (void)loadCalendarData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,SELCALENDAR] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if (bSuccess) {
            NSDictionary * data = JSON(returnData);
            lists = [data objectForKey:@"list"];
            GZAPP.calendars = lists;
            [self loadCalendarDic];
        }
    }];

}


- (void)loadCalendarDic {
    lists = GZAPP.calendars;
    activity = [NSMutableDictionary new];
    for (int i = 1; i < 13; i++) {
        [activity setObject:[NSMutableDictionary new] forKey:[NSString stringWithFormat:@"%i",i]];
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    
    [lists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDate * date = [formatter dateFromString:[obj objectForKey:@"BMST_RTN_DT"]];
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
        CalendarDayModel * model = [CalendarDayModel calendarDayWithDate:date];
        model.isRemind = YES;
        model.year = dateComponents.year;
        model.month = dateComponents.month;
        model.day = dateComponents.day;
        [[activity objectForKey:[NSString stringWithFormat:@"%ld",dateComponents.month]] setObject:model forKey:[NSString stringWithFormat:@"%ld",dateComponents.day]];
        
    }];
    NSLog(@"%@",activity);
}


- (void)setup
{
    
    [_price countFrom:0 to:[[earns lastObject] floatValue]];
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, _chartView.frame.size.width, _chartView.frame.size.height)];
    lineChart.xLabelColor = RGBCOLOR(139, 32, 35);
    lineChart.clipsToBounds = NO;
    lineChart.xLabelFont = [UIFont systemFontOfSize:9];
    [lineChart setXLabels:@[@"",@"",@"",@"",@""] withWidth:30];
    lineChart.showLabel = NO;
    lineChart.backgroundColor = [UIColor clearColor];
    NSLog(@"%f",lineChart.chartMargin);
    // Line Chart No.1
    
    
    NSArray * data01Array = earns;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = RGBCOLOR(139, 32, 35);
    data01.chartDatas = data01Array;
    data01.itemCount = data01Array.count;
    data01.inflexionPointWidth = 15;
    data01.circleLineWidth = 5;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    [_chartView addSubview:lineChart];
    
    _labelView.datas = days;
    
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

- (IBAction)calendarAction:(id)sender {
    CalendarViewController * view = [[CalendarViewController alloc] init];
    view.activity = activity;
    [self.navigationController pushViewController:view animated:YES];
}
@end
