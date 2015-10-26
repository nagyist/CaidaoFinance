//
//  MessageViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InsMessageViewController.h"
#import "MsgListViewController.h"
#import "FriendsViewController.h"
#import "GZNetConnectManager.h"

@interface InsMessageViewController ()

@end

@implementation InsMessageViewController

- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"站内信息";
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,UNREADMESCOUNT] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            [self setCountNumber:[[dic objectForKey:@"msgCount"] integerValue]];
        }
    }];
}

- (void)setCountNumber:(NSInteger)count {
    if (count > 0) {
        self.count.hidden = NO;
        self.red.hidden = NO;
    }
    else if (count == 0)
    {
        self.count.hidden = YES;
        self.red.hidden = YES;
    }
    self.count.text = [NSString stringWithFormat:@"%ld",count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cellAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[MsgListViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[FriendsViewController new] animated:YES];
            break;
        default:
            break;
    }
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
