//
//  RecommendFriendViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RecommendFriendViewController.h"
#import "RecommonFriendCell.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

@interface RecommendFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * friends;
    NSInteger pageNum;
}

@end

@implementation RecommendFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我推荐的好友";
    pageNum = 1;
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
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?pageNum=%ld",TEST_NETADDRESS,MYRECOMMEDFRIEND,index] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (index == 1) {
                friends = [[dic objectForKey:@"pageModel"] objectForKey:@"list"];
                [_tableView.header endRefreshing];
                [_tableView reloadData];
            }
            else
            {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [friends addObjectsFromArray:[[dic objectForKey:@"pageModel"] objectForKey:@"list"]];
                }
                [_tableView.footer endRefreshing];
                [_tableView reloadData];
            }
        }
    }];
}

#pragma mark UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    RecommonFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary * currentData = friends[indexPath.row];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommonFriendCell" owner:self options:nil] lastObject];
    }
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,[currentData objectForKey:@"avatarImg"]]] placeholderImage:UIIMAGE(@"avatar_icon_default")];
    cell.name.text = [currentData objectForKey:@"userRealname"];
    cell.time.text = [currentData objectForKey:@"userAddtime"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friends count];
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
