//
//  DetalViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "DetalViewController.h"

@interface DetalViewController ()
{
    NSDictionary * detailData;
}

@end

@implementation DetalViewController

- (id)initWithDetailData:(NSDictionary *)data
{
    if (self) {
        detailData = data;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = [[detailData objectForKey:@"borrower"] objectForKey:@"name"];
    self.type.text = [[detailData objectForKey:@"borrower"] objectForKey:@"type"];
    self.yewu.text = [[detailData objectForKey:@"borrower"] objectForKey:@"mainBusiness"];
    self.shouru.text = [[detailData objectForKey:@"borrower"] objectForKey:@"annualBusinessIncome"];
    self.yongtu.text = [[detailData objectForKey:@"borrower"] objectForKey:@"borrowUse"];
    self.laiyuan.text = [[detailData objectForKey:@"borrower"] objectForKey:@"repaymentSource"];
    self.bank.text = [[detailData objectForKey:@"borrower"] objectForKey:@"cooperationBank"];
    if (![[[detailData objectForKey:@"borrower"] objectForKey:@"businessLicense"] boolValue]) {
        self.zhizhao.text = @"营业执照 无";
    }
    if (![[[detailData objectForKey:@"borrower"] objectForKey:@"financialSeal"] boolValue]) {
        self.gongzhang.text = @"企业公章财务章 无";
    }

    
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

@end
