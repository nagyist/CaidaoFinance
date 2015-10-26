//
//  MyScanViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/8.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MyScanViewController.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"
#import "QRCodeGenerator.h"

@interface MyScanViewController () {
    NSDictionary * myRecommedData;
    NSString * qscanStr;
}

@end

@implementation MyScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,RECOMMED] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            myRecommedData = JSON(returnData);
            qscanStr = [NSString stringWithFormat:@"%@%@%@",TEST_NETADDRESS,@"toRegister.do?c=",[[myRecommedData objectForKey:@"user"] objectForKey:@"inviteCode"]];
            [self setData];
        }
    }];
}

- (void)setData {
    self.img.image = [QRCodeGenerator qrImageForString:qscanStr imageSize:100.0];
    self.mycode.text = [[myRecommedData objectForKey:@"user"] objectForKey:@"inviteCode"];
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
