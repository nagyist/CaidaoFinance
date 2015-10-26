//
//  MyInvestDetailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>
#import "ContractListView.h"

typedef NS_ENUM(NSInteger, InvestBiaoType)
{
    InvestBiaoTypeNormal = 0,
    InvestBiaoTypeTransfer
};

@interface MyInvestDetailViewController : UIViewController
- (IBAction)detailAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *bianhao;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UICountingLabel *huishou;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;
@property (weak, nonatomic) IBOutlet UICountingLabel *huishouPrice;
@property (weak, nonatomic) IBOutlet ContractListView *contractView;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (nonatomic)InvestBiaoType type;

- (id)initWithInvestBiaoType:(InvestBiaoType)type investData:(NSDictionary*)investData;

@end
