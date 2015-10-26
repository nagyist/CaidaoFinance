//
//  NamePreviewViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "NamePreviewViewController.h"

@interface NamePreviewViewController () {
    NSDictionary * realNameData;
}

@end

@implementation NamePreviewViewController

- (id)initWithNameData:(NSDictionary *)nameData {
    if (self) {
        realNameData = nameData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.name.text = [[realNameData objectForKey:@"user"] objectForKey:@"userRealname"];
    self.cardNum.text = [[realNameData objectForKey:@"user"] objectForKey:@"cardNumber"];
    self.area.text = [NSString stringWithFormat:@"%@%@",[[realNameData objectForKey:@"user"] objectForKey:@"userCity"],[[realNameData objectForKey:@"user"] objectForKey:@"userArea"]];
    self.address.text = [[realNameData objectForKey:@"user"] objectForKey:@"userAddress"];

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
