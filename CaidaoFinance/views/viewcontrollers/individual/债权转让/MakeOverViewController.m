//
//  MakeOverViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MakeOverViewController.h"
#import "MakeOverCell.h"
#import "MakeOverDetailViewController.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>
#import "SVProgressHUD.h"

@interface MakeOverViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
    NSMutableArray * lists;
}

@end

@implementation MakeOverViewController

- (void)viewDidAppear:(BOOL)animated{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的债权转让";
    ///继承
    currentPage = 1;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[UIView new]];
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
    currentPage = 1;
    [self loadData:currentPage];
}

- (void)loadMoreData {
    currentPage ++;
    [self loadData:currentPage];
}

- (void)loadData:(NSInteger)page {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?pageNum=%ld",TEST_NETADDRESS,MYTRANSFERLIST,page] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (page == 1) {
                [_tableView.header endRefreshing];
                lists = [[JSON(returnData) objectForKey:@"pageModel"] objectForKey:@"list"];
            }
            else if (page > 1)
            {
                [_tableView.footer endRefreshing];
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [lists addObjectsFromArray:[[JSON(returnData) objectForKey:@"pageModel"] objectForKey:@"list"]];
                }
            }
            [_tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[MakeOverDetailViewController alloc] initWithMakeoverData:lists[indexPath.row]] animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    MakeOverCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary * currentData = [lists objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MakeOverCell" owner:self options:nil] lastObject];
    }
    cell.code.text = [currentData objectForKey:@"borrowTitle"];
    cell.rate.text = [NSString stringWithFormat:@"%@%@",[currentData objectForKey:@"annualInterestRate"],@"%"];
    cell.time.text = [[currentData objectForKey:@"isDay"] integerValue] == 1?[NSString stringWithFormat:@"%@天",[currentData objectForKey:@"borrowTimeLimit"]]:[NSString stringWithFormat:@"%@个月",[currentData objectForKey:@"borrowTimeLimit"]];
    [cell.price countFrom:[[currentData objectForKey:@"borrowSum"] floatValue] to:[[currentData objectForKey:@"borrowSum"] floatValue]];
    cell.percent.text = [NSString stringWithFormat:@"%@%@",[currentData objectForKey:@"transferFee"],@"%"];
    [cell.progressBar setProgress:[[currentData objectForKey:@"transferFee"] floatValue]/100];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
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
