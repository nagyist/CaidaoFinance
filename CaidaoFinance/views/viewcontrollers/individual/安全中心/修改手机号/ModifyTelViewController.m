//
//  ModifyTelViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ModifyTelViewController.h"
#import "ModifyTelSecondViewController.h"
#import "GZNetConnectManager.h"
#import "GZMessUtils.h"
#import "CTCommonUtils.h"

@interface ModifyTelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UIButton *vertyButton;
@property (weak, nonatomic) IBOutlet UITextField *vertyLabel;

@end

@implementation ModifyTelViewController
- (IBAction)vertyAction:(id)sender {
    [sender setEnabled:NO];
    [self sendVerty];
    [[GZMessUtils sharedUtils] startCountDown:120 label:self.vertyButton.titleLabel block:^{
        [sender setEnabled:YES];
        
        
    }];
}

- (void)sendVerty {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&type=phone",TEST_NETADDRESS,GETSMS,[USER_DEFAULT objectForKey:USER_TEL]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    NSLog(@"%@",[USER_DEFAULT objectForKey:USER_TEL]);
    self.tel.text = [USER_DEFAULT objectForKey:USER_TEL];
    
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
    if ([self.vertyLabel.text isEqualToString:@""]) {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"验证码不能为空" alignment:CTCommonUtilsShowBottom];
        return;
    }
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&smsCode=%@",TEST_NETADDRESS,VERTYSMS,[USER_DEFAULT objectForKey:USER_TEL],self.vertyLabel.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
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
                [self.navigationController pushViewController:[ModifyTelSecondViewController new] animated:YES];

            }
        
        }
    }];
}
@end
