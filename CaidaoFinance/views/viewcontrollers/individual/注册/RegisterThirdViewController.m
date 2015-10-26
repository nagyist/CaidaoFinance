//
//  RegisterThirdViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RegisterThirdViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "ChooseLocationViewController.h"

@interface RegisterThirdViewController ()<ChooseViewControllerDelegate>
{
    NSMutableDictionary * postData;
    NSArray * locations;
}

@end

@implementation RegisterThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"注册";
    [self loginNet];
    // Do any additional setup after loading the view from its nib.
}

- (void)loginNet{
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userAccount=%@&userpassword=%@",TEST_NETADDRESS,LOGIN,[postData objectForKey:@"tel"],[postData objectForKey:@"pass"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSLog(@"%@",returnData);
            
        }
    }];
}

- (id)initWithPostData:(NSMutableDictionary *)data {
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

- (void)didChooseArea:(NSArray *)data {
    locations = data;
    __block NSString * loca = @"";
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != 2) {
            loca = [loca stringByAppendingString:[NSString stringWithFormat:@"%@-",obj]];
        }
        else
        {
            loca = [loca stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
        }
        
        [self.areaLabel setText:loca];
    }];
}

- (IBAction)completeAction:(id)sender {
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userRealName=%@&cardNumber=%@&userProvince=%@&userCity=%@&userArea=%@&userAddress=%@",TEST_NETADDRESS,REALNAMEVERTY,_name.text,_card.text,@"shangh",@"shangh",@"huangp",_addreaaText.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSLog(@"%@",returnData);
            NSDictionary*dic = JSON(returnData);
            if ([[dic objectForKey:@"code"] integerValue] == 100) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"登录成功" alignment:CTCommonUtilsShowBottom];
                [self login];
            }
            else
            {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
            }
        }
    }];
}

- (void)login
{
    [USER_DEFAULT setObject:USER_IS_LOGIN forKey:USER_IS_LOGIN];
    [USER_DEFAULT setObject:[postData objectForKey:@"tel"] forKey:USER_ACCOUNT];
    [USER_DEFAULT setObject:[postData objectForKey:@"tel"] forKey:USER_TEL];
    [USER_DEFAULT setObject:[postData objectForKey:@"pass"] forKey:USER_PASS];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loginAction:(id)sender {
    [self login];
}

- (IBAction)areaAction:(id)sender {
    ChooseLocationViewController * view = [[ChooseLocationViewController alloc] init];
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
    
}

@end
