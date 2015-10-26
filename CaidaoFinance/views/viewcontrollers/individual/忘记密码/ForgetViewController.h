//
//  ForgetViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetViewController : UIViewController
- (IBAction)nextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *verText;
- (IBAction)vertyAction:(id)sender;

@end
