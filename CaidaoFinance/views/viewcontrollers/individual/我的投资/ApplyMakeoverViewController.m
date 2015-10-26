//
//  ApplyMakeoverViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ApplyMakeoverViewController.h"
#import "PublishViewController.h"
#import "GZMenuListView.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"

@interface ApplyMakeoverViewController ()<GZMenuListViewDataSource,GZMenuListViewDelegate>
{
    NSArray * dropData;
    NSArray * dropDataTwo;
    NSArray * dropDataThree;
    NSMutableArray * dropDataFour;
    NSDictionary * applyDetailData;
    NSMutableDictionary * currentDetailData;
    
    //转让原因
    NSString * reason;
    //发布时间
    NSInteger  day;
    NSInteger hour;
    NSString * minutes;
    
    NSDateComponents * endDateComponents;
}

@property (nonatomic,strong)GZMenuListView * menuView;
@property (nonatomic,strong)GZMenuListView * menuViewTwo;
@property (nonatomic,strong)GZMenuListView * menuViewThree;
@property (nonatomic,strong)GZMenuListView * menuViewFour;

@end

@implementation ApplyMakeoverViewController

- (id)initWithApplyDetailData:(NSDictionary *)data {
    
    if (self) {
        applyDetailData = data;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)loadData {
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@%@.do",TEST_NETADDRESS,REDEEMTRANSFER,[applyDetailData objectForKey:@"id"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if(bSuccess) {
            NSDictionary * dic = JSON(returnData);
            currentDetailData = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self setData];
        }
    }];
}

- (void)setData {
    self.code.text = [[currentDetailData objectForKey:@"tenderId"] stringValue];
    [self.benjinyue countFrom:[[currentDetailData objectForKey:@"transferMoney"]integerValue] to:[[currentDetailData objectForKey:@"transferMoney"]integerValue] withDuration:1.0];
    [self.jujianfuwufei countFrom:[[currentDetailData objectForKey:@"transferFee"] integerValue] to:[[currentDetailData objectForKey:@"transferFee"] integerValue] withDuration:1.0];
    BOOL isDay = [[[currentDetailData objectForKey:@"borrow"] objectForKey:@"isDay"] boolValue];
    NSInteger sday = isDay?[[currentDetailData objectForKey:@"transferTimeLimit"] integerValue]:[[currentDetailData objectForKey:@"transferTimeLimit"] integerValue] * 30;
    
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;

    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:sday*3600*24];
    NSDateComponents *weekdayComponents =
    [gregorian components:unitFlags fromDate:date];
    endDateComponents = weekdayComponents;
    self.qixianlabel.text = [NSString stringWithFormat:@"到%ld年%ld月%ld日债权本金余额",weekdayComponents.year,weekdayComponents.month,weekdayComponents.day];
    
    dropData = @[@"需要资金",@"期限太长"];
    dropDataTwo = [[currentDetailData objectForKey:@"hour"]integerValue] >= 18?@[@"次日"]:@[@"当日",@"次日"];
    dropDataThree = @[@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
    dropDataFour = [NSMutableArray new];
    for (int i = 0; i < 60; i++) {
        [dropDataFour addObject:[NSString stringWithFormat:@"%i",i]];
    }
    dropDataFour[0] = @"00";
    reason = @"需要资金";
    day = 0;
    hour = 10;
    minutes = dropDataFour[0];
    
    self.menuView = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.menuView.tag = 0;
    self.menuView.placeStr = [dropData firstObject];
    self.menuView.backgroundColor = [UIColor clearColor];
    self.menuView.menuSuperView = self.contentView;
    
    self.menuViewTwo = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuViewTwo.delegate = self;
    self.menuViewTwo.tag = 1;
    self.menuViewTwo.dataSource = self;
    self.menuViewTwo.placeStr = [dropDataTwo firstObject];
    self.menuViewTwo.backgroundColor = [UIColor clearColor];
    self.menuViewTwo.menuSuperView = self.contentView;
    
    self.menuViewThree = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuViewThree.delegate = self;
    self.menuViewThree.dataSource = self;
    self.menuViewThree.tag = 2;
    self.menuViewThree.placeStr = [dropDataThree firstObject];
    self.menuViewThree.backgroundColor = [UIColor clearColor];
    self.menuViewThree.menuSuperView = self.contentView;
    
    self.menuViewFour = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuViewFour.delegate = self;
    self.menuViewFour.dataSource = self;
    self.menuViewFour.placeStr = [dropDataFour firstObject];
    self.menuViewFour.tag = 3;
    self.menuViewFour.backgroundColor = [UIColor clearColor];
    self.menuViewFour.menuSuperView = self.contentView;
    
    [_scrollView setContentSize:CGSizeMake(10, _nextButton.frame.origin.y + _nextButton.frame.size.height + 20)];
    [self.contentView insertSubview:_menuView aboveSubview:_viewone];
    [self.contentView insertSubview:_menuViewTwo aboveSubview:_viewtwo];
    [self.contentView insertSubview:_menuViewThree aboveSubview:_viewthree];
    [self.contentView insertSubview:_menuViewFour aboveSubview:_viewfour];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewone.mas_left);
         make.width.equalTo(_viewone.mas_width);
         make.top.equalTo(_viewone.mas_top);
         make.height.equalTo(_viewone.mas_height);
     }];
    
    [self.menuViewTwo mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewtwo.mas_left);
         make.width.equalTo(_viewtwo.mas_width);
         make.centerY.equalTo(_viewtwo.mas_centerY);
         make.height.equalTo(_viewone.mas_height);
     }];
    
    [self.menuViewThree mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewthree.mas_left);
         make.width.equalTo(_viewthree.mas_width);
         make.centerY.equalTo(_viewthree.mas_centerY);
         make.height.equalTo(_viewone.mas_height);
     }];
    
    [self.menuViewFour mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewfour.mas_left);
         make.width.equalTo(_viewfour.mas_width);
         make.centerY.equalTo(_viewfour.mas_centerY);
         make.height.equalTo(_viewone.mas_height);
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_scrollView setDelaysContentTouches:NO];
    self.title  = @"申请债权转让";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    _text.text = @"什么情况下可以债权转让？\n目前只有符合下列条件的债权方可以申请转让\n1、债权持有时间已满1天，且债权本金余额不低于人民币5000元及剩余期限即未到期天数≥7天。\n2、债权项下借款标的还款方式同实际借款标一致。\n3、债权转让标到期还款日不是借款人的计划还款日。\n\n什么时间可以发布债权转让标？\n债权转让标的招标时间为每日8：00－23：45，当天18:00前提交的申请可选择当日或次日在上述招标时间范围内发布转让标，超过18点提交的申请，发标日期为次日。";
    
    [self loadData];
    

    // Do any additional setup after loading the view from its nib.
}

#pragma mark GZMenuListDelegate
- (void)didSelectedItem:(NSIndexPath *)indexPath value:(NSString *)value tag:(NSInteger)tag {
    switch (tag) {
        case 0:
            reason = dropData[indexPath.row];
            break;
        case 1:
            day = indexPath.row;
            break;
        case 2:
            hour = [[dropDataThree objectAtIndex:indexPath.row] integerValue];
            break;
        case 3:
            minutes = dropDataFour[indexPath.row];
            break;
            
        default:
            break;
    }
}

-(NSString*)stringFromIndex:(NSInteger)index view:(GZMenuListView *)menuView
{
    switch (menuView.tag) {
        case 0:
            return [dropData objectAtIndex:index];
            break;
        case 1:
            return [dropDataTwo objectAtIndex:index];
            break;
        case 2:
            return [dropDataThree objectAtIndex:index];
            break;
        case 3:
            return [dropDataFour objectAtIndex:index];
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)numberOfRowsOfview:(GZMenuListView *)menuView
{
    switch (menuView.tag) {
        case 0:
            return [dropData count];
            break;
        case 1:
            return [dropDataTwo count];
            
            break;
        case 2:
            return [dropDataThree count];
            
            break;
        case 3:
            return [dropDataFour count];
            
            break;
            
        default:
            break;
    }

    return [dropData count];
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

- (IBAction)nextAction:(id)sender {
    [currentDetailData setObject:[NSString stringWithFormat:@"%ld",day] forKey:@"postday"];
    [currentDetailData setObject:[NSString stringWithFormat:@"%ld",hour] forKey:@"posthour"];
    [currentDetailData setObject:[NSString stringWithFormat:@"%@",minutes] forKey:@"postminutes"];
    [currentDetailData setObject:reason forKey:@"reason"];
    [currentDetailData setObject:endDateComponents forKey:@"endTimeComponents"];
    [currentDetailData setObject:[applyDetailData objectForKey:@"annualInterestRate"] forKey:@"rate"];
    [self.navigationController pushViewController:[[PublishViewController alloc] initWithPostdata:currentDetailData] animated:YES];
    
}
@end
