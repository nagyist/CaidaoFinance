//
//  LendViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/8.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "LendViewController.h"
#import "ChooseLocationViewController.h"
#import <FlatUIKit.h>
#import "GZMenuView.h"
#import "SubmitSucViewController.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"

@interface LendViewController ()<FUIAlertViewDelegate,GZMenuViewDataSource,GZMenuViewDelegate,UITextFieldDelegate,ChooseViewControllerDelegate>
{
    NSArray * dropData;
    NSInteger sexIndex;
    
    NSInteger menuSeleIdx;
    
    NSArray * locations;
}
@property (nonatomic,strong)GZMenuView * menuView;

@end

@implementation LendViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self.contentView insertSubview:_menuView aboveSubview:_menuImage];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.centerX.mas_equalTo(_menuImage.mas_centerX).offset(0);
         make.right.mas_equalTo(_menuImage.mas_right);
         make.centerY.mas_equalTo(_menuImage.mas_centerY).offset(0);
         make.height.equalTo(@40);
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要借贷";
    [_submitButton setEnabled:NO];
    sexIndex = -1;
    dropData = @[@"天",@"月",@"年"];
    
    [_name addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_priceTxt addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_qixiantxt addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_telTxt addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];


    
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 25; // 左端盖宽度
    CGFloat right = 25; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _submitImage.image = [_submitImage.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _menuImage.image = [_menuImage.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.menuView = [[GZMenuView alloc] initWithFrame:CGRectZero];
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.menuView.backgroundColor = [UIColor clearColor];
    self.menuView.menuSuperView = self.contentView;
    
    // Do any additional setup after loading the view from its nib.
}

-(NSString*)stringFromIndex:(NSInteger)index view:(GZMenuView *)menuView
{
    return [dropData objectAtIndex:index];
}

-(NSInteger)numberOfRowsOfview:(GZMenuView *)menuView
{
    return [dropData count];
}

-(void)didSelectedItem:(NSIndexPath *)indexPath value:(NSString *)value
{
    menuSeleIdx = indexPath.row;
}

-(void)showSex
{
    [_priceTxt resignFirstResponder];
    [_qixiantxt resignFirstResponder];
    [_telTxt resignFirstResponder];
    [_name resignFirstResponder];
    
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"请选择性别"
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"保密"
                                                otherButtonTitles:@"男",@"女", nil];
    alertView.titleLabel.textColor = RGBCOLOR(138, 32, 35);
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

-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        switch (buttonIndex) {
            case 0:
                [_sexButton setTitle:@"保密" forState:UIControlStateNormal];
                break;
            case 1:
                [_sexButton setTitle:@"男" forState:UIControlStateNormal];
                break;
            case 2:
                [_sexButton setTitle:@"女" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        sexIndex = buttonIndex;
        [self check];
    }
    else if (alertView.tag == 1){
        switch (buttonIndex) {
            case 0:
                [self didSubmit];
                break;
            case 1:
                break;
                
            default:
                break;
        }
    }
    else if (alertView.tag == 2)
    {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                TEL(@"4009658588");
                break;
            default:
                break;
        }
    }
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
        
        [self.locationText setText:loca];
        [self check];
    }];
}

- (void)didSubmit{
    //计算期限
    NSInteger qixian = 0;
    switch (menuSeleIdx) {
        case 0:
            qixian = [_qixiantxt.text integerValue] * 1;
            break;
        case 1:
            qixian = [_qixiantxt.text integerValue] * 30;
            break;
        case 2:
            qixian = [_qixiantxt.text integerValue] * 365;
            break;
            
        default:
            break;
    }
    NSString * name = [_name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * provi = [[locations firstObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * city = [locations[1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?user_name=%@&user_sax=%ld&borrow_money=%@&borrow_time_limit=%@&user_province=%@&user_city=%@&user_tel=%@&captcha=%@",TEST_NETADDRESS,BORROW,name,sexIndex,_priceTxt.text,_qixiantxt.text,provi,city,_telTxt.text,@""] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary*dic = JSON(returnData);
            if ([[dic objectForKey:@"code"] integerValue] == 200) {
                [self.navigationController pushViewController:[SubmitSucViewController new] animated:YES];
            }
            else
            {
                FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                                      message:[dic objectForKey:@"msg"]
                                                                     delegate:self cancelButtonTitle:@"确定"
                                                            otherButtonTitles: nil];
                alertView.titleLabel.textColor = [UIColor grayColor];
                alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
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
        }
    }];
}

#pragma mark UITextFieldDelegate

- (void)textValueChanged:(UITextField*)text {
    [self check];
}


//检查是否全部填写完整
- (void)check
{
    if (![self.name.text isEqualToString:@""] &&
        ![self.priceTxt.text isEqualToString:@""] &&
        sexIndex != -1 &&
        ![self.telTxt.text isEqualToString:@""] &&
        ![self.qixiantxt.text isEqualToString:@""] &&
        ![self.locationText.text isEqualToString:@""]) {
        
        [_submitButton setEnabled:YES];
    }
    else
    {
        [_submitButton setEnabled:NO];
    }
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

- (IBAction)submitAction:(id)sender {
    if ([_priceTxt.text isEqualToString:@""])
    {
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"请输入借款金额"
                                                              message:nil
                                                             delegate:nil cancelButtonTitle:@"确定"
                                                    otherButtonTitles: nil];
        alertView.titleLabel.textColor = RGBCOLOR(138, 32, 35);
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
    else if (!([_priceTxt.text integerValue] >= 10000) || !([_priceTxt.text integerValue] <= 10000000))
    {
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"借款金额必须在1万-1000万元之间"
                                                              message:nil
                                                             delegate:nil cancelButtonTitle:@"确定"
                                                    otherButtonTitles: nil];
        alertView.titleLabel.textColor = RGBCOLOR(138, 32, 35);
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
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"是否确认提交申请？"
                                                              message:nil
                                                             delegate:self cancelButtonTitle:@"确定"
                                                    otherButtonTitles:@"取消",nil];
        alertView.titleLabel.textColor = RGBCOLOR(138, 32, 35);
        alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        alertView.alertButtonStyle = FUIAlertViewButtonLayoutHorizontal;
        alertView.messageLabel.textColor = [UIColor cloudsColor];
        alertView.messageLabel.font = [UIFont flatFontOfSize:14];
        alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        alertView.alertContainer.backgroundColor = [UIColor whiteColor];
        alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
        alertView.defaultButtonShadowHeight = 0;
        alertView.tag = 1;
        alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        alertView.defaultButtonTitleColor = [UIColor whiteColor];
        alertView.defaultButtonCornerRadius = 10;
        [alertView show];
    }
}

- (IBAction)sexAction:(id)sender {
    [self showSex];
}
- (IBAction)phoneAction:(id)sender {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:@"确认拨打客服电话吗？"
                                                         delegate:self cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"拨打",nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.alertButtonStyle = FUIAlertViewButtonLayoutHorizontal;
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.tag = 2;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    [alertView show];
    
}

- (IBAction)locationAction:(id)sender {
    ChooseLocationViewController * view = [[ChooseLocationViewController alloc] init];
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
}
@end
