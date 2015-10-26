//
//  InvestDetailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestDetailViewController : UIViewController
- (IBAction)buttonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *scrollbar;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBarCons;
- (IBAction)closeAction:(id)sender;

- (id)initWithInvestDetailData:(NSDictionary*)data;

@end
