//
//  PersonInfoViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/24.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "VertiNameViewController.h"
#import "MemberViewController.h"
#import "BindCardViewController.h"
#import "NamePreviewViewController.h"
#import "BindCardPreviewViewController.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"

@interface PersonInfoViewController ()
{
    NSDictionary * persondata;
    
    NSDictionary * realNameInfo;
    
    NSDictionary * bindCardInfo;
}


@end

@implementation PersonInfoViewController

- (id)initWithPersonData:(NSDictionary *)data {
    if (self) {
        persondata = data;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadData];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,ACCOUNTINDEX] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            persondata = JSON(returnData);
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [_scrollView setDelaysContentTouches:NO];
    NSString * tel = [USER_DEFAULT objectForKey:USER_TEL] == nil?@"":[USER_DEFAULT objectForKey:USER_TEL];
    NSString * left = [tel substringWithRange:NSMakeRange(0, 3)];
    NSString * right = [tel substringWithRange:NSMakeRange(8, 3)];
    _tel.text = [NSString stringWithFormat:@"%@***%@",left,right];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,REALNAMEINFO] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            realNameInfo = [JSON(returnData) objectForKey:@"user"];
            [self checkRealName];
        }
    }];
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,BINDBANKINFO] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            bindCardInfo = JSON(returnData);
            [self checkBindCard];
        }
    }];
    
}


- (void)checkRealName {
    NSLog(@"realname%@",[[persondata objectForKey:@"user"] objectForKey:@"userRealname"]);
    if([[[persondata objectForKey:@"user"] objectForKey:@"userRealname"] integerValue] == 2) {
        [USER_DEFAULT setObject:USER_IS_VERTY forKey:USER_IS_VERTY];
    }
    self.yzlabel.text = [USER_DEFAULT objectForKey:USER_IS_VERTY] == nil?@"未验证":@"已验证";
}


- (void)checkBindCard {
    if([bindCardInfo objectForKey:@"userBank"] != [NSNull null]) {
        [USER_DEFAULT setObject:USER_IS_BIND forKey:USER_IS_BIND];
    }
    self.bindingLabel.text = [USER_DEFAULT objectForKey:USER_IS_BIND] == nil?@"未绑定":@"已绑定";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cellAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[USER_DEFAULT objectForKey:USER_IS_VERTY] == nil?[VertiNameViewController new]:[[NamePreviewViewController alloc] initWithNameData:realNameInfo] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[MemberViewController alloc] initWithIndividualData:persondata] animated:YES];

            break;
        case 2:
            [self.navigationController pushViewController:[USER_DEFAULT objectForKey:USER_IS_BIND] == nil?[BindCardViewController new]:[[BindCardPreviewViewController alloc] initWithBinbankData:persondata] animated:YES];

            break;
        default:
            break;
    }
}
@end
