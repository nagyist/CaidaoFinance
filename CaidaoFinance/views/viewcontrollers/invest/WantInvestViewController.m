//
//  WantInvestViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/19.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "WantInvestViewController.h"
#import "InputPassViewController.h"
#import <FlatUIKit.h>

#import "InvestDetailViewController.h"
#import "MessageViewController.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"
#import "CTCommonUtils.h"
#import "ModifyTradPassViewController.h"
#import "CTCommonUtils.h"

@interface WantInvestViewController ()<FUIAlertViewDelegate,UITextFieldDelegate>
{
    InvestDetailViewController*controller;
    WantInvestType investType;
    NSDictionary * investDetailData;
    NSArray * fangshiArr;
    NSDate * fireDate;
    BOOL redNumber;
}


@end

@implementation WantInvestViewController
- (IBAction)checkAction:(id)sender {
    [self.check setSelected:!self.check.isSelected];
    
}

- (id)initwithInvestType:(WantInvestType)type
{
    if (self) {
        investType = type;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.scrollView setContentSize:CGSizeMake(0, 570)];
}

- (void)loadData {
    [SVProgressHUD show];
    NSLog(@"eid:%@",[_investData objectForKey:@"eid"]);
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@%@.do",TEST_NETADDRESS,INVESTDETAIL,[_investData objectForKey:@"eid"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            investDetailData = JSON(returnData);
            [SVProgressHUD dismiss];
            [self setData];
        }
    }];
}

- (void)setUI {
    
    self.title = investType == WantInvestTypeInvest?@"我要投资":@"我要转让";
    
    fangshiArr = @[@"一次性还款",@"按月分期",@"每日/月还息到期还本"];
    _textone.delegate = self;
    [_textone addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"留言" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(liuyanAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
    
    _progressBar.type = YLProgressBarTypeRounded;
    [_progressBar setProgressTintColors:@[RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198)]];
    [_progressBar setTrackTintColor:[UIColor clearColor]];
    [_progressBar setIndicatorTextDisplayMode:YLProgressBarIndicatorTextDisplayModeNone];
    _progressBar.behavior                 = YLProgressBarBehaviorIndeterminate;
    [_progressBar setHideGloss:YES];
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    //NSDateFormatter *dateformatter = [[[NSDateFormatter alloc]init] autorelease];//定义NSDateFormatter用来显示格式
    //[dateformatter setDateFormat:@"yyyy MM dd hh mm ss"];//设定格式
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象

    // NSString *ssss = [dateformatter stringFromDate:dd];
    // NSLog([NSString stringWithFormat:@"shibo shi:%@",ssss]);
    
    NSDate *today = [NSDate date];//得到当前时间
    
    NSTimeInterval timeInter = [fireDate timeIntervalSinceDate:today];
    if (timeInter < 0) {
        self.labelSeven.text = @"已结束";
    }
    else
    {
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:fireDate options:0];
        _labelSeven.text = [NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分%ld秒",[d year],[d month], [d day], [d hour], (long)[d minute], (long)[d second]];
    }
    // NSString *sss = [dateformatter stringFromDate:today];
    // NSLog([NSString stringWithFormat:@"xianzai shi:%@",sss]);
    //用来得到具体的时差
    
}

- (void)setData{
    
    _labeTitle.text = [self.investData objectForKey:@"borrow_title"];
    [_labelOne countFrom:[[self.investData objectForKey:@"borrow_sum"] floatValue] to:[[self.investData objectForKey:@"borrow_sum"] floatValue]];
    _labelTwo.text = [NSString stringWithFormat:@"%ld%@",[[self.investData objectForKey:@"borrow_time_limit"] integerValue],[[self.investData objectForKey:@"is_day"] integerValue] == 1?@"天":@"个月"];
    _labelThree.text = @"保本保息（约定利息）";
    _labelFour.text = fangshiArr[[[[investDetailData objectForKey:@"borrow"]objectForKey:@"repaymentStyle"]integerValue] - 1];
    _labelSix.text = [[investDetailData objectForKey:@"borrow"]objectForKey:@"publishDatetime"];
    CGFloat percent = [[investDetailData objectForKey:@"percentage"] floatValue];
    _percent.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%.2f",percent],@"%"];
    [self.progressBar setProgress:percent/100 animated:YES];
    self.nlv.text = [NSString stringWithFormat:@"%@%@",[self.investData objectForKey:@"annual_interest_rate"],@"%"];
    if ([self.investData objectForKey:@"reward_rate"]) {
        CGFloat rate = [[self.investData objectForKey:@"annual_interest_rate"] floatValue] - [[self.investData objectForKey:@"reward_rate"] floatValue];
        self.nlv.text = [NSString stringWithFormat:@"%.2f%@+%@%@",rate,@"%",[self.investData objectForKey:@"reward_rate"],@"%"];
        self.nlv.textColor = RGBCOLOR(251, 176, 68);
    }
    
    self.textone.placeholder = [NSString stringWithFormat:@"￥%@元起投",[[investDetailData objectForKey:@"borrow"]objectForKey:@"minAmount"]];
    
    if ([[[investDetailData objectForKey:@"borrow"] objectForKey:@"allowRedPackage"] integerValue] == 0) {
        [self.check setUserInteractionEnabled:NO];
        self.keyong.text = @"无";
        self.redNum.text = @"无";
    }
    else
    {
        NSString * str = [NSString stringWithFormat:@"（投资%ld元可获得1元红包）",[[[investDetailData objectForKey:@"borrow"] objectForKey:@"allowRedPackage"] integerValue]];
        self.keyong.text = [NSString stringWithFormat:@"￥%@ %@",[NSString stringWithFormat:@"%.2f",[[investDetailData objectForKey:@"redPackageValidMoney"] floatValue]],str];
        self.redNum.text =  [NSString stringWithFormat:@"%@元/个",[NSString stringWithFormat:@"%.2f",[[investDetailData objectForKey:@"giveRedPackage"] floatValue]]];
    }
    
    NSInteger day = [[self.investData objectForKey:@"borrow_time_limit"] integerValue] * [[self.investData objectForKey:@"is_day"] integerValue] == 1?1:30;
    NSTimeInterval dayTimeint = day * 3600*24;
//    self.redPrice.text = [investDetailData objectForKey:@"redPackageValidMoney"]?@"无":[NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:@"%.2f",[[investDetailData objectForKey:@"redPackageValidMoney"] floatValue]]];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate*startDate = [formatter dateFromString:[[investDetailData objectForKey:@"borrow"]objectForKey:@"publishDatetime"]];
    fireDate = [NSDate dateWithTimeInterval:dayTimeint sinceDate:startDate];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
}

#pragma mark UITextFieldDelegate
- (void)textFieldChanged:(UITextField*)textField {
    CGFloat text = [_textone.text floatValue];
    CGFloat nianlilv = [[self.investData objectForKey:@"annual_interest_rate"]floatValue]/100;
    NSLog(@"%f---nianlilv%f",text,nianlilv);
    
    CGFloat tianshu = [[self.investData objectForKey:@"borrow_time_limit"] integerValue] * [[self.investData objectForKey:@"is_day"] integerValue] == 1?1:30;
    self.shouyi.text  = [NSString stringWithFormat:@"￥%.2f",text*nianlilv*tianshu/360];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location != 0) {
        
    }
    else
    {
        self.shouyi.text  = [NSString stringWithFormat:@"￥%.2f",0.00];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"InvestViewClose" object:nil];
    [self setUI];
    [self loadData];
    
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

- (void)closeView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5f animations:^{
            controller.view.frame = CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            [controller.view layoutIfNeeded];
        } completion:^(BOOL finished)
         {
             [_openButton setEnabled:YES];
             [controller removeFromParentViewController];
             [controller.view removeFromSuperview];
             controller = nil;
         }];
    });
}

- (IBAction)investAction:(id)sender {
    
    if (![_textone.text isEqualToString:@""] || [_textone.text integerValue] > [[[investDetailData objectForKey:@"borrow"]objectForKey:@"minAmount"] integerValue]) {
        BOOL isAuth = [[USER_DEFAULT objectForKey:USER_AUTH] boolValue];
        if (isAuth) {
            [self showAlert];
        }
        else
        {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"此账号未授权，请到网页端授权后投资" alignment:CTCommonUtilsShowBottom];
        }
    }
    else
    {
        [self showFailAlert];
    }
}

#pragma mark  FUIAlertViewDelegate
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3) {
        switch (buttonIndex) {
            case 0:
            {
                ModifyTradPassViewController * passView = [[ModifyTradPassViewController alloc] init];
                passView.showSet = YES;
                [self.navigationController pushViewController:passView animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self checkPassword];
                break;
                
            default:
                break;
        }
    }
    
}

- (void)checkPassword {
    [self.texttwo resignFirstResponder];
    [self.textone resignFirstResponder];
    NSInteger min = [[[investDetailData objectForKey:@"borrow"]objectForKey:@"minAmount"] integerValue];
    if ([self.textone.text integerValue] < min) {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"投资金额不能小于起投金额" alignment:CTCommonUtilsShowBottom];
        return;
    }
    
    NSInteger keyongIndex = [[investDetailData objectForKey:@"redPackageValidMoney"] integerValue];
    NSInteger giveRedPackage = [[[investDetailData objectForKey:@"borrow"]objectForKey:@"allowRedPackage"] integerValue];
    redNumber = giveRedPackage > 0;
    //用户填入的红包个数
    NSInteger num = [self.texttwo.text integerValue];
    
    
    if ([self.check isSelected] && num > 0) {
        NSInteger validPackage = [self.textone.text integerValue]/giveRedPackage;
        
        if (num <= validPackage && num <= keyongIndex) {
            [self checkPayPassword];
        }
        else
        {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"红包数量超过限额" alignment:CTCommonUtilsShowBottom];
        }
    }
    else
    {
        [self checkPayPassword];
    }
}

- (void)checkPayPassword {
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,CHECKPAYPW] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if (bSuccess) {
            
            NSString * data = (NSString*)returnData;
            if(![data isEqualToString:@"200"])
            {
                
                [self showSetpassAlert];
            }
            else
            {
                [self.navigationController pushViewController:[[InputPassViewController alloc] initWithInvestData:investDetailData price:[_textone.text floatValue] redNumber:[self.texttwo.text integerValue] isRedBool:redNumber] animated:YES];
            }
        }
    }];

}

- (void)showSetpassAlert {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:@"您还未设置交易密码，无法投资，是否前往设置？"
                                                         delegate:self cancelButtonTitle:@"确认"
                                                otherButtonTitles:@"取消",nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.alertButtonStyle = FUIAlertViewButtonLayoutHorizontal;
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    alertView.tag = 3;
    [alertView show];
}

-(void)showFailAlert
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:[NSString stringWithFormat:@"起投金额必须大于%@",[[investDetailData objectForKey:@"borrow"] objectForKey:@"minAmount"]]
                                                         delegate:self cancelButtonTitle:@"确认"
                                                otherButtonTitles:nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.alertButtonStyle = FUIAlertViewButtonLayoutVertical;
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    [alertView show];
}

-(void)showAlert
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:[NSString stringWithFormat:@"投资%@￥%.2f",[self.investData objectForKey:@"borrow_title"],[_textone.text floatValue]]
                                                         delegate:self cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确认投资",nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.alertButtonStyle = FUIAlertViewButtonLayoutHorizontal;
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    [alertView show];
}

-(void)animationOpen
{
    [_openButton setEnabled:NO];
    
    if (!controller) {
        controller = [[InvestDetailViewController alloc] initWithInvestDetailData:investDetailData];
        [controller.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [self addChildViewController:controller];
        [self.view addSubview:controller.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5f animations:^{
                controller.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                [controller.view layoutIfNeeded];
            } completion:^(BOOL finished)
             {
                 [_openButton setEnabled:YES];
             }];
        });
    }
    
}


- (IBAction)autoAction:(id)sender {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@",TEST_NETADDRESS,GETTOTALNOSUCCESS,[[[investDetailData objectForKey:@"borrow"] objectForKey:@"id"] stringValue]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            if([returnData isEqualToString:@"m"])
            {
                _textone.text = @"0";
            }
            else
            {
                _textone.text = (NSString*)returnData;
            }
        }
    }];
}

- (void)liuyanAction
{
    [self.navigationController pushViewController:[[MessageViewController alloc] initWithInvestData:investDetailData] animated:YES];
}

- (IBAction)openAction:(id)sender {
    [self animationOpen];
}
@end
