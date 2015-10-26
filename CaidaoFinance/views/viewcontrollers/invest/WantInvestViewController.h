//
//  WantInvestViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/19.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLProgressBar.h>
#import <UICountingLabel.h>

typedef NS_ENUM(NSInteger, WantInvestType){
    WantInvestTypeInvest = 0,
    WantInvestTypeMakeOver
};

@interface WantInvestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *shiyonghongbao;
@property (weak, nonatomic) IBOutlet UIImageView *texttwoBg;

@property (weak, nonatomic) IBOutlet UILabel *fujia;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIButton *check;
@property (weak, nonatomic) IBOutlet UITextField *texttwo;
@property (weak, nonatomic) IBOutlet UITextField *textone;
@property (nonatomic,strong)NSDictionary * investData;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UILabel *nlv;
@property (weak, nonatomic) IBOutlet UILabel *redPrice;
@property (weak, nonatomic) IBOutlet UILabel *redNum;
@property (weak, nonatomic) IBOutlet UILabel *shouyi;
@property (weak, nonatomic) IBOutlet UILabel *keyong;

- (IBAction)investAction:(id)sender;
- (IBAction)autoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICountingLabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

- (IBAction)openAction:(id)sender;
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;


- (id)initwithInvestType:(WantInvestType)type;
@end
