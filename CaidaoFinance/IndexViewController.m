//
//  IndexViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/5.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "IndexViewController.h"
#import "DRPageScrollView.h"
#import "IndexProductTableViewCell.h"
#import "ActivityWebViewController.h"
#import "HelpCenterViewController.h"
#import <FlatUIKit.h>
#import "MyScanViewController.h"
#import <ZBarReaderViewController.h>
#import "QRCodeReaderView.h"
#import "LendViewController.h"
#import "InvestViewController.h"
#import "WantInvestViewController.h"
#import "individualViewController.h"
#import "GZPageControl.h"
#import "LoginViewController.h"
#import "ZBarViewController.h"
#import "GZNetConnectManager.h"
#import <UIImageView+WebCache.h>
#import "InvestCell.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import <EAIntroPage.h>
#import <EAIntroView.h>
#import "IndividualCenterViewController.h"


@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,DRPageScrollViewDelegate,FUIAlertViewDelegate,ZBarReaderDelegate,ProduceCellDelegate,EAIntroDelegate>
{
    GZPageControl * control;
    NSArray * scrollList;
    NSArray * invests;
    ZBarReaderViewController *reader;
    NSInteger listCount;
    FUIAlertView *alertView;
    NSString * symbolStr;
    
    UIView *rootView;
    EAIntroView *intro;

    
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) DRPageScrollView * pageScrollView;
@property (strong, nonatomic) QRCodeReaderView     *cameraView;

- (IBAction)buttonAction:(id)sender;

@end

@implementation IndexViewController

-(instancetype)init
{
    if (self=[super init]) {
        self.pageScrollView = [DRPageScrollView new];
    }
    return self;
}





- (void)getData
{
//    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,INDEX] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
//        [SVProgressHUD dismiss];
        if (bSuccess) {
            NSLog(@"%@",returnData);
            NSDictionary * dic = JSON(returnData);
            scrollList = [dic objectForKey:@"contentListPic"];
            [self setScrollPageView];
        }
    }];
}


- (void)setScrollPageView{
    
    __block NSArray * arr = scrollList;
        for (int i = 0; i < [scrollList count]; i++) {
            [self.pageScrollView addPageWithHandler:^(UIView *pageView) {
                NSDictionary * imgData = [arr objectAtIndex:i];
                UIImageView*pv = [[UIImageView alloc] init];
                [pv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,[imgData objectForKey:@"attach_path"]]] placeholderImage:UIIMAGE(@"index_pic_null")];
                [pageView addSubview:pv];
                pv.layer.cornerRadius = 5;
                pv.layer.masksToBounds = YES;
                [pv mas_makeConstraints:^(MASConstraintMaker*make)
                 {
                     make.left.equalTo(@0);
                     make.right.equalTo(@0);
                     make.top.equalTo(@0);
                     make.bottom.equalTo(@0);
                 }];
            }];
        }
    self.pageScrollView.pageReuseEnabled = YES;
    self.pageScrollView._delegate = self;
    [_contentView insertSubview:self.pageScrollView atIndex:0];
    [self initScrollView];
    [_bannerBg updateConstraintsIfNeeded];
    control.numberOfPages = [scrollList count];
    
}

- (void)loadAllData:(NSInteger)page{
    NSString * url = @"";
//    [SVProgressHUD show];
    url = [NSString stringWithFormat:@"%@%@?borrowCode=%@&isTransfer=%@&annualInterestRateArray=%@&termArrays=%@&minAmountArrays=%@&borrowStatusArrays=%@&pageNum=%ld",TEST_NETADDRESS,INVESTLSIT,@"",@"0",@"all",@"all",@"all",@"all",page];
    [[GZNetConnectManager sharedInstance] conURL:url connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
//        [SVProgressHUD dismiss];
        if(bSuccess)
        {
            NSDictionary * dic = JSON(returnData);
            invests = [dic objectForKey:@"list"];
            listCount = 2;
            [_tableView reloadData];
        }
    }];
}


///
-(void)qscanAction
{
    alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                       message:nil
                                                      delegate:self cancelButtonTitle:@"我的二维码"
                                             otherButtonTitles:@"扫一扫", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
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


#pragma FUIAlertViewDelegate
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController pushViewController:[[MyScanViewController alloc] init] animated:YES];
            break;
        case 1:
        {
            reader = [ZBarReaderViewController new];
            reader.navigationController.navigationBarHidden = NO;
            reader.title = @"二维码";
            reader.wantsFullScreenLayout = NO;
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
//            ZBarViewController*reader =  [[ZBarViewController alloc] init];
            [self.navigationController pushViewController:reader animated:YES];
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
    symbolStr = symbol.data;
    
    [reader.navigationController popViewControllerAnimated:YES];
    
    if (![USER_DEFAULT objectForKey:USER_IS_LOGIN]) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
    else
    {
        
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.navigationController.view;
    if (![USER_DEFAULT objectForKey:USERISOPENAPP]) {
        [self showIntro];
    }
    
    [self initUI];
    [self getData];
    [self loadAllData:1];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)showIntro {
    
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPageOne"];
    page1.bgColor = RGBCOLOR(167, 51, 52);
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPageTwo"];
    page2.bgColor = RGBCOLOR(167, 51, 52);
    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPageThree"];
    page3.bgColor = RGBCOLOR(167, 51, 52);
    intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3]];
    [intro setDelegate:self];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 216, 45)];
    [btn setImage:UIIMAGE(@"intro_skip_button") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    btn.hidden = YES;
    intro.skipButton = btn;
    intro.skipButtonY = 100.f;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.backgroundColor = RGBCOLOR(167, 51, 52);
    [intro showInView:rootView animateDuration:0.3];
    
    [USER_DEFAULT setObject:USERISOPENAPP forKey:USERISOPENAPP];
    
}

- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex {
    switch (pageIndex) {
        case 0:
            intro.skipButton.hidden = YES;
            break;
        case 1:
            intro.skipButton.hidden = YES;
            break;
        case 2:
            intro.skipButton.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)introDidFinish:(EAIntroView *)introView {
    
}


- (void)initUI
{
    self.title = @"财道金融";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //设置rowHight属性为AutomaticDimension
    _tableView.estimatedRowHeight = 120;
    //该值一般选取storyboard上布局完成后的大小
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView setDelaysContentTouches:NO];
    listCount = 0;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setImage:UIIMAGE(@"qscan_button_normal") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(qscanAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
  
}

- (void)initScrollView{
    [_pageScrollView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@5);
         make.top.equalTo(@5);
         make.right.equalTo(@-5);
         if (iPhone5) {
             make.height.equalTo(@128);
         }
         else if (iPhone6)
         {
             make.height.equalTo(@152);
         }
         else if (iPhone6plus)
         {
             make.height.equalTo(@172);
         }
         else if (iPhone4)
         {
             make.height.equalTo(@130);
         }
         else
         {
             make.height.equalTo(@130);
         }
     }];
    
    UIImageView*img = [[UIImageView alloc] initWithImage:UIIMAGE(@"index_scrollpage_bar_bg")];
    [_contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.bottom.equalTo(_pageScrollView.mas_bottom);
         make.left.equalTo(_pageScrollView.mas_left);
         make.width.equalTo(_pageScrollView.mas_width);
     }];
    
    control = [[GZPageControl alloc] initWithFrame:CGRectZero];
    [control setPageIndicatorImage:UIIMAGE(@"index_dot_normal")];
    [control setCurrentPageIndicatorImage:UIIMAGE(@"index_dot_selected")];
    control.numberOfPages = 3;
    control.currentPage = 0;
    [_contentView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.width.equalTo(@200);
         make.height.equalTo(img.mas_height);
         make.centerX.equalTo(img.mas_centerX);
         make.top.equalTo(img.mas_top);
     }];

}


-(void)pageScrollViewDidSelected:(NSInteger)index
{
    NSDictionary * dic = scrollList[index];
    [self.navigationController pushViewController:[[ActivityWebViewController alloc] initWithURL:[NSURL URLWithString:[dic objectForKey:@"external_link_title"]] isActivity:YES] animated:YES];
}

- (void)pageScrollViewDidScrollToPage:(NSInteger)index
{
    [control setCurrentPage:index];
}

#pragma mark IndexProductDelegate
- (void)didSelectedProduct:(NSInteger)productIndex
{
    GZAPP.isFromIndexCell = YES;
    WantInvestViewController * view = [[WantInvestViewController alloc] init];
    view.investData = invests[productIndex];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listCount;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    NSDictionary * currentData = invests[indexPath.row];
    IndexProductTableViewCell*cell = (IndexProductTableViewCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IndexProductTableViewCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.titleLabel.text = [currentData objectForKey:@"borrow_title"];
    cell.rate.text = [NSString stringWithFormat:@"%@%@",[[currentData objectForKey:@"annual_interest_rate"] stringValue],@"%"];
    [cell.price countFrom:[[currentData objectForKey:@"borrow_sum"] floatValue] to:[[currentData objectForKey:@"borrow_sum"] floatValue]];
    cell.time.text = [NSString stringWithFormat:@"%@%@",[currentData objectForKey:@"borrow_time_limit"],[[currentData objectForKey:@"is_day"] integerValue] == 0?@"天":@"个月"];
    if ([currentData objectForKey:@"reward_rate"]) {
        CGFloat rate = [[currentData objectForKey:@"annual_interest_rate"] floatValue] - [[currentData objectForKey:@"reward_rate"] floatValue];
        cell.rate.text = [NSString stringWithFormat:@"%.2f%@+%@%@",rate,@"%",[currentData objectForKey:@"reward_rate"],@"%"];
        cell.rate.textColor = RGBCOLOR(251, 176, 68);
        cell.rewardLabel.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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

- (IBAction)buttonAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[[InvestViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[LendViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[HelpCenterViewController alloc] init] animated:YES];
            break;
        case 3:
            if ([USER_DEFAULT objectForKey:USER_IS_LOGIN]) {
                [self.navigationController pushViewController:[[IndividualCenterViewController alloc] init] animated:YES];
            }
            else
            {
                [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];

            }
            break;
            
        default:
            break;
    }
}
@end
