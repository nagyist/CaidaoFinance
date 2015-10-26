//
//  individualViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/20.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "individualViewController.h"
#import <FlatUIKit.h>
#import "GZSystemModelUtils.h"
#import "AvatarViewController.h"
#import "SettingViewController.h"
#import "PersonInfoViewController.h"
#import "SafeViewController.h"
#import "RecommendSysViewController.h"
#import "AutoBidViewController.h"
#import "MyLendViewController.h"
#import "MakeOverViewController.h"
#import "InsMessageViewController.h"
#import "MyInvestViewController.h"
#import "MoneyManagerViewController.h"
#import "AccountInfoViewController.h"
#import "GZNetConnectManager.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import <ASIProgressDelegate.h>
#import <UIImageView+WebCache.h>

@interface individualViewController ()<FUIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,AvatarDelegate>
{
    NSDictionary * individualData;
    NSDictionary * transcationData;
    NSDictionary * bankInfo;
    ASIFormDataRequest*currentRequest;
}

@end

@implementation individualViewController

- (void)viewDidAppear:(BOOL)animated
{
    if (iPhone4) {
        [_scrollView setContentSize:CGSizeMake(320, 520)];
        [_imgView mas_makeConstraints:^(MASConstraintMaker*make)
         {
             make.height.equalTo(_contentView.mas_height).offset(0).priorityHigh();
         }];
    }
}

#pragma mark AvatarDelegate
- (void)didSelectedAvatarUrl:(NSString *)url {
    [USER_DEFAULT setObject:url forKey:USER_AVATAR];
    [self.headimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,url]] placeholderImage:UIIMAGE(@"individual_avatar_female")];
    
}


- (void)getData
{
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,PERSONDATA] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            individualData = JSON(returnData);
            [SVProgressHUD dismiss];
            [self setData];
        }
    }];
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,ACCOUNTINDEX] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            transcationData = JSON(returnData);
            [SVProgressHUD dismiss];
            [self setTranscationData];
        }
    }];
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,BANKINFO] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            bankInfo = JSON(returnData);
            [SVProgressHUD dismiss];
            [USER_DEFAULT setObject:[bankInfo objectForKey:@"bankAccount"] forKey:USER_BANKACCOUNT];
        }
    }];
}

//填写资产管理数据
- (void)setTranscationData {
    self.zongjine.text = [[[transcationData objectForKey:@"userAccount"] objectForKey:@"allMoney"] integerValue] == 0 ?@"￥00.00":[NSString stringWithFormat:@"￥%@",[[transcationData objectForKey:@"userAccount"] objectForKey:@"allMoney"]];
    self.keyongjine.text = [[[transcationData objectForKey:@"userAccount"]objectForKey:@"availableMoney"] integerValue] == 0?@"￥00.00":[NSString stringWithFormat:@"￥%@",[[transcationData objectForKey:@"userAccount"] objectForKey:@"availableMoney"]];
    self.redpackage.text = [NSString stringWithFormat:@"%@%@",[[transcationData objectForKey:@"validMoney"] stringValue],@"元"];
    self.jifen.text = [[[transcationData objectForKey:@"userCredict"] objectForKey:@"creditValue"] integerValue] == 0?@"0分":[NSString stringWithFormat:@"%@分",[[transcationData objectForKey:@"userCredict"]objectForKey:@"creditValue"]];
    if (![[[transcationData objectForKey:@"user"] objectForKey:@"avatarImg"] isEqualToString:@""]) {
        [self.headimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,[[transcationData objectForKey:@"user"] objectForKey:@"avatarImg"]]] placeholderImage:UIIMAGE(@"individual_avatar_female")];
        [USER_DEFAULT setObject:[[transcationData objectForKey:@"user"] objectForKey:@"avatarImg"] forKey:USER_AVATAR];
    }
    
    [USER_DEFAULT setObject:[[transcationData objectForKey:@"user"] objectForKey:@"userTel"] forKey:USER_TEL];
    [self checkSign];
}

- (void)setData {
    
    self.name.text = [[individualData objectForKey:@"user"] objectForKey:@"userAccount"];
    [USER_DEFAULT setObject:self.name.text forKey:USER_NAME];
}

- (void)checkSign {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,CHECKSIGN] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if (![[dic objectForKey:@"successed"]boolValue]) {
                _signLabel.text = [NSString stringWithFormat:@"连续签到%ld天",[[[transcationData objectForKey:@"user"] objectForKey:@"appSignDay"] integerValue]];
                [_signButton setSelected:YES];
            }
            else
            {
                [_signButton setSelected:NO];
            }
        }
        
    }];
}

- (void)setUI
{
    [_scrollView setDelaysContentTouches:NO];
    if (self.view.frame.size.width == 600) {
    }
    NSLog(@"%f---%f",self.view.frame.size.width,self.view.frame.size.height);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setImage:UIIMAGE(@"individual_settingbutton_normal") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
    
    if ([USER_DEFAULT objectForKey:USER_AVATAR]) {
        NSString * headStr = [USER_DEFAULT objectForKey:USER_AVATAR];
        [_headimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,headStr]] placeholderImage:UIIMAGE(@"individual_avatar_female")];
        _headimg.layer.masksToBounds = YES;
        _headimg.layer.cornerRadius = 35;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self setUI];
    [self getData];
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
#pragma mark Actions



#pragma mark Sign in

- (IBAction)signAction:(id)sender {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,SIGN] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"签到成功"
                                                                  message:nil
                                                                 delegate:self cancelButtonTitle:@"确定"
                                                        otherButtonTitles: nil];
            alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            alertView.titleLabel.textColor = [UIColor grayColor];
            alertView.messageLabel.textColor = [UIColor grayColor];
            alertView.messageLabel.font = [UIFont flatFontOfSize:14];
            alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            alertView.alertContainer.backgroundColor = [UIColor whiteColor];
            alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
            alertView.defaultButtonShadowHeight = 0;
            alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
            alertView.defaultButtonTitleColor = [UIColor whiteColor];
            alertView.defaultButtonCornerRadius = 10;
            [alertView show];
            
            [_signButton setSelected:YES];
        }
        NSDictionary * dic = JSON(returnData);
        [USER_DEFAULT setObject:[dic objectForKey:@"qdts"] forKey:SIGN_DAYS];
        _signLabel.text = [NSString stringWithFormat:@"连续签到%@天",[dic objectForKey:@"qdts"]];
        
    }];
    
    
}


#pragma mark settingaction
- (void)settingAction
{
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

- (IBAction)buttonAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController pushViewController:[AccountInfoViewController new] animated:YES];

            break;
        case 1:
            [self.navigationController pushViewController:[[MoneyManagerViewController alloc] initWithIndiviData:individualData] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[MyInvestViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[MyLendViewController new] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[MakeOverViewController new] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[InsMessageViewController new] animated:YES];
            break;
        case 6:
            [self.navigationController pushViewController:[RecommendSysViewController new] animated:YES];
            break;
        case 7:
            [self.navigationController pushViewController:[SafeViewController new] animated:YES];
            break;
        case 8:
            [self.navigationController pushViewController:[AutoBidViewController new] animated:YES];
            break;
            
        default:
            break;
    }
}

- (IBAction)infoAction:(id)sender {
    [self.navigationController pushViewController:[[PersonInfoViewController alloc] initWithPersonData:transcationData] animated:YES];
}


- (IBAction)photoAction:(id)sender {
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"拍照",@"从相册中选取",@"默认头像", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
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

#pragma mark FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //取消
            break;
        case 1:
            //paizhao
            [GZSystemModelUtils takePhotoWithVC:self withDelegate:self];

            break;
        case 2:
            //相册
            [GZSystemModelUtils LocalPhotoWithVC:self delegate:self];

            break;
        case 3:
            //默认
        {
            AvatarViewController*view = [AvatarViewController new];
            view.delegate = self;
            [self.navigationController pushViewController:view animated:YES];
        }
           
            break;
            
        default:
            break;
    }
}

#pragma mark UIImagePickerViewDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    _headimg.image = image;
    _headimg.layer.masksToBounds = YES;
    _headimg.layer.cornerRadius = 35;
    //回复导航条
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    UIImage*image2 = UIIMAGE(@"back_button_normal");
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorImage = image2;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image2;
    
    [picker dismissViewControllerAnimated:YES completion:^(void)
     {
         if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
         {
             //从拍照返回后强制设置
             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
             [[UIApplication sharedApplication] setStatusBarHidden:NO];
             [self setNeedsStatusBarAppearanceUpdate];
         }
     }];
    //do something  save
    NSData *imageData = UIImagePNGRepresentation(image);
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,UPLOADIMG]];
    currentRequest =[ASIFormDataRequest requestWithURL:url];
    [currentRequest setRequestMethod:@"POST"];
    [currentRequest setPostValue:@"image1" forKey:@"FILEST"];
    [currentRequest setShouldStreamPostDataFromDisk:YES];
    [currentRequest addData:imageData withFileName:@"filedata.png" andContentType:@"image/png" forKey:@"filedata"];
    [currentRequest setDelegate:self];
    [currentRequest setDidFinishSelector:@selector(uploadImageFinished:)];
    [currentRequest setUploadProgressDelegate:self];
    [currentRequest setDidFailSelector:@selector(uploadImageFailed:)];
    [currentRequest startAsynchronous];
    
}

- (void)uploadImageFinished:(ASIFormDataRequest*)requestform {
    [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];
    NSString * str = [requestform responseString];
    NSLog(@"%@---%i",[requestform responseString],[requestform responseStatusCode]);
    NSDictionary * dic = JSON(str);
    if ([requestform responseStatusCode] == 200) {
        [USER_DEFAULT setObject:[dic objectForKey:@"msg"] forKey:USER_AVATAR];
        [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?PHOTO=%@",TEST_NETADDRESS,UPDATEAVATAR,[dic objectForKey:@"msg"]] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
            if (bSuccess) {
                
            }
        }];
    }
}

- (void)uploadImageFailed:(ASIFormDataRequest*)request {
    [SVProgressHUD showErrorWithStatus:@"上传失败，请检查网络"];
}


- (void)setProgress:(float)newProgress {
    [SVProgressHUD showProgress:newProgress];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        
    }];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        //从拍照返回后强制设置
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self setNeedsStatusBarAppearanceUpdate];
    }

}

@end
