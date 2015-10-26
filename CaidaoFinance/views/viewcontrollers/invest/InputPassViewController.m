//
//  InputPassViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/19.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InputPassViewController.h"
#import "TrandingSucViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"

@interface InputPassViewController ()
{
    NSDictionary * investDic;
    CGFloat investPrice;
    NSInteger redNumber;
    BOOL isRedBool;
}

@end

@implementation InputPassViewController

- (id)initWithInvestData:(NSDictionary *)investData  price:(CGFloat)price redNumber:(NSInteger)red isRedBool:(BOOL)isRed{
    if (self) {
        investDic = investData;
        investPrice = price;
        redNumber = red;
        isRedBool = isRed;
        self.type = PayTypeInvest;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易密码";
    self.scrollView.delaysContentTouches = NO;
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

- (IBAction)suerAction:(id)sender {
    switch (self.type) {
        case PayTypeInvest:
        {
            [self.pass resignFirstResponder];
            NSString * signborrowid = [[investDic objectForKey:@"SignBorrowId"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString * url = !isRedBool?
            [NSString stringWithFormat:@"%@%@?borrowId=%@&tenderAmount=%@&payPassword=%@&annualInterestRate=%@&borrowSum=%@&borrowTimeLimit=%@&bidKind=%@&SignBorrowId=%@",TEST_NETADDRESS,TENDER,[[[investDic objectForKey:@"borrow"] objectForKey:@"id"] stringValue],[NSString stringWithFormat:@"%.2f",investPrice],_pass.text,[[investDic objectForKey:@"borrow"] objectForKey:@"annualInterestRate"],[[investDic objectForKey:@"borrow"] objectForKey:@"borrowSum"],[[investDic objectForKey:@"borrow"] objectForKey:@"borrowTimeLimit"],[[investDic objectForKey:@"borrow"]objectForKey:@"bidKind"],signborrowid]:
            [NSString stringWithFormat:@"%@%@?borrowId=%@&tenderAmount=%@&payPassword=%@&annualInterestRate=%@&borrowSum=%@&borrowTimeLimit=%@&bidKind=%@&SignBorrowId=%@&redPackageAmount=%ld",TEST_NETADDRESS,TENDER,[[[investDic objectForKey:@"borrow"] objectForKey:@"id"] stringValue],[NSString stringWithFormat:@"%.2f",investPrice],_pass.text,[[investDic objectForKey:@"borrow"] objectForKey:@"annualInterestRate"],[[investDic objectForKey:@"borrow"] objectForKey:@"borrowSum"],[[investDic objectForKey:@"borrow"] objectForKey:@"borrowTimeLimit"],[[investDic objectForKey:@"borrow"]objectForKey:@"bidKind"],signborrowid,redNumber];
            
            
            [[GZNetConnectManager sharedInstance] conURL:url connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                if (bSuccess) {
                    NSDictionary * dic = JSON(returnData);
                    if ([[dic objectForKey:@"code"] integerValue] != 200) {
                        
                        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"投资失败" alignment:CTCommonUtilsShowBottom];
                    }
                    else
                    {
                        [self.navigationController pushViewController:[[TrandingSucViewController alloc] initWithSuccessData:dic price:investPrice]  animated:YES];
                    }
                }
            }];
        }
        break;
            
        default:
            break;
    }
   
    
}
@end
