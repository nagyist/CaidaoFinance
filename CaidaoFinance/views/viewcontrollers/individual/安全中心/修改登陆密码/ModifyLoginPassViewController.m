//
//  ModifyLoginPassViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ModifyLoginPassViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"

@interface ModifyLoginPassViewController ()<FUIAlertViewDelegate>

@end

@implementation ModifyLoginPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureAction:(id)sender {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userPassword=%@&newUserPassword=%@&newUserPassword2=%@",TEST_NETADDRESS,MODIFYLOGINPASS,_txt1.text,_txt2.text,_txt3.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if ([[dic objectForKey:@"successed"] boolValue]) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"msg" alignment:CTCommonUtilsShowBottom];
            }
            
        }
    }];
    
//    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"修改成功"
//                                                          message:nil
//                                                         delegate:self cancelButtonTitle:@"确定"
//                                                otherButtonTitles:nil];
//    alertView.titleLabel.textColor = [UIColor grayColor];
//    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
//    alertView.messageLabel.textColor = [UIColor cloudsColor];
//    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
//    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
//    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
//    alertView.defaultButtonShadowHeight = 0;
//    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
//    alertView.defaultButtonTitleColor = [UIColor whiteColor];
//    alertView.defaultButtonCornerRadius = 10;
//    [alertView show];
    
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
