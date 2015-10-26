//
//  MakeOverRecordViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MakeOverRecordListViewController.h"
#import "MORecordCell.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"

@interface MakeOverRecordListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary * recordData;
    NSArray * lists;
    NSDictionary * data;
}
@end

@implementation MakeOverRecordListViewController


- (id)initWithRecordData:(NSDictionary *)data {
    if (self) {
        recordData = data;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转让明细记录";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[UIView new]];
//    lists = [recordData objectForKey:@"transferList"];
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@",TEST_NETADDRESS,TENDERINFOLIST,[[recordData objectForKey:@"borrow"] objectForKey:@"id"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            data = JSON(returnData);
            lists = [[data objectForKey:@"page"] objectForKey:@"list"];
            [_tableView reloadData];
        }
    }];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    MORecordCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary * currentData = lists[indexPath.row];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MORecordCell" owner:self options:nil] lastObject];
    }
    cell.name.text = [currentData objectForKey:@"investorAccount"] == nil?[currentData objectForKey:@"userPhone"]:[currentData objectForKey:@"investorAccount"];
    [cell.price countFrom:[[currentData objectForKey:@"effective_amount"] floatValue] to:[[currentData objectForKey:@"effective_amount"] floatValue]];
    cell.rate.text = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"annualInterestRate"],@"%"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lists count];
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
