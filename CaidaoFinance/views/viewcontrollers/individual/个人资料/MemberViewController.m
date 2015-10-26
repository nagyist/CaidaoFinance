//
//  MemberViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MemberViewController.h"
#import <FlatUIKit.h>
#import "MZFormSheetController.h"
#import "CustonMZViewController.h"
#import "ChooseLocationViewController.h"
#import "CalendarDatePickerView.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "SVProgressHUD.h"

@interface MemberViewController ()<FUIAlertViewDelegate,CalendarDatePickerDelegate,ChooseViewControllerDelegate>
{
    CalendarDatePickerView * picker;
    NSDictionary * individualData;
    NSDictionary * user;
    
    BOOL canCheckName;
    BOOL canCheckBith;
    
    NSInteger sexIndex;
    NSInteger jobIndex;
    NSInteger eduIndex;
    
    NSString * city;
    NSString * area;
    
    NSArray * locations;
}

@end

@implementation MemberViewController

- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, 590)];
}

- (id)initWithIndividualData:(NSDictionary *)data {
    
    if (self) {
        individualData = data;
        user = [individualData objectForKey:@"user"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"会员信息";
    city = @"";
    area = @"";
    [_scrollView setDelaysContentTouches:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MZViewControllerSelectedAction:) name:@"MZViewControllerSelected" object:nil];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
    
    [self check];
    // Do any additional setup after loading the view from its nib.
}

- (void)check {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,CHECKACCOUNTBIRTH] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            if ([[dic objectForKey:@"isUserBirthday"] isEqualToString:@"允许修改一次生日"]) {
                canCheckBith = YES;
            }
            if ([[dic objectForKey:@"isUserAccount"] isEqualToString:@"允许修改一次用户名"]) {
                canCheckName = YES;
            }
            [self setData];
        }
    }];
}


- (void)setData {
    self.name.text = [user objectForKey:@"userAccount"];
    NSString * tel = [USER_DEFAULT objectForKey:USER_TEL];
    NSString * left = [tel substringWithRange:NSMakeRange(0, 3)];
    NSString * right = [tel substringWithRange:NSMakeRange(8, 3)];
    _tel.text = [NSString stringWithFormat:@"%@***%@",left,right];
    self.education.text = [self getEducation:[[user objectForKey:@"userEducation"] integerValue]];
    self.job.text = [self getJob:[[user objectForKey:@"userOccupation"] integerValue]];
    self.birthText.text = [[user objectForKey:@"userBirthday"] substringWithRange:NSMakeRange(0, 10)];
    self.email.text = [user objectForKey:@"userEmail"];
    self.addressText.text = [user objectForKey:@"userAddress"];
    self.location.text = [NSString stringWithFormat:@"%@ %@",[user objectForKey:@"userCity"],[user objectForKey:@"userArea"]];
    [_name setEnabled:canCheckName];
    [_birthText setEnabled:canCheckBith];
    
}

- (void)saveAction{
    [SVProgressHUD show];
    if ([self.location.text isEqualToString:@""]) {
        
    }
    city = [self.location.text componentsSeparatedByString:@"-"][0];
    area = [[self.location.text componentsSeparatedByString:@"-"] lastObject];
    city = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    area = [area stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * address = [_addressText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?userAccount=%@&userSex=%ld&userBirthday=%@&userEmail=%@&userEducation=%ld&userOccupation=%ld&userCity=%@&userArea=%@&LocationDetail=%@",TEST_NETADDRESS,CONSUM,_name.text,sexIndex,_birthText.text,_email.text,eduIndex,jobIndex,city,area,address] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if(bSuccess)
        {
            NSDictionary * dic = JSON(returnData);
            [SVProgressHUD dismiss];
            if ([[dic objectForKey:@"successed"] boolValue]) {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"msg"] alignment:CTCommonUtilsShowBottom];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
}

- (void)MZViewControllerSelectedAction:(NSNotification*)notif{
    NSDictionary * dic = [notif userInfo];
    CustonMZViewController * controller = [dic objectForKey:@"id"];
    NSInteger index = [[dic objectForKey:@"index"] integerValue];
    MZViewContentStyle style = controller.style;
    switch (style) {
        case MZViewContentStyleEducation:
            _education.text = [dic objectForKey:@"text"];
            eduIndex = index;
            break;
        case MZViewContentStyleJob:
            _job.text = [dic objectForKey:@"text"];
            jobIndex = index;
            break;
        default:
            break;
    }
    
    [self mz_dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController*formSheetController)
     {
         [[formSheetController formSheetWindow] removeFromSuperview];
     }];
}

#pragma mark FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            self.sex.text = @"保密";
            break;
        case 1:
            self.sex.text = @"男";
            break;
        case 2:
            self.sex.text = @"女";
            break;
            
        default:
            break;
    }
    sexIndex = buttonIndex;
}

#pragma mark showalert
- (void)showSex{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"请选择性别"
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"保密"
                                                otherButtonTitles:@"男",@"女", nil];
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

}

-(void)closePickerView
{
    if(picker)
    {
        //        [_scrollView setContentOffset:CGPointMake(0, -50) animated:YES];
        [UIView animateWithDuration:0.3 animations:^(void)
         {
             picker.frame = CGRectMake(0, _scrollView.frame.size.height, GZContent_Width, 200);
         }completion:^(BOOL finished)
         {
             [picker removeFromSuperview];
             picker = nil;
         }];
    }
}

- (void)calendarDatePickerView:(CalendarDatePickerView *)pickerView didSelectedDate:(NSDate *)date{
    _birthText.text = [[NSDate date] stringFromDate:date];
    [self closePickerView];
}

- (void)showDate{
    if (!picker) {
        picker = [[CalendarDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, GZContent_Width, 200)];
        picker.delegate = self;
        [picker setCurrnetDate:[NSDate date]];
        [self.view addSubview:picker];
        [UIView animateWithDuration:0.3 animations:^(void)
         {
             picker.frame = CGRectMake(0, self.view.frame.size.height - 200, GZContent_Width, 200);
         }completion:nil];
    }
}

- (void)showEducation{
    CustonMZViewController * controller = [[CustonMZViewController alloc] initWithDatas:@[@"小学",@"中学",@"高中",@"中专",@"大学专科",@"大学本科",@"研究生",@"博士",@"博士后",@"其他"]];
    controller.style = MZViewContentStyleEducation;
    controller.view.tag = 0;
    controller.itemSize = CGSizeMake(80, 34);
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:controller];
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController*formSheetController)
     {
         
     }];
    
}

- (void)showJob{
    CustonMZViewController * controller = [[CustonMZViewController alloc] initWithDatas:@[@"金融",@"IT",@"其他"]];
    controller.style = MZViewContentStyleJob;
    controller.view.tag = 1;
    controller.itemSize = CGSizeMake(80, 34);
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:controller];
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController*formSheetController)
     {
         
     }];
}

- (void)showArea{
    ChooseLocationViewController * controller = [ChooseLocationViewController new];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark ChooseAreaDelegate
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
        
        [self.location setText:loca];
    }];
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

- (NSString*)getEducation:(NSInteger)index {
    NSString * edu = @"";
    NSArray * arr =  @[@"小学",@"中学",@"高中",@"中专",@"大学专科",@"大学本科",@"研究生",@"博士",@"博士后",@"其他"];
    edu = [arr objectAtIndex:index];
    return edu;
}

- (NSString*)getJob:(NSInteger)index {
    NSString * job = @"";
    NSArray * arr =  @[@"金融",@"IT",@"其他"];
    job = arr[index];
    return job;
}


- (IBAction)buttonAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            //性别
            [self showSex];
            break;
        case 1:
            //出生日期
            [self showDate];
            break;
        case 2:
            //教育程度
            [self showEducation];
            break;
        case 3:
            //从事职业
            [self showJob];
            break;
        case 4:
            //所在地区
            [self showArea];
            break;
            
        default:
            break;
    }
    
}
@end
