//
//  RegisterViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterSecondViewController.h"
#import "ActivityWebViewController.h"
#import "HelpDetailViewController.h"
#import "GZMessUtils.h"
#import "CTCommonUtils.h"
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"
#import "NSString+GZStringChecker.h"
#import "RegisterSecondViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [_nextButton setEnabled:NO];
    _telText.delegate = self;
    _vertyText.delegate = self;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self check];
    return YES;
}


- (void)check
{
    if (_checkone.isSelected && _checktwo.isSelected && ![self.telText.text isEqualToString:@""] && ![self.vertyText.text isEqualToString:@""]) {
        [_nextButton setEnabled:YES];
    }
    else
    {
        [_nextButton setEnabled:NO];
    }
}

- (IBAction)vertyAction:(id)sender {
    
    if ([_telText.text isEqualToString:@""] || ![NSString checkPhoneReg:_telText.text]) {
        [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"请输入正确的电话号码" alignment:CTCommonUtilsShowBottom];
        return;
    }
    NSMutableDictionary*dic = [NSMutableDictionary new];
    [dic setObject:_telText.text forKey:@"userTel"];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userTel=%@",TEST_NETADDRESS,SMS,_telText.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
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

- (IBAction)checkOneAction:(id)sender {
    [_checkone setSelected:!_checkone.isSelected];
    [self check];
}

- (IBAction)checkTwoAction:(id)sender {
    [_checktwo setSelected:!_checktwo.isSelected];
    [self check];
}

- (IBAction)xieyi:(id)sender {
    [self.navigationController pushViewController:[[ActivityWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.186886.com/registerProtocol.do"]] animated:YES];
}

- (IBAction)tiaokuan:(id)sender {
    [self.navigationController pushViewController:[[HelpDetailViewController alloc] initWithName:@"免责条款" type:3] animated:YES];
}

- (IBAction)registerAction:(id)sender {
    
    NSMutableDictionary*dic = [NSMutableDictionary new];
    [dic setObject:_telText.text forKey:@"MB_PIN"];
    [dic setObject:_vertyText.text forKey:@"smsCode"];
    
    NSMutableDictionary*post = [NSMutableDictionary new];
    [post setObject:_telText.text forKey:@"tel"];
    [post setObject:_vertyText.text forKey:@"verty"];
    [post setObject:_code.text forKey:@"code"];
    [sender setEnabled:NO];
    
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&smsCode=%@",TEST_NETADDRESS,VERTYREGSMS,_telText.text,_vertyText.text] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        
        NSDictionary*dic = JSON(returnData);
        NSLog(@"%@",returnData);
        [sender setEnabled:YES];
        if(![[dic objectForKey:@"successed"] integerValue])
        {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
        }
        else
        {
            [self.navigationController pushViewController:[[RegisterSecondViewController alloc] initWithPostData:post] animated:YES];
        }
        
    }];
}
@end
