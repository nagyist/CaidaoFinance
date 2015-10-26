//
//  BindCardViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *bankLcoaitonLabel;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
- (IBAction)bindAction:(id)sender;

- (IBAction)vertyAction:(id)sender;

- (IBAction)buttonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *bankAccoutOne;
@property (weak, nonatomic) IBOutlet UITextField *bankAccountTwo;
@property (weak, nonatomic) IBOutlet UITextField *vertyCode;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@end
