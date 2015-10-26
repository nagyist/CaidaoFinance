//
//  AddFriendViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "AddFriendViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "SVProgressHUD.h"

@interface AddFriendViewController ()<FUIAlertViewDelegate>
{
    NSString * scandata;
}

@end

@implementation AddFriendViewController

- (id)initWithQscanData:(NSString *)data {
    if (self) {
        scandata = data;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.type) {
        case AddFriendTypeCode:
            self.title = @"推荐码";
            self.LabelOne.text = @"推荐码";
            break;
        case AddFriendTypeTel:
            self.title  = @"手机号";
            self.LabelOne.text = @"手机号";

            break;
        case AddFriendTypeName:
            self.title = @"昵称";
            self.LabelOne.text = @"昵称";
            
            break;
        default:
            break;
    }
    self.labelTwo.text = @"验证信息";
    
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)sureAction:(id)sender {
    [_txtOne resignFirstResponder];
    [_txtTwo resignFirstResponder];
    [SVProgressHUD show];
    NSString * content = [_txtTwo.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?friendsUserAccount=%@&friendsContent=%@",TEST_NETADDRESS,ADDFRIEND,_txtOne.text,content] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            [SVProgressHUD dismiss];
            NSDictionary*dic = JSON(returnData);
            if ([[dic objectForKey:@"successed"] boolValue]) {
                FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"提交成功"
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
@end
