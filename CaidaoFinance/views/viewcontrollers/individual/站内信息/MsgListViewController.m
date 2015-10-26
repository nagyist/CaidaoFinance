//
//  MsgListViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MsgListViewController.h"
#import "MessageCell.h"
#import "InsMessageDetailViewController.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>

@interface MsgListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * datas;
    NSMutableArray * msgs;
    NSInteger pageNum;
}

@end

@implementation MsgListViewController

-(void)viewDidAppear:(BOOL)animated
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"站内信息";
    [self loadData:1];
    pageNum = 1;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header.updatedTimeHidden = YES;
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    // Do any additional setup after loading the view from its nib.
}

- (void)loadData:(NSInteger)page {
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?pageNum=%ld",TEST_NETADDRESS,MYMESSAGES,page] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (page == 1) {
                [_tableView.header endRefreshing];
                msgs = [JSON(returnData) objectForKey:@"list"];
                [_tableView reloadData];
            }
            else
            {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [msgs addObjectsFromArray:[JSON(returnData) objectForKey:@"list"]];
                    [_tableView reloadData];
                }
                [_tableView.footer endRefreshing];

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[InsMessageDetailViewController alloc] initWithDetailData:msgs[indexPath.row]] animated:YES];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    MessageCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary * currentData = msgs[indexPath.row];
    NSDictionary * timedata = [currentData objectForKey:@"messageSendDateTime"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] lastObject];
    }
    NSString * user = [[currentData objectForKey:@"sendUserAccount"] isEqualToString:@"EastAdmin"]?@"财道金融":[currentData objectForKey:@"sendUserAccount"];
    NSString * time = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld 来自\"%@\"",[[timedata objectForKey:@"year"] integerValue],[[timedata objectForKey:@"month"] integerValue],[[timedata objectForKey:@"day"] integerValue],[[timedata objectForKey:@"hours"] integerValue],[[timedata objectForKey:@"minutes"] integerValue],[[timedata objectForKey:@"seconds"] integerValue],user];
    cell.timeone.text = time;
    cell.timetwo.text = time;
    cell.isnew.hidden = [[currentData objectForKey:@"messageStatus"] boolValue];
    cell.title.text = [currentData objectForKey:@"messageTitle"];
    cell.text.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:11];
    cell.text.text = [currentData objectForKey:@"messageContent"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static MessageCell *cell = nil;
    static dispatch_once_t onceToken;
    //只会走一次
    dispatch_once(&onceToken, ^{
        cell = (MessageCell*)[tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] lastObject];
        }
    });
    NSDictionary * currentData = msgs[indexPath.row];

//    cell.text.textColor = RGBCOLOR(139, 32, 35);
    //calculate
    cell.text.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:11];
    CGFloat height = [cell calulateHeightWithDesrip:[currentData objectForKey:@"messageContent"]];

    return height - 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [msgs count];
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
