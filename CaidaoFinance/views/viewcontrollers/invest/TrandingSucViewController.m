//
//  TrandingSucViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/19.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "TrandingSucViewController.h"
#import "GZNetConnectManager.h"

@interface TrandingSucViewController () {
    NSDictionary * data;
    CGFloat cprice;
}

@end

@implementation TrandingSucViewController

- (id)initWithSuccessData:(NSDictionary *)dic price:(CGFloat)price{
    if (self) {
        data = dic;
        cprice = price;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(-10, 0, 50, 50)];
    [button setImage:UIIMAGE(@"back_button_normal") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = 0;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[barbtn];
    
    self.title = @"完成交易";
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,ACCOUNTINDEX] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
//        if (bSuccess) {
//            NSDictionary * dic = [JSON(returnData) objectForKey:@"userAccount"];
//           
//        }
//    }];
    [self.yue countFrom:[[data objectForKey:@"account"] floatValue] to:[[data objectForKey:@"account"] floatValue]];
    [self.touzi countFrom:cprice to:cprice];
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd hh.mm"];
    NSString * dateStr = [formatter stringFromDate:[NSDate date]];
    _date.text = dateStr;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction {
    NSArray * arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:arr[1] animated:YES];
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

- (IBAction)investAction:(id)sender {
    NSArray * arr = [self.navigationController viewControllers];

    if (GZAPP.isFromIndexCell) {
        GZAPP.isFromIndexCell = NO;
        [self.navigationController popToViewController:arr[0] animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:arr[1] animated:YES];

    }
}

@end
