//
//  InsMessageDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InsMessageDetailViewController.h"
#import "GZNetConnectManager.h"

@interface InsMessageDetailViewController () {
    NSDictionary * detailData;
}

@end

@implementation InsMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"站内信息";
    [self setData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setData {
    NSString * user = [[detailData objectForKey:@"sendUserAccount"] isEqualToString:@"EastAdmin"]?@"财道金融":[detailData objectForKey:@"sendUserAccount"];
    NSDictionary * timedata = [detailData objectForKey:@"messageSendDateTime"];
    NSString * time = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld 来自\"%@\"",[[timedata objectForKey:@"year"] integerValue],[[timedata objectForKey:@"month"] integerValue],[[timedata objectForKey:@"day"] integerValue],[[timedata objectForKey:@"hours"] integerValue],[[timedata objectForKey:@"minutes"] integerValue],[[timedata objectForKey:@"seconds"] integerValue],user];
    self.msgTitle.text = [detailData objectForKey:@"messageTitle"];
    self.text.text = [detailData objectForKey:@"messageContent"];
    self.time.text = time;
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?msgId=%@",TEST_NETADDRESS,MESSAGECONTENT,[[detailData objectForKey:@"id"] stringValue]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        
    }];
}

- (id)initWithDetailData:(NSDictionary *)data {
    if (self) {
        detailData = data;
        
    }
    return self;
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
