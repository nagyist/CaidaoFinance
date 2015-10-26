//
//  ModifyTradPassViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ModifyTradPassViewController.h"
#import <FlatUIKit.h>
#import "ConfirmViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "GZMessUtils.h"

@interface ModifyTradPassViewController ()<FUIAlertViewDelegate>{
    UIButton * lastSelectedButton;
}

@end

@implementation ModifyTradPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改交易密码";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    

    lastSelectedButton = self.leftSegment;
    [self.leftSegment setTintColor:[UIColor clearColor]];
    [self.rightSegment setTintColor:[UIColor clearColor]];
    
    if (self.showSet) {
        [self showSetting];
    }
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

- (void)showSetting {
    [lastSelectedButton setSelected:NO];
    [self.rightSegment setSelected:YES];
    lastSelectedButton = self.rightSegment;
    self.view1.hidden = YES;
    self.view2.hidden = NO;
}

- (IBAction)nextAction:(id)sender {
    [sender setEnabled:NO];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&smsCode=%@",TEST_NETADDRESS,VERTYREGSMS,_txt4.text,_txt5.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [sender setEnabled:YES];
        NSDictionary*dic = JSON(returnData);
        [sender setEnabled:YES];
        if(![[dic objectForKey:@"successed"] integerValue])
        {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
        }
        else
        {
            [self.navigationController pushViewController:[ConfirmViewController new] animated:YES];
        }
        
    }];
}

- (IBAction)vertyAction:(id)sender {
    ///验证码
    [sender setEnabled:NO];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&type=logpwd",TEST_NETADDRESS,GETSMS,_txt4.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        
    }];
    [[GZMessUtils sharedUtils] startCountDown:120 label:[sender titleLabel] block:^{
        [sender setEnabled:YES];
    }];
    
}

- (IBAction)sureAction:(id)sender {
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userPaypassword=%@&newUserPaypassword=%@&newUserPaypassword2=%@",TEST_NETADDRESS,MODIFYPAYPASS,_txt1.text,_txt2.text,_txt3.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if ([[dic objectForKey:@"successed"] boolValue]) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
            }
            else
            {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [lastSelectedButton setSelected:NO];
            [sender setSelected:YES];
            lastSelectedButton = sender;
            self.view2.hidden = YES;
            self.view1.hidden = NO;
            break;
        case 1:
            [lastSelectedButton setSelected:NO];
            [sender setSelected:YES];
            lastSelectedButton = sender;
            self.view1.hidden = YES;
            self.view2.hidden = NO;

            break;
        default:
            break;
    }
}
@end
