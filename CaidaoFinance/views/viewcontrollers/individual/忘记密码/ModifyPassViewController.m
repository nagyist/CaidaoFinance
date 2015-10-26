//
//  ModifyPassViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ModifyPassViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "SVProgressHUD.h"

@interface ModifyPassViewController ()
{
    NSDictionary * postData;
}

@property (weak, nonatomic) IBOutlet UITextField *pswTxtOne;
@property (weak, nonatomic) IBOutlet UITextField *pswTxtTwo;
@end

@implementation ModifyPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithPostData:(NSDictionary *)data {
    if (self) {
        postData = data;
    }
    return self;
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

- (IBAction)loginAction:(id)sender {
    
    if (![_pswTxtTwo.text isEqualToString:@""] && [_pswTxtTwo.text isEqualToString:_pswTxtOne.text]) {
        [SVProgressHUD show];
//        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_pswTxtOne.text,@"NEW_PWD",_pswTxtTwo.text,@"NEW_PWD_D", nil];
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?NEW_PWD=%@&NEW_PWD_D=%@&userTel=%@",TEST_NETADDRESS,FORGETPASSTWO,_pswTxtOne.text,_pswTxtOne.text,[postData objectForKey:@"tel"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            if (bSuccess) {
                NSDictionary * dic = JSON(returnData);
                if ([dic objectForKey:@"message"]) {
                    [SVProgressHUD dismiss];
                    [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"message"] alignment:CTCommonUtilsShowBottom];
                    [USER_DEFAULT setObject:USER_IS_LOGIN forKey:USER_IS_LOGIN];
                    [USER_DEFAULT setObject:[postData objectForKey:@"tel"] forKey:USER_ACCOUNT];
                    [USER_DEFAULT setObject:[postData objectForKey:@"tel"] forKey:USER_TEL];
                    [USER_DEFAULT setObject:_pswTxtOne.text forKey:USER_PASS];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            
        }];
    }
    else
    {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"修改失败" alignment:CTCommonUtilsShowBottom];
    }
   


}
@end
