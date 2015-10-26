//
//  MyInvestDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MyInvestDetailViewController.h"
#import "GathDetailViewController.h"
#import "GZNetConnectManager.h"
#import "WebContractsViewController.h"

@interface MyInvestDetailViewController ()<ContractViewDelegate>
{
    NSString * borrowId;
    NSDictionary * myInvestData;
    NSDictionary * myInvestDetail;
    
    
    NSDictionary * jujianhetong;
    NSDictionary * dianzixieyi;
    NSDictionary * zhuanrang;
    NSDictionary * zhuanrangqingdan;
    
    NSMutableArray * contracts;
    
}

@end

@implementation MyInvestDetailViewController

- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, _bottomView.frame.size.height + _bottomView.frame.origin.y + 20)];
}

- (id)initWithInvestBiaoType:(InvestBiaoType)type investData:(NSDictionary *)investData{
    if (self) {
        self.type = type;
        myInvestData = investData;
        borrowId = [investData objectForKey:@"borrowId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投资详情";
    zhuanrang = @{@"name":@"债权转让合同",@"url":@"http://www.186886.com/app/appTransfereecontract.do?borrowId=306"};
    jujianhetong = @{@"name":@"财道金融居间服务合同",@"url":@"http://www.186886.com/app/appFeeAgreement.do?tendeId=24&borrowId=306"};
    dianzixieyi = @{@"name":@"财道金融电子协议",@"url":@"http://www.186886.com/app/appBorrowAgreement.do?borrowId=306"};
    zhuanrangqingdan = @{@"name":@"债权转让人清单",@"url":@"http://www.186886.com/app/appTransfereeUserList.do?tenderId=411&borrowId=329"};
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    [self loadData:self.type];
    self.contractView.delegate = self;
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData:(InvestBiaoType)type {
    switch (type) {
        case InvestBiaoTypeNormal:
        {
            [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&tenderId=%@",TEST_NETADDRESS,CHECKINVESTDETAIL,borrowId,[myInvestData objectForKey:@"id"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                if (bSuccess) {
                    myInvestDetail = JSON(returnData);
                    [self setData];
                }
            }];
        }
            break;
        case InvestBiaoTypeTransfer:
        {
            [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&tenderId=%@",TEST_NETADDRESS,BIDINVESTDETAIL,borrowId,[myInvestData objectForKey:@"id"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                if (bSuccess) {
                    myInvestDetail = JSON(returnData);
                    [self setData];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)setData {
    
    self.bianhao.text =  [myInvestData objectForKey:@"borrowTitle"];
    self.state.text = [self getStatusByIndex:[[myInvestData objectForKey:@"tenderStatus"] integerValue]];
    [self.price countFrom:[[myInvestData objectForKey:@"tenderAmount"] floatValue] to:[[myInvestData objectForKey:@"tenderAmount"] floatValue] withDuration:1.0];
    self.rate.text = [NSString stringWithFormat:@"%@%@",[myInvestData objectForKey:@"annualInterestRate"],@"%"];
    CGFloat yihuishou = [[myInvestDetail objectForKey:@"paidAmount"] floatValue] + [[myInvestDetail objectForKey:@"interestPaid"] floatValue];
    CGFloat daihuishou = [[myInvestDetail objectForKey:@"stayingAmount"] floatValue] + [[myInvestDetail objectForKey:@"stayingInterest"] floatValue];

    [self.huishou countFrom:yihuishou to:yihuishou withDuration:1.0];
    [self.huishouPrice countFrom:daihuishou to:daihuishou withDuration:1.0];

    self.time.text = [[myInvestData objectForKey:@"isDay"] integerValue] == 1?[NSString stringWithFormat:@"%@%@",[[myInvestData objectForKey:@"borrowTimeLimit"] stringValue],@"天"]:[NSString stringWithFormat:@"%@%@",[[myInvestData objectForKey:@"borrowTimeLimit"]stringValue],@"个月"];
    self.payType.text = [self getPaytype:[[[myInvestDetail objectForKey:@"borrow"] objectForKey:@"repaymentStyle"] integerValue]];
    switch (self.type) {
        case InvestBiaoTypeNormal:
        {
            contracts = [NSMutableArray new];
            [contracts addObject:jujianhetong];
            [contracts addObject:dianzixieyi];
        }
            break;
        case InvestBiaoTypeTransfer:
        {
            contracts = [NSMutableArray new];
            [contracts addObject:zhuanrang];
            [contracts addObject:zhuanrangqingdan];
        }
            break;
            
        default:
            break;
    }
    
    [self.contractView showContractList:contracts];

}

#pragma mark ContractViewDelegate
- (void)didSelectedContract:(NSInteger)index {
    [self.navigationController pushViewController:[[WebContractsViewController alloc] initWithURL:[contracts objectAtIndex:index]] animated:YES];
}


- (NSString *)getPaytype:(NSInteger)index {
    NSString * type = @"";
    switch (index) {
        case 1:
            type = @"到期一次性还款";
            break;
        case 2:
            type = @"按月分期";
            break;
        case 3:
            type = @"按期付息到期一次性还本";
            break;
            
        default:
            break;
    }
    return type;
}

- (NSString*)getStatusByIndex:(NSInteger)index {
    NSString * status= @"";
    NSLog(@"%ld",index);
    switch (index) {
        case 1:
            status = @"待审核";
            break;
        case 2:
            status = @"投标失败";
            break;
        case 3:
            status = @"还款中";
            break;
        case 4:
            status = @"还款成功";
            break;
        case 5:
            status = @"已逾期";
            break;
        case 7:
            status = @"已转让";
            break;
            
        default:
            break;
    }
    return status;
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

- (IBAction)detailAction:(id)sender {
    [self.navigationController pushViewController:[[GathDetailViewController alloc] initWithDetailData:myInvestDetail] animated:YES];
}
@end
