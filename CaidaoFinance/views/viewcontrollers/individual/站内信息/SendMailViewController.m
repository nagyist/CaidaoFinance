//
//  SendMailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "SendMailViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"

@interface SendMailViewController ()<FUIAlertViewDelegate>
{
    NSDictionary * fData;
}
@end

@implementation SendMailViewController

- (id)initWithFriendData:(NSDictionary *)friendData {
    if (self) {
        fData = friendData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私信";
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
    // Do any additional setup after loading the view from its nib.
}


- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction{
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?u=%@&content=%@",TEST_NETADDRESS,SENDMSG,[[fData objectForKey:@"friendsUserId"] stringValue],self.text.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            if ([returnData isEqualToString:@"200"]) {
                FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"发送信息成功"
                                                                      message:nil
                                                                     delegate:self cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
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
        }
    }];
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
