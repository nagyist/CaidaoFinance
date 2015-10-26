//
//  MyLendViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MyLendViewController.h"
#import "MyLendCell.h"
#import "LendDetailViewController.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>

@interface MyLendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * borrows;
    NSInteger pageNum;
}

@end

@implementation MyLendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    borrows = [NSMutableArray new];
    self.title = @"我的借贷";
    pageNum = 1;

    _tableView.dataSource = self;
    _tableView.delegate = self;
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

- (void)loadData:(NSInteger)page {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?pageNum=%ld",TEST_NETADDRESS,MYBORROW,page] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if(bSuccess)
        {
            NSDictionary * dic = JSON(returnData);
            if (page == 1) {
                [_tableView.header endRefreshing];
                borrows = [JSON(returnData) objectForKey:@"list"];
                [_tableView reloadData];
            }
            else
            {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [borrows addObjectsFromArray:[dic objectForKey:@"list"]];
                }
                [_tableView.footer endRefreshing];
                [_tableView reloadData];
            }
        }
    }];
}


- (void)loadNewData {
    pageNum = 1;
    [self loadData:pageNum];
}

- (void)loadMoreData {
    pageNum ++;
    [self loadData:pageNum];
}


- (void)viewDidAppear:(BOOL)animated
{
    if (_tableView) {
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[LendDetailViewController alloc] initWithBorrowerData:borrows[indexPath.row]] animated:YES];
}

#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"celllId";
    NSDictionary * currentData= borrows[indexPath.row];
    MyLendCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyLendCell" owner:self options:nil] lastObject];
    }
    cell.state.text = [self getState:[[currentData objectForKey:@"status01"] integerValue]];
    cell.time.text = [NSString stringWithFormat:@"%@天",[[currentData objectForKey:@"borrow_time_limit"] stringValue]];
    cell.name.text = [currentData objectForKey:@"user_name"];
    [cell.price countFrom:[[currentData objectForKey:@"borrow_money"] floatValue] to:[[currentData objectForKey:@"borrow_money"] floatValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [borrows count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getState:(NSInteger)index {
    NSString * state = @"";
    switch (index) {
        case 0:
            state = @"申请中";
            break;
        case 1:
            state = @"初审通过";
            break;
        case -1:
            state = @"初审未通过";
            break;
            
        default:
            break;
    }
    return state;
    
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
