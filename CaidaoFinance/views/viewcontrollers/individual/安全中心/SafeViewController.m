//
//  SafeViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "SafeViewController.h"
#import "ModifyTelViewController.h"
#import "ModifyLoginPassViewController.h"
#import "ModifyTradPassViewController.h"
#import "ModifyTouchViewController.h"

@interface SafeViewController ()

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全中心";
    [_scrollView setDelaysContentTouches:NO];
    NSString * tel = [USER_DEFAULT objectForKey:USER_TEL];
    NSString * left = [tel substringWithRange:NSMakeRange(0, 3)];
    NSString * right = [tel substringWithRange:NSMakeRange(8, 3)];

    self.tel.text = [NSString stringWithFormat:@"%@***%@",left,right];
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

- (IBAction)switchAction:(id)sender {
    if (self.switchButton.isSelected) {
        [USER_DEFAULT setObject:OPEN_TOUCH_PASS forKey:OPEN_TOUCH_PASS];
    }
    else {
        [USER_DEFAULT setObject:nil forKey:OPEN_TOUCH_PASS];
    }
    [self.switchButton setSelected:!self.switchButton.isSelected];
}

- (IBAction)modifyAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[ModifyTelViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[ModifyLoginPassViewController new] animated:YES];

            break;
        case 2:
            [self.navigationController pushViewController:[ModifyTradPassViewController new] animated:YES];

            break;
        case 3:
            [self.navigationController pushViewController:[ModifyTouchViewController new] animated:YES];

            break;
            
        default:
            break;
    }
}
@end
