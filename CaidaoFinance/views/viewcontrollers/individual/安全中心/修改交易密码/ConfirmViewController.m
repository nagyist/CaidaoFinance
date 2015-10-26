//
//  ConfirmViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ConfirmViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"

@interface ConfirmViewController ()<FUIAlertViewDelegate>

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置交易密码";
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSArray * arr = [self.navigationController viewControllers];
    [self.navigationController popToViewController:arr[2] animated:YES];
}

- (IBAction)sureAction:(id)sender {
    
    if([_txt1.text isEqualToString:_txt2.text])
    {
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?newUserPaypassword=%@&newUserPaypassword2=%@",TEST_NETADDRESS,UPADATEPAYPASS,_txt1.text,_txt2.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            if (bSuccess) {
                NSDictionary * dic = JSON(returnData);
                if ([[dic objectForKey:@"successed"] boolValue]) {
                    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"重置成功"
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
                else
                {
                    [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                }
            }
            
        }];
    }
    else
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"两次密码输入不一致" alignment:CTCommonUtilsShowBottom];

    }
    
    }
@end
