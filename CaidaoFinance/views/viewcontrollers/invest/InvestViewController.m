//
//  InvestViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InvestViewController.h"
#import "InvestCell.h"
#import "SearchView.h"
#import "WantInvestViewController.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>
#import "SVProgressHUD.h"

@interface InvestViewController ()<UITableViewDataSource,UITableViewDelegate,SearchViewDelegate,InvestCellDelegate>
{
    NSInteger segmentSelectedIndex;
    UIButton * lastSelectedSegment;
    SearchView * searchView;
    UIView*searchBg;
    NSMutableArray * invests;
    NSDictionary * searchDatas;
    
    NSInteger currentPage;
    
    NSArray * nianhuaArr;
    NSArray * jiekuanArr;
    NSArray * qitouArr;
    NSArray * toubiaoArr;
}

@end

@implementation InvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 1;
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

-(void)setup{
    [self initUI];
    [self setNavigation];
}

- (void)loadAllData:(NSInteger)page{
    NSString * url = @"";
    switch (segmentSelectedIndex) {
        case 0:
            url = [NSString stringWithFormat:@"%@%@?borrowCode=%@&isTransfer=%@&annualInterestRateArray=%@&termArrays=%@&minAmountArrays=%@&borrowStatusArrays=%@&pageNum=%ld",TEST_NETADDRESS,INVESTLSIT,@"",@"0",@"all",@"all",@"all",@"all",page];
            break;
        case 1:
            url = [NSString stringWithFormat:@"%@%@?borrowCode=%@&isTransfer=%@&annualInterestRateArray=%@&termArrays=%@&minAmountArrays=%@&borrowStatusArrays=%@&pageNum=%ld",TEST_NETADDRESS,INVESTLSIT,@"TRANSFER",@"1",@"all",@"all",@"all",@"all",page];
            break;
        default:
            break;
    }
    if (page == 1) {
        [SVProgressHUD show];
    }
    [[GZNetConnectManager sharedInstance] conURL:url connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if(bSuccess)
        {
            NSDictionary * dic = JSON(returnData);
            if (page > 1) {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [invests addObjectsFromArray:[dic objectForKey:@"list"]];
                }
            }
            else
            {
                invests = [dic objectForKey:@"list"];
            }
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            [SVProgressHUD dismiss];
            [_tableView reloadData];
        }
    }];
}

- (void)loadSearchAllData:(NSInteger)index data:(NSDictionary*)data
{
    NSString * type = segmentSelectedIndex == 0?@"":@"TRANSFER";
    NSInteger indexOne = [[data objectForKey:@"one"] integerValue];
    NSInteger indexTwo = [[data objectForKey:@"two"] integerValue];
    NSInteger indexThree = [[data objectForKey:@"three"] integerValue];
    NSInteger indexFour = [[data objectForKey:@"four"] integerValue];
    NSString * valueOne = nianhuaArr[indexOne];
    NSString * valueTwo = jiekuanArr[indexTwo];
    NSString * valueThree = qitouArr[indexThree];
    NSString * valueFour = toubiaoArr[indexFour];
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowCode=%@&annualInterestRateArray=%@&termArrays=%@&minAmountArrays=%@&borrowStatusArrays=%@&pageNum=%ld",TEST_NETADDRESS,INVESTLSIT,type,valueOne,valueTwo,valueThree,valueFour,index] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (index > 1) {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [invests addObjectsFromArray:[dic objectForKey:@"list"]];
                }
            }
            else
            {
                invests = [dic objectForKey:@"list"];
            }
            [self.tableView.header endRefreshing];
            [SVProgressHUD dismiss];
            [_tableView reloadData];

        }
    }];
}

-(void)initUI{
    
    self.title = @"投资";
    nianhuaArr = @[@"all",@"INV_12",@"INV_12_15",@"INV_15_18",@"INV_18"];
    jiekuanArr = @[@"all",@"TERM_30",@"TERM_30_60",@"TERM_60_90",@"TERM_90_120",@"TERM_120"];
    qitouArr = @[@"all",@"MIN_1000_5000",@"MIN_5000_10000",@"MIN_10000"];
    toubiaoArr = @[@"all",@"2",@"4",@"5",@"6"];
    
    [_leftSegment setSelected:YES];
    lastSelectedSegment = _leftSegment;
    [_leftSegment setTintColor:[UIColor clearColor]];
    [_rightSegment setTintColor:[UIColor clearColor]];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
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
    [self loadAllData:currentPage];
    
}

- (void)loadNewData{
    //刷新
    currentPage = 1;
    [self loadAllData:currentPage];
    
}

- (void)loadMoreData{
    //加载更多
    currentPage ++;
    [self loadAllData:currentPage];
    
    
}

-(void)setNavigation{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setImage:UIIMAGE(@"search_button_normal") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
}


#pragma mark SearchViewDelegate
- (void)didSearch:(NSDictionary *)searchData
{
    [self closeSearchView];
    searchDatas = searchData;
    [self loadSearchAllData:1 data:searchData];
}

- (void)closeSearchView {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@-380);
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            [searchView layoutIfNeeded];
            searchBg.alpha = 0;
            
        } completion:^(BOOL finished) {
            [searchView removeFromSuperview];
            searchView = nil;
            [searchBg removeFromSuperview];
            searchBg = nil;
        }];
    });

}


#pragma mark InvestCellDelegate
-(void)didInvest:(NSInteger)index type:(InvestType)type{
    [self closeSearchView];
    WantInvestViewController*view = [[WantInvestViewController alloc] initwithInvestType:segmentSelectedIndex==0?WantInvestTypeInvest:WantInvestTypeMakeOver];
    view.investData = invests[index];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self closeSearchView];
    WantInvestViewController*view = [[WantInvestViewController alloc] initwithInvestType:segmentSelectedIndex==0?WantInvestTypeInvest:WantInvestTypeMakeOver];
    view.investData = invests[indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    NSDictionary * currentData = invests[indexPath.row];
    InvestCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InvestCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [currentData objectForKey:@"borrow_title"];
    cell.rate.text = [NSString stringWithFormat:@"%@%@",[[currentData objectForKey:@"annual_interest_rate"] stringValue],@"%"];
//    cell.rate.text = [NSString stringWithFormat:@"%@%@",[[currentData objectForKey:@"annualRate"] stringValue],@"%"];
    [cell.price countFrom:[[currentData objectForKey:@"borrow_sum"] floatValue] to:[[currentData objectForKey:@"borrow_sum"] floatValue]];
    cell.time.text = [NSString stringWithFormat:@"%@%@",[currentData objectForKey:@"borrow_time_limit"],[[currentData objectForKey:@"is_day"] integerValue] == 1?@"天":@"个月"];
    cell.progressValue.text = [NSString stringWithFormat:@"%@%@",[currentData objectForKey:@"tenderProgressRate"],@"%"];
    [cell setProgress:[[currentData objectForKey:@"tenderProgressRate"] floatValue]/100];
    cell.type = segmentSelectedIndex == 0?InvestTypeInvest:InvestTypeTransfer;
    cell.rewardLabel.hidden = YES;
    if ([currentData objectForKey:@"reward_rate"]) {
        CGFloat rate = [[currentData objectForKey:@"annual_interest_rate"] floatValue] - [[currentData objectForKey:@"reward_rate"] floatValue];
        cell.rate.text = [NSString stringWithFormat:@"%.2f%@+%@%@",rate,@"%",[currentData objectForKey:@"reward_rate"],@"%"];
        cell.rate.textColor = RGBCOLOR(251, 176, 68);
        cell.rewardLabel.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [invests count];
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

-(void)searchAction{
    [self showSearch];
}

- (void)tapSearch:(UITapGestureRecognizer*)gesture
{
    [self closeSearchView];
}


-(void)showSearch{
    if (!searchView) {
        
        searchBg = [[UIView alloc] init];
        searchBg.backgroundColor = RGBAlpha(0, 0, 0, 0.7);
        searchBg.alpha = 0;
        [[[UIApplication sharedApplication] keyWindow] addSubview:searchBg];
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearch:)];
        [searchBg addGestureRecognizer:gesture];
        [searchBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);

        }];

        
        searchView = [[SearchView alloc] initWithFrame:CGRectZero];
        searchView.backgroundColor = RGBCOLOR(145,34,37);
        searchView.delegate = self;
        [[[UIApplication sharedApplication] keyWindow] addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker*make)
         {
             make.left.equalTo(@0);
             make.top.equalTo(@-380);
             make.right.equalTo(@0);
             if (iPhone6) {
                 make.height.equalTo(@315);
             }
             else if (iPhone5)
             {
                 make.height.equalTo(@365);
             }
             else
             {
                 make.height.equalTo(@365);
             }
         }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            [searchView layoutIfNeeded];
            searchBg.alpha = 1;
        }];
    });
    
}

#pragma mark SearchViewDelegate
-(void)didCancel{
    
}

- (IBAction)segmentAction:(id)sender {
    segmentSelectedIndex = [sender tag];
    if (lastSelectedSegment) {
        [lastSelectedSegment setSelected:NO];
    }
    [sender setSelected:YES];
    lastSelectedSegment = sender;
    [self loadAllData:segmentSelectedIndex];
}
@end
