//
//  RecommendCheckinViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RecommendCheckinViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "NSString+GZStringChecker.h"

@interface RecommendCheckinViewController ()<FUIAlertViewDelegate>

@end

@implementation RecommendCheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐登记";

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

#pragma mark 

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkinAction:(id)sender {
    [_name resignFirstResponder];
    [_tel resignFirstResponder];
    
    if([_name.text isEqualToString:@""] || [_tel.text isEqualToString:@""])
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"姓名和电话不能为空" alignment:CTCommonUtilsShowBottom];
        return;
    }
    else if (![NSString checkPhoneReg:_tel.text])
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"手机号格式不正确" alignment:CTCommonUtilsShowBottom];
        return;
    }
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&name=%@",TEST_NETADDRESS,RECOMMENDREG,_tel.text,_name.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary*dic = JSON(returnData);
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"message"] alignment:CTCommonUtilsShowBottom];
        }
    }];
    
    
    
}
@end
