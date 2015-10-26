//
//  BindCardPreviewViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "BindCardPreviewViewController.h"
#import "GZNetConnectManager.h"

@interface BindCardPreviewViewController ()
{
    NSDictionary * bindBankData;
}

@end

@implementation BindCardPreviewViewController

- (id)initWithBinbankData:(NSDictionary *)bindData {
    if (self) {
//        bindBankData = bindData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行卡";
    self.name.text = [[bindBankData objectForKey:@"user"] objectForKey:@"userRealname"];
    [self loadData];
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
    self.name.text = [USER_DEFAULT objectForKey:USER_ACCOUNT];
    self.bankAreaName.text = [bindBankData objectForKey:@"bankCity"];
    self.bankArea.text = [NSString stringWithFormat:@"%@%@",[bindBankData objectForKey:@"provice"],[bindBankData objectForKey:@"city"]];
    self.cardNum.text = [bindBankData objectForKey:@"bankAccount"];
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

@end
