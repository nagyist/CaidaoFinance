//
//  BindCardViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "BindCardViewController.h"
#import "CustonMZViewController.h"
#import "MZFormSheetController.h"
#import "ChooseLocationViewController.h"
#import "SearchBankViewController.h"
#import <FlatUIKit.h>
#import "GZNetConnectManager.h"
#import "SVProgressHUD.h"
#import "ChooseLocationViewController.h"
#import "CTCommonUtils.h"
#import "GZMessUtils.h"
#import "NSString+GZStringChecker.h"

@interface BindCardViewController ()<FUIAlertViewDelegate,ChooseViewControllerDelegate>
{
    NSArray * locations;
    NSString * myTel;
}

@end

@implementation BindCardViewController

- (void)viewDidAppear:(BOOL)animated
{
    [self.scrollView setContentSize:CGSizeMake(0, _bindButton.frame.origin.y + _bindButton.frame.size.height + 20)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行卡";
    [_scrollView setDelaysContentTouches:NO];
    myTel = [USER_DEFAULT objectForKey:USER_TEL];
    NSString * left = [myTel substringWithRange:NSMakeRange(0, 3)];
    NSString * right = [myTel substringWithRange:NSMakeRange(8, 3)];
    self.tel.text = [NSString stringWithFormat:@"%@***%@",left,right];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MZViewControllerSelectedAction:) name:@"MZViewControllerSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchBankViewControllerSelected:) name:@"SearchBankViewControllerSelected" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)MZViewControllerSelectedAction:(NSNotification*)noti{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    if ([noti userInfo]) {
        self.bankName.text = [[noti userInfo] objectForKey:@"text"];
    }
}

- (void)SearchBankViewControllerSelected:(NSNotification*)noti{
    if ([noti userInfo]) {
        self.bankLcoaitonLabel.text = [[noti userInfo] objectForKey:@"text"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application,@ you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [USER_DEFAULT setObject:USER_IS_BIND forKey:USER_IS_BIND];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ChooseLocationViewDelegate
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
        
        [self.area setText:loca];
    }];
}

- (IBAction)bindAction:(id)sender {
    [SVProgressHUD show];
    if(![_bankAccoutOne.text isEqualToString:_bankAccountTwo.text]){ [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"两次输入银行卡号不一致" alignment:CTCommonUtilsShowBottom];return;}
    
    NSString *bankName = [_bankName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *provice = [[locations firstObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * city = [[NSString stringWithFormat:@"%@%@",locations[1],locations[2]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *bankLocation = [_bankLcoaitonLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *bankAccount = _bankAccoutOne.text;
    NSString *userTel = _tel.text;
    NSString *smsCode = _vertyCode.text;
    
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?bankName=%@&provice=%@&City=%@&bankCity=%@&bankAccount=%@&userTel=%@smsCode=%@",TEST_NETADDRESS,ADDBANKCARD,bankName,provice,city,bankLocation,bankAccount,userTel,smsCode] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            [SVProgressHUD dismiss];
            NSDictionary*dic = JSON(returnData);
            if ([[dic objectForKey:@"code"] integerValue] == 100) {
                FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"银行卡绑定成功"
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
        }
    }];
}

- (IBAction)vertyAction:(id)sender {

    NSMutableDictionary*dic = [NSMutableDictionary new];
    [dic setObject:_tel.text forKey:@"userTel"];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?tel=%@&type=logpwd",TEST_NETADDRESS,GETSMS,myTel] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        NSDictionary*dic = JSON(returnData);
        NSLog(@"%@",returnData);
        if (![[dic objectForKey:@"successed"] integerValue]) {
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
        }
    }];
    
    UIButton*button = sender;
    [button setEnabled:NO];
    [[GZMessUtils sharedUtils] startCountDown:120 label:button.titleLabel block:^{
        [button setEnabled:YES];
    }];
    
}

- (IBAction)buttonAction:(id)sender {
    switch ([sender tag]) {
        case 0:
        {
            CustonMZViewController * controller = [[CustonMZViewController alloc] initWithDatas:@[@"工商银行",@"中国银行",@"建设银行",@"农业银行",@"华夏银行",@"交通银行",@"招商银行",@"浦发银行",@"民生银行",@"兴业银行",@"平安银行",@"光大银行",@"广发银行",@"中信银行",@"邮政储蓄银行",@"上海银行",@"长沙银行",@"长安银行",@"大连银行",@"鞍山市商业银行",@"包商银行",@"北京银行",@"渤海银行",@"沧州银行",@"承德银行",@"重庆银行",@"德阳银行",@"德州银行",@"东莞银行",@"鄂尔多斯银行",@"福建海峡银行",@"富滇银行",@"赣州银行",@"广州银行",@"哈尔滨银行",@"汉口银行",@"杭州银行",@"河北银行",@"恒丰银行",@"葫芦岛银行",@"湖州银行",@"徽商银行",@"吉林银行",@"济宁银行",@"江苏银行",@"锦州银行",@"昆仑银行",@"柳州银行",@"龙江银行",@"洛阳银行",@"南京银行",@"南昌银行",@"内蒙古银行",@"宁夏银行",@"宁波银行",@"齐商银行",@"齐鲁银行",@"青岛银行",@"青海银行",@"日照银行",@"苏州银行",@"台州银行",@"天津银行",@"潍坊银行",@"温州银行",@"厦门银行",@"邢台银行",@"烟台银行",@"营口银行",@"枣庄银行",@"郑州银行",@"浙江泰隆商业银行",@"北京农村商业银行",@"上海农村商业银行",@"重庆农村商业银行",@"天津农商银行"]];
            controller.style = MZViewContentStyleEducation;
            controller.itemSize = CGSizeMake(140, 34);
            
            MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:controller];
            [formSheet setPresentedFormSheetSize:CGSizeMake(230, self.view.frame.size.height - self.view.frame.size.height/4)];
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController*formSheetController)
             {
                 
             }];

        }
            break;
        case 1:
        {
            ChooseLocationViewController * locationView = [[ChooseLocationViewController alloc] init];
            locationView.delegate = self;
            [self.navigationController pushViewController:locationView animated:YES];

        }
            break;
        case 2:
            [self.navigationController pushViewController:[SearchBankViewController new] animated:YES];
            break;
            
        default:
            break;
    }
}
@end
