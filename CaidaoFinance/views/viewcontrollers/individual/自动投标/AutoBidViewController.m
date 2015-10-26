//
//  AutoBidViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "AutoBidViewController.h"
#import "RuleViewController.h"
#import "GZMenuListView.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "SVProgressHUD.h"

@interface AutoBidViewController ()<GZMenuListViewDataSource,GZMenuListViewDelegate,FUIAlertViewDelegate>
{
    NSArray * dropData;
    NSArray * dropDataTwo;
    NSArray * dropDataThree;
    NSArray * dropDataFour;
    
    
    NSArray * aprs;
    NSArray * periods;
    
    
}

@property (nonatomic,strong)GZMenuListView * menuView;
@property (nonatomic,strong)GZMenuListView * menuViewTwo;
@property (nonatomic,strong)GZMenuListView * menuViewThree;
@property (nonatomic,strong)GZMenuListView * menuViewFour;

@end

@implementation AutoBidViewController

- (void)viewDidAppear:(BOOL)animated{
    [self.contentView insertSubview:_menuView aboveSubview:_viewOne];
    [self.contentView insertSubview:_menuViewTwo aboveSubview:_viewTwo];
    [self.contentView insertSubview:_menuViewThree aboveSubview:_viewThree];
    [self.contentView insertSubview:_menuViewFour aboveSubview:_viewFour];

    [self.menuView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewOne.mas_left);
         make.width.equalTo(_viewOne.mas_width);
         make.top.equalTo(_viewOne.mas_top);
         make.height.equalTo(_viewOne.mas_height);
     }];
    
    [self.menuViewTwo mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewTwo.mas_left);
         make.width.equalTo(_viewTwo.mas_width);
         make.centerY.equalTo(_viewTwo.mas_centerY);
         make.height.equalTo(_viewOne.mas_height);
     }];
    
    [self.menuViewThree mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewThree.mas_left);
         make.width.equalTo(_viewThree.mas_width);
         make.centerY.equalTo(_viewThree.mas_centerY);
         make.height.equalTo(_viewOne.mas_height);
     }];
    
    [self.menuViewFour mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(_viewFour.mas_left);
         make.width.equalTo(_viewFour.mas_width);
         make.centerY.equalTo(_viewFour.mas_centerY);
         make.height.equalTo(_viewOne.mas_height);
     }];
    
    [_scrollView setContentSize:CGSizeMake(0, 570)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自动投标";
    [_closeButton setTintColor:[UIColor clearColor]];
    [_scrollView setDelaysContentTouches:NO];
    dropData = @[@"默认",@"1%-6%",@"7%-12%",@"13%-24%"];
    dropDataTwo = @[@"不限",@"1-15",@"16-30",@"30天以上"];
    dropDataThree = @[@"否",@"是"];
    dropDataFour = @[@"按期等额本息",@"到期一次性还本付息",@"按期付息到期一次性还本"];
    
    
    aprs = @[@"1~24",@"1~6",@"7~12",@"13~24"];
    periods = @[@"0",@"1~15",@"16~30",@"31"];
    self.menuView = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.menuView.placeStr = @"默认";
    self.menuView.tag = 0;
    self.menuView.backgroundColor = [UIColor clearColor];
    self.menuView.menuSuperView = self.contentView;
    
    self.menuViewTwo = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuViewTwo.delegate = self;
    self.menuViewTwo.dataSource = self;
    self.menuViewTwo.placeStr = @"不限";
    self.menuViewTwo.tag = 1;
    self.menuViewTwo.backgroundColor = [UIColor clearColor];
    self.menuViewTwo.menuSuperView = self.contentView;
    
    self.menuViewThree = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuViewThree.delegate = self;
    self.menuViewThree.dataSource = self;
    self.menuViewThree.placeStr = @"否";
    self.menuViewThree.tag = 2;
    self.menuViewThree.backgroundColor = [UIColor clearColor];
    self.menuViewThree.menuSuperView = self.contentView;
    
    self.menuViewFour = [[GZMenuListView alloc] initWithFrame:CGRectZero];
    self.menuViewFour.delegate = self;
    self.menuViewFour.dataSource = self;
    self.menuViewFour.placeStr = @"默认";
    self.menuViewFour.tag = 3;
    self.menuViewFour.backgroundColor = [UIColor clearColor];
    self.menuViewFour.menuSuperView = self.contentView;
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    ///检查自动投标状态
    [self.closeButton setUserInteractionEnabled:NO];

    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,AUTOTENDERSTATUS] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            [self.closeButton setUserInteractionEnabled:YES];

            NSInteger statu = [[dic objectForKey:@"rulesStatus"] integerValue];
            switch (statu) {
                case 0:
                    //未启用
                    [self.closeButton setSelected:YES];
                    break;
                case 1:
                    //已开启
                    [self.closeButton setSelected:NO];
                    break;
                case 2:
                    //已关闭
                    [self.closeButton setSelected:YES];
                    break;
                case 3:
                    //延迟生效中
                    [self.closeButton setEnabled:NO];
                    break;
                    
                default:
                    break;
            }
        }
    }];
}

-(NSString*)stringFromIndex:(NSInteger)index view:(GZMenuListView *)menuView
{
    switch (menuView.tag) {
        case 0:
            return [dropData objectAtIndex:index];
            break;
        case 1:
            return [dropDataTwo objectAtIndex:index];
            break;
        case 2:
            return [dropDataThree objectAtIndex:index];
            break;
        case 3:
            return [dropDataFour objectAtIndex:index];
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)numberOfRowsOfview:(GZMenuListView *)menuView
{
    switch (menuView.tag) {
        case 0:
            return [dropData count];
            break;
        case 1:
            return [dropDataTwo count];
            break;
        case 2:
            return [dropDataThree count];
            break;
        case 3:
            return [dropDataFour count];
            break;
            
        default:
            break;
    }
    return 0;
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

#pragma mark FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        switch (self.closeButton.isSelected) {
            case 0:
                [self.closeButton setSelected:!self.closeButton.isSelected];
                break;
            case 1:
                [self.closeButton setSelected:!self.closeButton.isSelected];
                break;
                
            default:
                break;
        }
    }
}

- (IBAction)closeAction:(id)sender {
    NSLog(@"%@",[USER_DEFAULT objectForKey:USER_AUTH]);
    BOOL auth = [[USER_DEFAULT objectForKey:USER_AUTH] boolValue];
    if (!auth) {
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"此账号未授权，请到网页端授权后投资"
                                                              message:nil
                                                             delegate:self cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
        alertView.titleLabel.textColor = [UIColor grayColor];
        alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
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
        return;
    }
    if (![self check]) {
        return;
    }
    
    if (self.closeButton) {
        //开启
        [SVProgressHUD show];
//        [self.closeButton setEnabled:NO];
        NSString * rate = [self getRate:self.menuView.selectedIndex];
        NSString * peroid = [periods objectAtIndex:self.menuViewTwo.selectedIndex];
        NSInteger repayType = self.menuViewFour.selectedIndex;
        NSInteger state = !self.closeButton.isSelected;
        NSInteger isOverdue = self.menuViewThree.selectedIndex;
        
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tenderMoney=%@&apr=%@&period=%@&repayTypeCheckBox=%ld&Stat=%ld&isOverdue=%ld",TEST_NETADDRESS,AUTOTENDER,self.price.text,rate,peroid,repayType,state,isOverdue] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            if (bSuccess) {
                NSDictionary * dic = JSON(returnData);
                if ([[dic objectForKey:@"code"] isEqualToString:@"203"]) {
                    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,MODIFYAUTOTENDER] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                        if (bSuccess) {
                            NSDictionary * response = JSON(returnData);
                            [SVProgressHUD dismiss];
                            [self showSuccess:[response objectForKey:@"msg"]];
                        }
                    }];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                }
            }
        }];
    }
}


- (NSString*)getRate:(NSInteger)index {
    NSString*rate = @"";
    switch (index) {
        case 0:
            rate = @"1~24";
            break;
        case 1:
            rate = @"1~6";
            break;
        case 2:
            rate = @"7~12";
            break;
        case 3:
            rate = @"13~24";
            break;
            
        default:
            break;
    }
    return rate;
}

- (BOOL)check {
    if (self.closeButton.isSelected) {
        if ([_price.text integerValue] >= 100 && [_price.text integerValue] < 50000 && [_price.text integerValue]%100 == 0) {
            return YES;
        }
        else
        {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"金额输入不符合条件，请重新输入" alignment:CTCommonUtilsShowBottom];
        }
    }
    else if (!self.closeButton.isSelected)
    {
        return YES;
    }
    return NO;
    
}

- (void)showSuccess:(NSString*)msg {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:msg
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    alertView.titleLabel.textColor = [UIColor grayColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.tag = 1;
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    [alertView show];

}

- (IBAction)ruleAction:(id)sender {
    [self.navigationController pushViewController:[RuleViewController new] animated:YES];
}
@end
