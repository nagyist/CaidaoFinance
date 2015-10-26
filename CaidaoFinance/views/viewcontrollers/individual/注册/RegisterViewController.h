//
//  RegisterViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *checkone;
@property (weak, nonatomic) IBOutlet UIButton *checktwo;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *vertyText;
- (IBAction)vertyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *code;

- (IBAction)checkOneAction:(id)sender;
- (IBAction)checkTwoAction:(id)sender;
- (IBAction)xieyi:(id)sender;
- (IBAction)tiaokuan:(id)sender;
- (IBAction)registerAction:(id)sender;
@end
