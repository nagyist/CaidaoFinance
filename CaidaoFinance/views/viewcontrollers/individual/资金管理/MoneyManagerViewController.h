//
//  MoneyManagerViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@interface MoneyManagerViewController : UIViewController
- (IBAction)action:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithIndiviData:(NSDictionary*)inData;
@property (weak, nonatomic) IBOutlet UICountingLabel *moneyOne;
@property (weak, nonatomic) IBOutlet UICountingLabel *moneyTwo;
@property (weak, nonatomic) IBOutlet UICountingLabel *moneyThree;
@property (weak, nonatomic) IBOutlet UICountingLabel *moneyFour;

@end
