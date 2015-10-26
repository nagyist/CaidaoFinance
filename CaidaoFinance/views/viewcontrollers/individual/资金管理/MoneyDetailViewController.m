//
//  MoneyDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MoneyDetailViewController.h"
#import "GZNetConnectManager.h"
#import "MoneyCell.h"
#import <FlatUIKit.h>
#import <MJRefresh.h>
#import "SVProgressHUD.h"

@interface MoneyDetailViewController ()<UITableViewDataSource,UITableViewDelegate,FUIAlertViewDelegate>{
    NSInteger selecteIndex;
    UIButton * selectedButton;
    NSInteger timeIndex;
    NSString * tradeCode;
    NSMutableArray * lists;
    
    NSDictionary * data;
    NSInteger currentPage;
}

@end

@implementation MoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 1;
    lists = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectedButton = _buttonOne;
    
    
    switch (self.type) {
        case MoneyDetailViewTypeMoney:
            tradeCode = @"2 6 7 8 11 13 15 17 18 21 28 31 32 33 34 35";
            break;
        case MoneyDetailViewTypeRecharge:
            tradeCode = @"13 31  11 32";
            break;
        default:
            break;
    }
    [self initUI];

    // Do any additional setup after loading the view from its nib.
}

- (void)loadData:(MoneyDetailViewType)type {
    [SVProgressHUD show];
    switch (type) {
        case MoneyDetailViewTypeMoney:
        {
            NSString *str = [tradeCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[GZNetConnectManager sharedInstance]conURL:[NSString stringWithFormat:@"%@%@?tradeCode=%@&timeLimit=%@&pageNum=%ld",TEST_NETADDRESS,TRANRECORD,str,[NSString stringWithFormat:@"%ld",selecteIndex],currentPage] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                [SVProgressHUD dismiss];
                if (bSuccess) {
                    data = JSON(returnData);
                    if (currentPage == 1) {
                        [_tableView.header endRefreshing];
                        lists = [[data objectForKey:@"pageModel"]objectForKey:@"list"];
                    }
                    else
                    {
                        if ([[[data objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[data objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                            [lists addObjectsFromArray:[[data objectForKey:@"pageModel"]objectForKey:@"list"]];
                        }
                    }
                    [_tableView.footer endRefreshing];

                    _outprice.text = [NSString stringWithFormat:@"￥%@",[data objectForKey:@"outputAmount"]];
                    _input.text = [NSString stringWithFormat:@"￥%@",[data objectForKey:@"inputAmount"]];
                    [_tableView reloadData];
                }
            }];
        }
           
            break;
        case MoneyDetailViewTypeRecharge:
        {
            NSString *str = [tradeCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[GZNetConnectManager sharedInstance]conURL:[NSString stringWithFormat:@"%@%@?tradeCode=%@&timeLimit=%@&pageNum=%ld",TEST_NETADDRESS,TRANRECORD,str,[NSString stringWithFormat:@"%ld",selecteIndex],currentPage] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                [SVProgressHUD dismiss];
                if (bSuccess) {
                    data = JSON(returnData);
                    if (currentPage == 1) {
                        [_tableView.header endRefreshing];
                        lists = [[data objectForKey:@"pageModel"]objectForKey:@"list"];
                    }
                    else
                    {
                        if ([[[data objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[data objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {

                            [lists addObjectsFromArray:[[data objectForKey:@"pageModel"]objectForKey:@"list"]];
                        }
                        [_tableView.footer endRefreshing];

                    }
                    _outprice.text = [NSString stringWithFormat:@"￥%@",[data objectForKey:@"outputAmount"]];
                    _input.text = [NSString stringWithFormat:@"￥%@",[data objectForKey:@"inputAmount"]];
                    [_tableView reloadData];
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)initUI
{
    switch (self.type) {
        case MoneyDetailViewTypeMoney:
            self.title = @"资金流水";
            [self.buttonOne setTitle:@"全部流水" forState:UIControlStateNormal];
            [self.buttonOne setTitle:@"全部流水" forState:UIControlStateSelected];
            [self.buttonTwo setTitle:@"支出流水" forState:UIControlStateNormal];
            [self.buttonTwo setTitle:@"支出流水" forState:UIControlStateSelected];
            [self.buttonThree setTitle:@"收入流水" forState:UIControlStateNormal];
            [self.buttonThree setTitle:@"收入流水" forState:UIControlStateSelected];
            self.titleOne.text = @"账单时间";
            self.titleTwo.text = @"支出总额";
            self.titleThree.text = @"收入总额";
            break;
        case MoneyDetailViewTypeRecharge:
            self.title = @"充值提现";
            [self.buttonOne setTitle:@"全部交易" forState:UIControlStateNormal];
            [self.buttonOne setTitle:@"全部交易" forState:UIControlStateSelected];
            [self.buttonTwo setTitle:@"提现" forState:UIControlStateNormal];
            [self.buttonTwo setTitle:@"提现" forState:UIControlStateSelected];
            [self.buttonThree setTitle:@"充值" forState:UIControlStateNormal];
            [self.buttonThree setTitle:@"充值" forState:UIControlStateSelected];
            self.titleOne.text = @"交易时间";
            self.titleTwo.text = @"提现总额";
            self.titleThree.text = @"充值总额";
            break;
            
        default:
            break;
    }
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header.updatedTimeHidden = YES;
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    currentPage = 1;
    
    [self loadData:self.type];
}


#pragma mark MJRefresh
- (void)loadMoreData {
    if (currentPage < [[[data objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
        currentPage ++;
        NSString *str = [tradeCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[GZNetConnectManager sharedInstance]conURL:[NSString stringWithFormat:@"%@%@?tradeCode=%@&timeLimit=%@&pageNum=%ld",TEST_NETADDRESS,TRANRECORD,str,[NSString stringWithFormat:@"%ld",selecteIndex],currentPage] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            if (bSuccess) {
                [_tableView.footer endRefreshing];
                data = JSON(returnData);
                if ([[[data objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[data objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {

                [lists addObjectsFromArray:[[data objectForKey:@"pageModel"] objectForKey:@"list"]];
                [_tableView reloadData];
                }
            }
        }];

    }
}

- (void)loadNewData {
    currentPage = 1;
    NSString *str = [tradeCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[GZNetConnectManager sharedInstance]conURL:[NSString stringWithFormat:@"%@%@?tradeCode=%@&timeLimit=%@&pageNum=1",TEST_NETADDRESS,TRANRECORD,str,[NSString stringWithFormat:@"%ld",selecteIndex]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            [_tableView.header endRefreshing];
            data = JSON(returnData);
            lists = [[data objectForKey:@"pageModel"] objectForKey:@"list"];
            [_tableView reloadData];
        }
    }];

}


#pragma mark UITableViewDelegate





#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    MoneyCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyCell" owner:self options:nil] lastObject];
    }
    NSDictionary * currentData = lists[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = [currentData objectForKey:@"logRemark"];
    cell.time.text = [currentData objectForKey:@"alLogAddTime"];
    NSString * fuhao = [self getFuhao:[[currentData objectForKey:@"tradeCode"] integerValue]];
    cell.symbol.text = fuhao;
    [cell.price countFrom:[[currentData objectForKey:@"dealMoney"] floatValue] to:[[currentData objectForKey:@"dealMoney"] floatValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.typeTitle.text = @"六个月内";
            timeIndex = 6;
            break;
        case 1:
            self.typeTitle.text = @"全部";
            timeIndex = 0;
            break;
        case 2:
            self.typeTitle.text = @"一个月内";
            timeIndex = 1;
            break;
        case 3:
            self.typeTitle.text = @"三个月内";
            timeIndex = 3;
            break;
            
        default:
            break;
    }
}

- (IBAction)alertAction:(id)sender {
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"六个月内"
                                                otherButtonTitles:@"全部",@"一个月内",@"三个月内", nil];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.titleLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    [alertView show];

}

- (IBAction)tabAction:(id)sender {
    selecteIndex = [sender tag];
    [sender setSelected:YES];
    [selectedButton setSelected:NO];
    selectedButton = sender;
    switch ([sender tag]) {
        case 0:
            tradeCode = self.type == MoneyDetailViewTypeMoney?@"2 6 7 8 11 13 15 17 18 21 28 31 32 33 34 35":@"13 31  11 32";
            break;
        case 2:
            tradeCode = self.type == MoneyDetailViewTypeMoney?@"13 31 34 7 33 17 35":@"13 31";
            break;
        case 1:
            tradeCode = self.type == MoneyDetailViewTypeMoney?@"2 11 32 8 6 15 18 21 28":@"11 32";
            break;
        
        default:
            break;
    }
    [self loadData:self.type];
}


- (NSString*)getFuhao:(NSInteger)index
{
    NSString * fuhao = @"";

    switch (index) {
        case 13:
            fuhao = @"+";
            break;
        case 31:
            fuhao = @"+";
            break;
        case 34:
            fuhao = @"+";
            
            break;
        case 33:
            fuhao = @"+";
            
            break;
        case 35:
            fuhao = @"+";
            
            break;
        case 7:
            fuhao = @"+";
            
            break;
        case 17:
            fuhao = @"+";
            break;
            
            
        case 2:
            fuhao = @"-";
            break;
        case 11:
            fuhao = @"-";
            break;
        case 32:
            fuhao = @"-";
            break;
        case 8:
            fuhao = @"-";
            break;
        case 6:
            fuhao = @"-";
            break;
        case 15:
            fuhao = @"-";
            
            break;
        case 18:
            fuhao = @"-";
            
            break;
        case 21:
            fuhao = @"-";
            
            break;
        case 28:
            fuhao = @"-";
            
            break;
            
        default:
            break;
    }
    return fuhao;
}



@end
