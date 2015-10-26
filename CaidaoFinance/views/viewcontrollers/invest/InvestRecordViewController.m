//
//  InvestRecordViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InvestRecordViewController.h"
#import "RecordTableViewCell.h"
#import "GZNetConnectManager.h"

@interface InvestRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary * detailData;
    NSInteger page;
    NSArray * records;
    NSDictionary * recordData;
}

@end

@implementation InvestRecordViewController

- (id)initWithDetailData:(NSDictionary *)data
{
    if (self) {
        detailData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void)getData
{
    NSString * borrowId = [[detailData objectForKey:@"borrower"] objectForKey:@"borrowId"];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&pageNum=%ld",TEST_NETADDRESS,TENDERLIST,borrowId,page] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            recordData = JSON(returnData);
            records = [[recordData objectForKey:@"page"]objectForKey:@"list"];
            [_tableView reloadData];
        }
        
    }];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellid";
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary * currentData = records[indexPath.row];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:self options:nil] lastObject];
    }
    cell.name.text = [currentData objectForKey:@"investorAccount"];
    cell.percent.text = [NSString stringWithFormat:@"%.2f%@",[[[detailData objectForKey:@"borrow"] objectForKey:@"annualInterestRate"] floatValue],@"%"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [records count];
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
