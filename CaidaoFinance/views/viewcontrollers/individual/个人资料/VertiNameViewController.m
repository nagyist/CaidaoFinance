//
//  VertiNameViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "VertiNameViewController.h"
#import "ChooseLocationViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "NSString+GZStringChecker.h"

@interface VertiNameViewController ()<FUIAlertViewDelegate,ChooseViewControllerDelegate>
{
    NSArray * locations;
}

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *cardNum;
@end

@implementation VertiNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
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

- (IBAction)locationAction:(id)sender {
    ChooseLocationViewController*view = [[ChooseLocationViewController alloc] init];
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark ChooseLocationDelegate
- (void)didChooseArea:(NSArray *)data
{
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
        
        [self.locationLabel setText:loca];
        
    }];
}

- (IBAction)vertyAction:(id)sender {
    [_name resignFirstResponder];
    if (![NSString checkCharacterReg:_name.text]) {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"请输入中文" alignment:CTCommonUtilsShowBottom];
    }
    
    NSString * province = [locations firstObject];
    NSString * city = [locations count]>1?[locations objectAtIndex:1]:@"";
    NSString * area = [locations count]>2?locations[2]:@"";
    province = [province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    city = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    area = [area stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * name = [_name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [sender setEnabled:NO];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userRealName=%@&cardNumber=%@&userProvince=%@&userCity=%@&userArea=%@&userAddress=%@",TEST_NETADDRESS,REALNAMEVERTY,name,_cardNum.text,province,city,area,_address.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary*dic = JSON(returnData);
            if ([[dic objectForKey:@"successed"] boolValue]) {
                FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"实名验证成功"
                                                                      message:nil
                                                                     delegate:self cancelButtonTitle:@"确定"
                                                            otherButtonTitles: nil];
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

#pragma mark FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [USER_DEFAULT setObject:USER_IS_VERTY forKey:USER_IS_VERTY];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}
@end
