//
//  CreditViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CreditViewController.h"

@interface CreditViewController (){
    NSDictionary * detailData;

}

@end

@implementation CreditViewController

- (id)initWithDetailData:(NSDictionary *)data
{
    if (self) {
        detailData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bishu.text =  [[detailData objectForKey:@"borrowNumber"] stringValue];
    self.cishu.text =  [[detailData objectForKey:@"repayOverdueCount"] stringValue];
    self.jieru.text =  [[detailData objectForKey:@"borrowSuccessSum"] stringValue];
    self.yuqi.text =  [detailData objectForKey:@"currentOverdue"];
    self.zonge.text =  [NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:@"%.2f",[[detailData objectForKey:@"borrowSum"] floatValue]]];
    self.huan.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:@"%.2f",[[detailData objectForKey:@"currentOverdueAmount"] floatValue]]];
    // Do any additional setup after loading the view from its nib.
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
