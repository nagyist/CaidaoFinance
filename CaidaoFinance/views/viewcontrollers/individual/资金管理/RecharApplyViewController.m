//
//  RecharApplyViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RecharApplyViewController.h"
#import <FlatUIKit.h>
#import "GZMessUtils.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"

@interface RecharApplyViewController ()<FUIAlertViewDelegate>
{
    NSDictionary * account;
    NSDictionary * bindBankData;
}
@end

@implementation RecharApplyViewController

- (id)initWithAccountData:(NSDictionary *)accountData {
    if (self) {
        account = accountData;
    }
    return self;
}

- (IBAction)vertyAction:(id)sender {
    [_vertyButton setEnabled:NO];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&type=%@",TEST_NETADDRESS,GETSMS,[USER_DEFAULT objectForKey:USER_TEL],@"cash"] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        
    }];
    [[GZMessUtils sharedUtils] startCountDown:120 label:_vertyButton.titleLabel block:^{
        [_vertyButton setEnabled:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现申请";
    [self loadData];
    [self.moneyLabel countFrom:0 to:[[account objectForKey:@"allMoney"] integerValue] withDuration:1.5];
    if ([USER_DEFAULT objectForKey:USER_BANKACCOUNT]) {
        NSString * str = [[USER_DEFAULT objectForKey:USER_BANKACCOUNT] substringWithRange:NSMakeRange([[USER_DEFAULT objectForKey:USER_BANKACCOUNT] length] - 5, 4)];
        self.card.text = [NSString stringWithFormat:@"(%@%@)",@"尾号",str];
    }
    else
    {
        self.card.text = @"(您还未绑定银行卡)";
    }
    NSString * left = [[USER_DEFAULT objectForKey:USER_TEL] substringWithRange:NSMakeRange(0, 3)];
    NSString * right= [[USER_DEFAULT objectForKey:USER_TEL] substringWithRange:NSMakeRange(8, 3)];
    self.tel.text = [NSString stringWithFormat:@"%@***%@",left,right];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,BANKINFO] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            bindBankData = [JSON(returnData) objectForKey:@"userBank"];
            [self setData];
        }
    }];
}

- (void)setData {
    self.bankName.text = [bindBankData objectForKey:@"bankName"];
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender {
    [_price resignFirstResponder];
    [_pwd resignFirstResponder];
    [_sms resignFirstResponder];
    if(![USER_DEFAULT objectForKey:USER_BANKACCOUNT])
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"您还未绑定银行卡"alignment:CTCommonUtilsShowBottom];
    }
    else
    {
        if ([_price.text isEqualToString:@""]) {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"提现金额不能为空" alignment:CTCommonUtilsShowBottom];
            return;
        }
        if ([_pwd.text isEqualToString:@""]) {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"交易不能为空" alignment:CTCommonUtilsShowBottom];
            return;
        }
        if ([_sms.text isEqualToString:@""]) {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"验证码不能为空" alignment:CTCommonUtilsShowBottom];
            return;
        }
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?bankAccount=%@&userTel=%@&availableMoney=%@&cashTotal=%@&userPaypassword=%@CRD_NO=%@",TEST_NETADDRESS,APPLY,[USER_DEFAULT objectForKey:USER_BANKACCOUNT],[USER_DEFAULT objectForKey:USER_TEL],[account objectForKey:@"allMoney"],_price.text,_pwd.text,_sms.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            if (bSuccess) {
                NSDictionary * dic = JSON(returnData);
                if([dic objectForKey:@"successed"])
                {
                    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:
                                               [NSString stringWithFormat:@"提现申请提交成功\n提现金额%@元将于2个工作日内到账",self.moneyLabel.text]
                                                                          message:nil
                                                                         delegate:self cancelButtonTitle:@"确定"
                                                                otherButtonTitles: nil];
                    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
                    alertView.titleLabel.textColor = [UIColor grayColor];
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
            }
        }];
        
    }
}

@end
