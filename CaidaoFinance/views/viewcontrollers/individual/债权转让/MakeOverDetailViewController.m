//
//  MakeOverDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MakeOverDetailViewController.h"
#import "MakeOverRecordListViewController.h"
#import "GZNetConnectManager.h"
#import "WebContractsViewController.h"
#import "SVProgressHUD.h"

@interface MakeOverDetailViewController ()<ContractViewDelegate> {
    NSDictionary * detailData;
    NSInteger pageNum;
    NSDictionary * makeoverDetailData;
    
    NSDictionary * zhuanrang;
    NSDictionary * jujianhetong;
    NSDictionary * dianzixieyi;
    NSDictionary * zhuanrangqingdan;

}

@end

@implementation MakeOverDetailViewController

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (id)initWithMakeoverData:(NSDictionary *)data {
    if (self) {
        detailData = data;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    zhuanrang = @{@"name":@"债权转让合同",@"url":@"http://www.186886.com/app/appTransfereecontract.do?borrowId=306"};
    jujianhetong = @{@"name":@"财道金融居间服务合同",@"url":@"http://www.186886.com/app/appFeeAgreement.do?tendeId=24&borrowId=306"};
    dianzixieyi = @{@"name":@"财道金融电子协议",@"url":@"http://www.186886.com/app/appBorrowAgreement.do?borrowId=306"};
    zhuanrangqingdan = @{@"name":@"债权转让人清单",@"url":@"http://www.186886.com/app/appTransfereeUserList.do?tenderId=411&borrowId=329"};
    self.title = @"债权转让详情";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];

    [_scrollView setDelaysContentTouches:NO];
    _progressBar.type = YLProgressBarTypeRounded;
    [_progressBar setProgressTintColors:@[RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198)]];
    [_progressBar setTrackTintColor:[UIColor clearColor]];
    [_progressBar setIndicatorTextDisplayMode:YLProgressBarIndicatorTextDisplayModeNone];
    _progressBar.behavior                 = YLProgressBarBehaviorIndeterminate;
//    [_progressBar setProgress:0.4 animated:YES];
    [_progressBar setHideGloss:YES];
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    self.contractView.delegate = self;
    [self.contractView showContractList:@[zhuanrang,jujianhetong,dianzixieyi]];

    [self loadData];
//    _label2.lineColor = RGBCOLOR(28, 121, 198);
//    _label3.lineColor = RGBCOLOR(28, 121, 198);
//    _label2.lineType = LineTypeDown;
//    _label3.lineType = LineTypeDown;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?borrowId=%@",TEST_NETADDRESS,TRANSFERDETAIL,[detailData objectForKey:@"id"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            makeoverDetailData = JSON(returnData);
            [self setData];
        }
    }];
}

- (void)setData {
    self.code.text = [detailData objectForKey:@"borrowTitle"];
    [self.zongjia countFrom:[[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"borrowSum"] floatValue] to:[[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"borrowSum"] floatValue]];
    [self.yishoujine countFrom:[[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"tenderSum"] floatValue] to:[[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"tenderSum"] floatValue]];
    self.rate.text = [NSString stringWithFormat:@"%@%@",[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"annualInterestRate"],@"%"];
    self.daoqiri.text = [[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"endTime"];
    self.endtime.text = self.daoqiri.text;
    self.fangshi.text = [self getType:[[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"repaymentStyle"] integerValue]];
    self.oldcode.text = [makeoverDetailData objectForKey:@"formerBorrowTitle"];
    self.starttime.text = [[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"publishDatetime"];
    CGFloat tender = [[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"tenderSum"] floatValue] / [[[makeoverDetailData objectForKey:@"borrow"] objectForKey:@"borrowSum"] floatValue] * 100;
    
//    self.progressRate.text = [NSString stringWithFormat:@"%.2f%@",tender,@"%"];
    self.progressRate.text = [NSString stringWithFormat:@"%.2f%@",[[detailData objectForKey:@"transferFee"] floatValue],@"%"];
    [self.progressBar setProgress:[[detailData objectForKey:@"transferFee"] floatValue]/100 animated:YES];
}

#pragma mark ContractDelegate
- (void)didSelectedContract:(NSInteger)index {
    NSArray * arr = @[zhuanrang,jujianhetong,dianzixieyi];
    [self.navigationController pushViewController:[[WebContractsViewController alloc] initWithURL:[arr objectAtIndex:index]] animated:YES];
}


- (NSString*)getType:(NSInteger)index {
    NSString * type = @"";
    switch (index) {
        case 0:
            type = @"按期等额本息";
            break;
        case 1:
            type = @"到期一次性还本付息";
            break;
        case 2:
            type = @"按期付息到期一次性还本";
            break;
            
        default:
            break;
    }
    return type;
    
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

- (IBAction)detailAction:(id)sender {
    MakeOverRecordListViewController*view = [[MakeOverRecordListViewController alloc] initWithRecordData:makeoverDetailData];
    [self.navigationController pushViewController:view animated:YES];
    
}
@end
