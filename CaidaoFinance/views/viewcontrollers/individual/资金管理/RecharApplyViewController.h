//
//  RecharApplyViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@interface RecharApplyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgBg1;
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICountingLabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *card;

@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *sms;
- (id)initWithAccountData:(NSDictionary*)accountData;
@property (weak, nonatomic) IBOutlet UIButton *vertyButton;

- (IBAction)vertyAction:(id)sender;
@end
