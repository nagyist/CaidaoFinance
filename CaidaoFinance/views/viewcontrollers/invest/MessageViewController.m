//
//  MessageViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/22.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>
#import "CTCommonUtils.h"
#import "SVProgressHUD.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * messages;
    NSDictionary * cinvestData;
    NSDictionary * messageData;
    NSInteger currentPage;
}

@end

@implementation MessageViewController

- (id)initWithInvestData:(NSDictionary *)investData {
    if (self) {
        cinvestData = investData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"留言";
    messages = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header.updatedTimeHidden = YES;
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    currentPage = 1;

    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {

    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&pageNum=%@",TEST_NETADDRESS,MESSAGELIST,[[cinvestData objectForKey:@"borrower"] objectForKey:@"borrowId"],[NSString stringWithFormat:@"%ld",currentPage]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            messageData = JSON(returnData);
            messages = [messageData objectForKey:@"list"];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadNewData {
    currentPage = 1;
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&pageNum=%@",TEST_NETADDRESS,MESSAGELIST,[[cinvestData objectForKey:@"borrower"] objectForKey:@"borrowId"],[NSString stringWithFormat:@"%ld",currentPage]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            messages = [JSON(returnData) objectForKey:@"list"];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData {
    currentPage ++;
    if (currentPage > [[messageData objectForKey:@"totalPage"] integerValue]) {
        [self.tableView.footer endRefreshing];

        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"没有更多了" alignment:CTCommonUtilsShowBottom];
        return;
    }
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&pageNum=%@",TEST_NETADDRESS,MESSAGELIST,[[cinvestData objectForKey:@"borrower"] objectForKey:@"borrowId"],[NSString stringWithFormat:@"%ld",currentPage]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            [self.tableView.footer endRefreshing];
            NSDictionary * dic = JSON(returnData);
            if (messages) {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [messages addObjectsFromArray:JSON(returnData)];
                }
            }
            [self.tableView reloadData];
        }
    }];
}


- (void)sendMessage:(NSString*)text {
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@&content=%@",TEST_NETADDRESS,SENDMESSAGE,[[cinvestData objectForKey:@"borrower"] objectForKey:@"borrowId"],text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            [SVProgressHUD dismiss];
            if ([returnData isEqualToString:@"请先登录在进行留言"]) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:returnData alignment:CTCommonUtilsShowBottom];
            }
            else if([returnData isEqualToString:@"200"])
            {
                [self loadData];
            }
        }
    }];
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark TableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    NSDictionary * currentData = messages[indexPath.row];
    MessageTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil] lastObject];
    }
    cell.text.text = [currentData objectForKey:@"content"];
    cell.text.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static MessageTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    NSDictionary * currentData = messages[indexPath.row];

    //只会走一次
    dispatch_once(&onceToken, ^{
        cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cellId2"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil] lastObject];
        }
    });
    
    //calculate
    CGFloat height = [cell calulateHeightWithDesrip:[currentData objectForKey:@"content"]];
    
    return height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
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



- (IBAction)sendAction:(id)sender {
    [self sendMessage:_text.text];
    [_text resignFirstResponder];
    _text.text = @"";
}
@end
