//
//  MyInvestViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MyInvestViewController.h"
#import "MyInvestDetailViewController.h"
#import "ApplyMakeoverViewController.h"
#import "MyInvestCell.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>

@interface MyInvestViewController ()<UITableViewDataSource,UITableViewDelegate,MyInvestDelegate>
{
    NSMutableArray * invests;
    NSInteger pageNum;
}

@end

@implementation MyInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNum = 1;

    self.title = @"我的投资";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header.updatedTimeHidden = YES;
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    [self loadData:1];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadNewData {
    [self loadData:1];
}

- (void)loadMoreData {
    pageNum ++;
    [self loadData:pageNum];
}


- (void)loadData:(NSInteger)index {
    pageNum = index;
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?pageNum=%ld",TEST_NETADDRESS,MYINVEST,index] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (index == 1) {
                invests = [[dic objectForKey:@"pageModel"] objectForKey:@"list"];
                [_tableView.header endRefreshing];
                [_tableView reloadData];
            }
            else
            {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [invests addObjectsFromArray:[[dic objectForKey:@"pageModel"] objectForKey:@"list"]];
                    [_tableView reloadData];
                }
                [_tableView.footer endRefreshing];

            }
        }
    }];
    
}


#pragma mark UITableViewDelegate
- (void)didMakeOver:(NSInteger)index{
    NSDictionary * data = invests[index];
    [self.navigationController pushViewController:[[ApplyMakeoverViewController alloc] initWithApplyDetailData:data] animated:YES];
}

- (void)didWatch:(NSInteger)index{
    NSDictionary * data = invests[index];
    if ([[data objectForKey:@"bidKind"] isEqualToString:@"TRANSFER"]) {
        [self.navigationController pushViewController:[[MyInvestDetailViewController alloc] initWithInvestBiaoType:InvestBiaoTypeTransfer investData:data] animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:[[MyInvestDetailViewController alloc] initWithInvestBiaoType:InvestBiaoTypeNormal investData:data] animated:YES];
    }
}


#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"cellId";
    NSDictionary * currentData = invests[indexPath.row];
    MyInvestCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyInvestCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.titleLabel.text = [currentData objectForKey:@"borrowTitle"];
    cell.rate.text = [NSString stringWithFormat:@"%@%@",[[currentData objectForKey:@"annualInterestRate"] stringValue],@"%"];
    cell.time.text = [[currentData objectForKey:@"isDay"] integerValue] == 1?[NSString stringWithFormat:@"%@%@",[[currentData objectForKey:@"borrowTimeLimit"] stringValue],@"天"]:[NSString stringWithFormat:@"%@%@",[[currentData objectForKey:@"borrowTimeLimit"]stringValue],@"个月"];
    [cell.price countFrom:[[currentData objectForKey:@"tenderAmount"] floatValue] to:[[currentData objectForKey:@"tenderAmount"] floatValue] withDuration:1.0];
    NSInteger timeinterger = [[[currentData objectForKey:@"tenderAddtime"] objectForKey:@"time"] integerValue];
    NSTimeInterval timeInterval = timeinterger/1000;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString * time = [formatter stringFromDate:date];
    cell.investTime.text = time;
//    cell.investTime.text = [NSString stringWithFormat:@"%ld-%ld-%ld",[[[currentData objectForKey:@"tenderAddtime"] objectForKey:@"year"] integerValue],[[[currentData objectForKey:@"tenderAddtime"] objectForKey:@"month"] integerValue],[[[currentData objectForKey:@"tenderAddtime"] objectForKey:@"day"] integerValue]];
    cell.state.text = [self getStatusByIndex:[[currentData objectForKey:@"tenderStatus"] integerValue]];
    if ([[currentData objectForKey:@"tenderStatus"] integerValue] != 3) {
        cell.transferButton.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [invests count];
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

@end
