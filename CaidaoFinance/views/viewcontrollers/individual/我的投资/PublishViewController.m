//

//  PublishViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "PublishViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"
#import "WebContractsViewController.h"
#import "CTCommonUtils.h"

@interface PublishViewController ()<FUIAlertViewDelegate,ContractViewDelegate> {
    NSDictionary * postdata;
    
    NSMutableArray * contracts;
    
    NSDictionary * jujianhetong;
    NSDictionary * dianzixieyi;
    NSDictionary * zhuanrang;
    NSDictionary * zhuanrangqingdan;
    
    BOOL isChecked;
}

@end

@implementation PublishViewController

- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, _publishButton.frame.origin.y + _publishButton.frame.size.height + 20)];
}

- (id)initWithPostdata:(NSDictionary *)postData {
    
    if (self) {
        postdata = postData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布债权转让";
    [_scrollView setDelaysContentTouches:NO];
    self.text.text = @"债权转让的费用如何？\n债权转让方需按成功转让金额的千分之一（最低20元）向财道金融支付债权转让费。\n\n债权转让的价格如何计算？\n债权转让价格＝转让的债权本金+截止至转让生效日应收利息（转让生效日的利息归属于购买债权转让标的会员）-债权转让服务费\n转让的债权本金：指达成交易的债权本金金额。\n截止至转让生效日应收利息：\n指自借款人上一个还息日至转让生效日（不含）的期间，转让的债权本金对应的利息。\n\n转让生效日：债权受让人受让债权并签署了债权转让相关合同之日。";
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg1.image = [_bgImg1.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _bgImg2.image = [_bgImg2.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    zhuanrang = @{@"name":@"债权转让合同",@"url":@"http://www.186886.com/app/appTransfereecontract.do?borrowId=306"};
    jujianhetong = @{@"name":@"财道金融居间服务合同",@"url":@"http://www.186886.com/app/appFeeAgreement.do?tendeId=24&borrowId=306"};
    dianzixieyi = @{@"name":@"财道金融电子协议",@"url":@"http://www.186886.com/app/appBorrowAgreement.do?borrowId=306"};
    zhuanrangqingdan = @{@"name":@"债权转让人清单",@"url":@"http://www.186886.com/app/appTransfereeUserList.do?tenderId=411&borrowId=329"};
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [SVProgressHUD show];
    NSString * date = [NSString stringWithFormat:@"%@ %@ %@",[postdata objectForKey:@"postday"],[postdata objectForKey:@"posthour"],[postdata objectForKey:@"postminutes"]];
    NSString * tenderid = [[postdata objectForKey:@"tenderId"] stringValue];
    NSString * annotation = [postdata objectForKey:@"reason"];
    NSString * transferFee = [[postdata objectForKey:@"transferFee"] stringValue];
    NSString * transferTimeLimit = [[postdata objectForKey:@"transferTimeLimit"] stringValue];
    NSString * transferInterestRate = [[postdata objectForKey:@"rate"] stringValue];
    NSString * repayment = [NSString stringWithFormat:@"%@",[[postdata objectForKey:@"borrow"] objectForKey:@"repaymentStyle"]];
    NSString * transferMoney = [[postdata objectForKey:@"transferMoney"] stringValue];
    
    
    CGFloat transmoney = [transferMoney floatValue];
    self.code.text = tenderid;
    self.startTime.text = [NSString stringWithFormat:@"%@ %@:%@",[self getDay:[[postdata objectForKey:@"postday"] integerValue]],[postdata objectForKey:@"posthour"],[postdata objectForKey:@"postminutes"]];
    
    NSDateComponents * endTime = [postdata objectForKey:@"endTimeComponents"];
    self.endTime.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",endTime.year,endTime.month,endTime.day];
//    self.time.text = [[[postdata objectForKey:@"borrow"] objectForKey:@"isDay"] integerValue] == 1?[NSString stringWithFormat:@"%@天",[postdata objectForKey:@"transferTimeLimit"]]:[NSString stringWithFormat:@"%@个月",[postdata objectForKey:@"transferTimeLimit"]];
    self.time.text = @"3天";
    [self.transfercost countFrom:20 to:20];
    [self.price countFrom:transmoney to:transmoney];
    NSString *unicodeStr = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    contracts = [NSMutableArray new];
    [contracts addObject:jujianhetong];
    [contracts addObject:dianzixieyi];
    self.contractView.delegate = self;
    [self.contractView showContractList:contracts];
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tenderId=%@&transferMoney=%@&transferFee=%@&publishDatetimeStr=%@&annualInterestRate=%@&repaymentStyle=%@",TEST_NETADDRESS,RELEASETRANSFER,tenderid,transferMoney,transferFee,unicodeStr,transferInterestRate,repayment] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            
        }
  }];
}

#pragma mark ContractViewDelegate
- (void)didSelectedContract:(NSInteger)index {
    [self.navigationController pushViewController:[[WebContractsViewController alloc] initWithURL:[contracts objectAtIndex:index]] animated:YES];
}


- (NSString*)getDay:(NSInteger)dayIndex {
    NSString * str = @"";
    switch (dayIndex) {
        case 0:
            str = @"当日";
            break;
        case 1:
            str = @"次日";
            break;
            
        default:
            break;
    }
    return str;
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

- (IBAction)checkAction:(id)sender {
    UIButton*button = (UIButton*)sender;
    [sender setSelected:!button.isSelected];
    isChecked = button.isSelected;
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSArray * arr = [self.navigationController viewControllers];
    [self.navigationController popToViewController:arr[2] animated:YES];
}

- (IBAction)publishAction:(id)sender {
    if (isChecked) {
        [SVProgressHUD show];
        NSInteger sday = [[postdata objectForKey:@"postday"] integerValue];
        NSUInteger unitFlags =
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:sday*3600*24];
        NSDateComponents *weekdayComponents =
        [gregorian components:unitFlags fromDate:date];
        
        
        NSString * publishdate = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld",weekdayComponents.year,weekdayComponents.month,weekdayComponents.day,weekdayComponents.hour,weekdayComponents.minute];
        NSString * tenderid = [[postdata objectForKey:@"tenderId"] stringValue];
        NSString * annotation = [postdata objectForKey:@"reason"];
        NSString * transferFee = [[postdata objectForKey:@"transferFee"] stringValue];
        NSString * transferTimeLimit = [[postdata objectForKey:@"transferTimeLimit"] stringValue];
        NSString * transferInterestRate = [[postdata objectForKey:@"rate"] stringValue];
        NSString * repayment = [NSString stringWithFormat:@"%@",[[postdata objectForKey:@"borrow"] objectForKey:@"repaymentStyle"]];
        NSString * transferMoney = [[postdata objectForKey:@"transferMoney"] stringValue];
        NSString *unicodeStr = [annotation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tenderId=%@&borrowTypeCode=TRANSFER&borrowSum=%@&transferFee=%@&annualInterestRate=%@&publishDatetimeStr=%@&annotation=%@&borrowTimeLimit=%@&repaymentStyle=%@",TEST_NETADDRESS,SAVEBORROW,tenderid,transferMoney,transferFee,transferInterestRate,publishdate,unicodeStr,transferTimeLimit,repayment] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            [SVProgressHUD dismiss];
            if (bSuccess) {
                NSDictionary * dic = JSON(returnData);
                if ([[dic objectForKey:@"successed"] boolValue]) {
                    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"发布成功"
                                                                          message:nil
                                                                         delegate:self cancelButtonTitle:@"确定"
                                                                otherButtonTitles:nil];
                    alertView.titleLabel.textColor = [UIColor grayColor];
                    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
                    alertView.messageLabel.textColor = [UIColor cloudsColor];
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
                else
                {
                    [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                }
            }
        }];
    }
    else {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"您还未同意用数字证书签署该借款标原有的及本次转让借款标的合同" alignment:CTCommonUtilsShowBottom];
    }
    
    
    
}
@end
