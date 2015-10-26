//
//  SettingViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/24.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedViewController.h"
#import "AboutUsViewController.h"
#import "APService.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
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
    [self.switchButton setSelected:!self.switchButton.isSelected];
    if (self.switchButton.isSelected) {
        [self openJpush];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)openJpush {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }

}

- (IBAction)cellAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[AboutUsViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[FeedViewController new] animated:YES];
            break;
        default:
            break;
    }
}

- (IBAction)outAction:(id)sender {
    [USER_DEFAULT setObject:nil forKey:USER_IS_LOGIN];
    [USER_DEFAULT setObject:nil forKey:USER_IS_VERTY];
    [USER_DEFAULT setObject:nil forKey:USER_IS_BIND];
    [USER_DEFAULT setObject:nil forKey:TOUCH_PASS];
    [USER_DEFAULT setObject:nil forKey:USER_PASS];
    [USER_DEFAULT setObject:nil forKey:USER_ACCOUNT];
    [USER_DEFAULT setObject:nil forKey:USER_TEL];
    [USER_DEFAULT setObject:nil forKey:INDEXCELL_TO_INVEST];
    [USER_DEFAULT setObject:nil forKey:SIGN_DAYS];
    [USER_DEFAULT setObject:nil forKey:USER_AVATAR];
    [USER_DEFAULT setObject:nil forKey:USER_BANKACCOUNT];
    [USER_DEFAULT setObject:nil forKey:USER_AUTH];
    NSURL *url = [NSURL URLWithString:[USER_DEFAULT objectForKey:LOGINURL]];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
