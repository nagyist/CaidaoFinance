//
//  MoneyManagerViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MoneyManagerViewController.h"
#import "MoneyDetailViewController.h"
#import "RecharApplyViewController.h"
#import "GZNetConnectManager.h"

@interface MoneyManagerViewController ()
{
    NSDictionary * individualData;
    NSDictionary * userAccount;
}

@end

@implementation MoneyManagerViewController

- (id)initWithIndiviData:(NSDictionary *)inData {
    if (self) {
        individualData = inData;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, 500)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金管理";
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,TRANSITIONRECORD] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            userAccount = [dic objectForKey:@"userAccount"];
            [self.moneyOne countFrom:0 to:[[userAccount objectForKey:@"allMoney"] floatValue] withDuration:1.5];
            [self.moneyTwo countFrom:0 to:[[userAccount objectForKey:@"availableMoney"] floatValue] withDuration:1.5];
            [self.moneyThree countFrom:0 to:[[userAccount objectForKey:@"unavailableMoney"] floatValue] withDuration:1.5];
            [self.moneyFour countFrom:0 to:[[userAccount objectForKey:@"waitRepossessedCapital"] floatValue] + [[userAccount objectForKey:@"waitRepossessedInterest"] floatValue] withDuration:1.5];
        }
    }];
    
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

- (IBAction)action:(id)sender {
    switch ([sender tag]) {
        case 0:
        {
            MoneyDetailViewController * view = [[MoneyDetailViewController alloc] init];
            view.type = MoneyDetailViewTypeMoney;
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 1:
            [self.navigationController pushViewController:[[RecharApplyViewController alloc] initWithAccountData:userAccount] animated:YES];
            break;
        case 2:
        {
            MoneyDetailViewController * view = [[MoneyDetailViewController alloc] init];
            view.type = MoneyDetailViewTypeRecharge;
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
