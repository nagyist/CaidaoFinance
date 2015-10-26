//
//  RecommendSysViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RecommendSysViewController.h"
#import "RecommendFriendViewController.h"
#import "MyScanViewController.h"
#import "RecommandCodeViewController.h"
#import "RecommendCheckinViewController.h"
#import "CTCommonUtils.h"
#import <ZBarSDK.h>
#import "GZNetConnectManager.h"
#import "QRCodeGenerator.h"


@interface RecommendSysViewController ()<ZBarReaderDelegate>
{
    NSDictionary * myRecommedData;
    NSString * qscanStr;
    __weak IBOutlet UIImageView *scanImg;
}

@end

@implementation RecommendSysViewController


- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, 580)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐系统";
    [_scrollView setDelaysContentTouches:NO];
    [self loadData];
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

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,RECOMMED] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            myRecommedData = JSON(returnData);
            qscanStr = [NSString stringWithFormat:@"%@%@%@",TEST_NETADDRESS,@"toRegister.do?c=",[[myRecommedData objectForKey:@"user"] objectForKey:@"inviteCode"]];
            [self setData];
        }
    }];
}

- (void)setData {

    scanImg.image = [QRCodeGenerator qrImageForString:qscanStr imageSize:75.0];
    self.code.text = [[myRecommedData objectForKey:@"user"] objectForKey:@"inviteCode"];
    
}

- (IBAction)cellAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[RecommendFriendViewController new] animated:YES];
            break;
        case 1:
        {
            ZBarReaderViewController *reader = [ZBarReaderViewController new];
            reader.navigationController.navigationBarHidden = NO;
            reader.title = @"二维码";
            reader.readerDelegate = self;
            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            reader.showsZBarControls = NO;
            ZBarImageScanner *scanner = reader.scanner;
            // TODO: (optional) additional reader configuration here
            UIView*view = [[[NSBundle mainBundle] loadNibNamed:@"ZDView" owner:self options:nil] lastObject];
            [reader.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker*make)
             {
                 make.left.equalTo(@0);
                 make.right.equalTo(@0);
                 make.top.equalTo(@64);
                 make.bottom.equalTo(@0);
                 
             }];
            // EXAMPLE: disable rarely used I2/5 to improve performance
            [scanner setSymbology: ZBAR_I25
                           config: ZBAR_CFG_ENABLE
                               to: 0];
            //            [self setOverlayPickerView:reader];
            [self.navigationController pushViewController:reader animated:YES];
        }
            break;
        case 2:
            [self.navigationController pushViewController:[RecommandCodeViewController new] animated:YES];

            break;
        case 3:
            [self.navigationController pushViewController:[RecommendCheckinViewController new] animated:YES];

            break;
            
        default:
            break;
    }
}
- (IBAction)copyAction:(id)sender {
    switch ([sender tag]) {
        case 0:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.code.text;
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"推荐码成功复制到粘贴板" alignment:CTCommonUtilsShowBottom];
        }
            break;
        case 1:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = qscanStr;
            [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"推荐链接成功复制到粘贴板" alignment:CTCommonUtilsShowBottom];
        }
            
            break;
            
        default:
            break;
    }
}
@end
