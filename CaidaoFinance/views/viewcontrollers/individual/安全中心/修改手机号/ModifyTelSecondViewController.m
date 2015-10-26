//
//  ModifyTelSecondViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ModifyTelSecondViewController.h"
#import <FlatUIKit.h>
#import "GZMessUtils.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "NSString+GZStringChecker.h"

@interface ModifyTelSecondViewController ()<FUIAlertViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *ver;
@end

@implementation ModifyTelSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    
    // Do any additional setup after loading the view from its nib.
}




- (void)sendVerty {
    if ([NSString checkPhoneReg:self.tel.text]) {
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&type=phone1",TEST_NETADDRESS,GETSMS,self.tel.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            
            
        }];
    }
    else
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"手机号格式不正确" alignment:CTCommonUtilsShowBottom];
    }
    
  
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

- (IBAction)sureAction:(id)sender {
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&smsCode=%@",TEST_NETADDRESS,VERTYSMS,self.tel.text,self.ver.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error){
        if (bSuccess) {
            NSDictionary*dic = JSON(returnData);
            NSLog(@"%@",dic);
            if (![[dic objectForKey:@"successed"] integerValue]) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                [sender setEnabled:YES];
            }
            else
            {
//                updateUserTel
                [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@",TEST_NETADDRESS,UPDATEUSERTEL,self.tel.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
                    if (bSuccess) {
                        NSDictionary * newdic = JSON(returnData);
                        if (![[newdic objectForKey:@"successed"] integerValue]) {
                            
                            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[newdic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];

                        }
                        else
                        {
                            FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"修改成功"
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
                            [USER_DEFAULT setObject:self.tel.text forKey:USER_TEL];
                        }
                    }
                    
                }];
                
                
            }

        }
    }];

}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray*arr = [self.navigationController viewControllers];
    [self.navigationController popToViewController:arr[2] animated:YES];
}

- (IBAction)vertyAction:(id)sender {
    [sender setEnabled:NO];
    [self sendVerty];
    [[GZMessUtils sharedUtils] startCountDown:120 label:self.vertyButton.titleLabel block:^{
        [sender setEnabled:YES];
        
        
    }];
}
@end
