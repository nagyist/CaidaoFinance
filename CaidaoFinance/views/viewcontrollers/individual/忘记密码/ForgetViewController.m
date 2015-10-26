//
//  ForgetViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ForgetViewController.h"
#import "ModifyPassViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "NSString+GZStringChecker.h"
#import "GZMessUtils.h"

@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//下一步
- (IBAction)nextAction:(id)sender {
    [_telText resignFirstResponder];
    [_verText resignFirstResponder];
    
    [sender setEnabled:NO];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&smsCode=%@",TEST_NETADDRESS,VERTYSMS,_telText.text,_verText.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            NSDictionary*dic = JSON(returnData);
            NSLog(@"%@",returnData);
            if([[dic objectForKey:@"code"] integerValue] != 200)
            {
                [sender setEnabled:YES];
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
            }
            else
            {
                [sender setEnabled:YES];
                [self.navigationController pushViewController:[[ModifyPassViewController alloc] initWithPostData:[NSDictionary dictionaryWithObjectsAndKeys:_telText.text,@"tel", nil]] animated:YES];
            }
        }];
    
}


- (IBAction)vertyAction:(id)sender {
    if ([_telText.text isEqualToString:@""] || ![NSString checkPhoneReg:_telText.text]) {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"请输入正确的电话号码" alignment:CTCommonUtilsShowBottom];
        return;
    }
    NSMutableDictionary*dic = [NSMutableDictionary new];
    [dic setObject:_telText.text forKey:@"userTel"];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&type=logpwd",TEST_NETADDRESS,GETSMS,_telText.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        NSDictionary*dic = JSON(returnData);
        NSLog(@"%@",returnData);
        if (![[dic objectForKey:@"successed"] integerValue]) {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
        }
    }];
    
    UIButton*button = sender;
    [button setEnabled:NO];
    [[GZMessUtils sharedUtils] startCountDown:60 label:button.titleLabel block:^{
        [button setEnabled:YES];
    }];
    
    
}
@end
