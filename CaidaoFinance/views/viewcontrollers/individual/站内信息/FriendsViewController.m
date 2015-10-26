//
//  FriendsViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
#import <FlatUIKit.h>
#import <ZBarReaderViewController.h>
#import "SendMailViewController.h"
#import "AddFriendViewController.h"
#import "GZNetConnectManager.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>


@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,FriendCellDelegate,FUIAlertViewDelegate,ZBarReaderDelegate>
{
    NSInteger pageNum;
    NSMutableArray * friends;
    ZBarReaderViewController *reader;
}

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友管理";
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 50)];
    [button setTitle:@"添加好友" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
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

- (void)loadData:(NSInteger)page {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?pageNum=%ld",TEST_NETADDRESS,MYFRIENDS,page] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (page == 1) {
                [_tableView.header endRefreshing];
                friends = [JSON(returnData) objectForKey:@"list"];
                [_tableView reloadData];
            }
            else
            {
                if ([[[dic objectForKey:@"pageModel"] objectForKey:@"currentPage"] integerValue] != [[[dic objectForKey:@"pageModel"] objectForKey:@"totalPage"] integerValue]) {
                    [friends addObjectsFromArray:[JSON(returnData) objectForKey:@"list"]];
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //昵称
            AddFriendViewController*view = [[AddFriendViewController alloc] init];
            view.type = AddFriendTypeName;
            [self.navigationController pushViewController:view animated:YES];
        }
        break;
        case 1:
        {
            reader = [ZBarReaderViewController new];
            reader.navigationController.navigationBarHidden = NO;
            reader.title = @"二维码";
            reader.readerDelegate = self;
            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            reader.showsZBarControls = NO;
            ZBarImageScanner *scanner = reader.scanner;
            // TODO: (optional) additional reader configuration here
            UIView*view = [[[NSBundle mainBundle] loadNibNamed:@"ZDView" owner:self options:nil] lastObject];
            [reader.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker*make)
             {
                 make.left.equalTo(@0);
                 make.right.equalTo(@0);
                 make.top.equalTo(@64);
                 make.bottom.equalTo(@0);
             }];
            // EXAMPLE: disable rarely used I2/5 to improve performance
            [scanner setSymbology: ZBAR_I25
                           config: ZBAR_CFG_ENABLE
                               to: 0];
            //            [self setOverlayPickerView:reader];
            [self.navigationController pushViewController:reader animated:YES];
        }

            break;
        case 2:
        {
            AddFriendViewController*view = [[AddFriendViewController alloc] init];
            view.type = AddFriendTypeCode;
            [self.navigationController pushViewController:view animated:YES];
        }
            
            break;
        case 3:
        {
            AddFriendViewController*view = [[AddFriendViewController alloc] init];
            view.type = AddFriendTypeTel;
            [self.navigationController pushViewController:view animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    NSLog(@"%@",symbol.data);
    
    [reader.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[AddFriendViewController alloc] initWithQscanData:symbol.data] animated:YES];
    
    
}

- (void)addAction
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"昵称"
                                                otherButtonTitles:@"扫一扫",@"推荐码",@"手机号",nil];
    alertView.titleLabel.textColor = [UIColor grayColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
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

#pragma mark FriendsCellDelegate
- (void)sendMail:(NSInteger)index
{
    [self.navigationController pushViewController:[[SendMailViewController alloc] initWithFriendData:friends[index]] animated:YES];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    FriendsCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary * currentData = friends[indexPath.row];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendsCell" owner:self options:nil] lastObject];
    }
    cell.tag  = indexPath.row;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,[currentData objectForKey:@"avatarImg"]]] placeholderImage:UIIMAGE(@"avatar_icon_default")];
    cell.name.text = [currentData objectForKey:@"userAccount"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
