//
//  LoginViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
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

- (IBAction)forgetAction:(id)sender {
    [self.navigationController pushViewController:[ForgetViewController new] animated:YES];
}

- (IBAction)registerAction:(id)sender {
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

- (IBAction)loginAction:(id)sender {
    [_passText resignFirstResponder];
    [_telText resignFirstResponder];
    
    if (![_telText.text isEqualToString:@""] && ![_passText.text isEqualToString:@""]) {
        NSMutableDictionary*dic = [NSMutableDictionary new];
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userAccount=%@&userpassword=%@",TEST_NETADDRESS,LOGIN,_telText.text,_passText.text] connectType:connectType_GET params:dic result:^(BOOL bSuccess, id returnData, NSError *error) {
            NSDictionary * dic = JSON(returnData);
            if (bSuccess) {
                if([[dic objectForKey:@"code"] isEqualToString:@"301"])
                {
                    [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"登录失败，用户不存在或者密码错误" alignment:CTCommonUtilsShowBottom];
                }
                else if([[dic objectForKey:@"code"] isEqualToString:@"200"])
                {
                    [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"登录成功" alignment:CTCommonUtilsShowBottom];
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
                    [USER_DEFAULT setObject:USER_IS_LOGIN forKey:USER_IS_LOGIN];
                    [USER_DEFAULT setObject:_telText.text forKey:USER_ACCOUNT];
                    [USER_DEFAULT setObject:_passText.text forKey:USER_PASS];
                    [USER_DEFAULT setObject:[dic objectForKey:@"auth"] forKey:USER_AUTH];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }];
    }
    else
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"用户名或密码不能为空" alignment:CTCommonUtilsShowBottom];
    }
    
}
@end
