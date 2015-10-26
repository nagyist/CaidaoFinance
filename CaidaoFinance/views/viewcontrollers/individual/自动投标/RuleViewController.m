//
//  RuleViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "RuleViewController.h"

@interface RuleViewController ()

@end

@implementation RuleViewController

- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(0, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投标规则";
    _ruleLabelOne.text = @"自动投标是为了方便那些没有时间逐个查看筛选借款列表并进行投标的投资人。投资人可根据自己的风险偏好、投资习 惯在自动投标中设置各种条件，若有符合相应条件的借款出现，将由程序自动完成投标。";
    
    _ruleLabelTwo.text = @"1、用户的可用金额必须大于100元，设置金额为100元的整数倍，最高金额为5万元。\n2、自动投标以设置时间为准，设置完成一分钟后生效，有符合条件的借款标系统将自动匹配排名投标。\n3、同一标，用户只有1次自动投标的机会；当自动投标完成后，可通过手动投标。\n4、 自动投标排名规则如下\n（1）自动投标根据时间排名进行投标初始排名，时间为自动投标设置时间；根据发标时间设定排名顺序。\n（2）用户每次自动投标成功后排名自动移至尾部。\n（3）每标最后一名未投完所设资金的，排名不往后移；待下一标投标成功后，重新排名。\n5、 若用户可用金额小于设置金额，则按目前用户的可用金额进行投标；若可用金额大于设置金额，则按设置金额进行投标。\n6、当借款标投资进度等于百分之五，将停止自动投标，剩余额度为其他投标额度。\n7、会员在财道金融获得借款时即所申请的借款放款时，自动关闭自动投标，以避免借款被用于自动投标。\n温馨提示：用户在设置自动投标之前请详细阅读上述规则，若开启自动投标将默认视为同意以上规则，请把握好自动更新排名的时间，以免延误自动投标。";
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

@end
