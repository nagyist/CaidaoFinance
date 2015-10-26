//
//  RegisterSecondViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RegisterSecondViewController.h"
#import "RegisterThirdViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "CTCommonUtils.h"

@interface RegisterSecondViewController ()
{
    NSMutableDictionary * postData;
}

@end

@implementation RegisterSecondViewController

- (id)initWithPostData:(NSMutableDictionary *)data
{
    if (self) {
        postData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
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

- (IBAction)nextAction:(id)sender {
    [_pswTxtOne resignFirstResponder];
    [_pswTxtTwo resignFirstResponder];
    [sender setEnabled:NO];
    
    if (![_pswTxtOne.text isEqualToString:_pswTxtTwo.text]) {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"两次密码输入不一致" alignment:CTCommonUtilsShowBottom];
    }
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?inviteUserid=%@&userAccount=%@&userPassword=%@&registerType=registerType&phoneCode=%@",TEST_NETADDRESS,REGISTER,@"",[postData objectForKey:@"tel"],_pswTxtOne.text,[postData objectForKey:@"verty"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary*dic = JSON(returnData);
            NSLog(@"%@",dic);
            if (![[dic objectForKey:@"successed"] integerValue]) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                [sender setEnabled:YES];
            }
            else
            {
                [postData setObject:_pswTxtOne.text forKey:@"pass"];
                [self.navigationController pushViewController:[[RegisterThirdViewController alloc] initWithPostData:postData] animated:YES];
            }
        }
    }];
}
@end
