//
//  ModifyTradPassViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyTradPassViewController : UIViewController
//view2
- (IBAction)nextAction:(id)sender;
- (IBAction)vertyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt5;
@property (weak, nonatomic) IBOutlet UITextField *txt4;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic)BOOL showSet;

- (IBAction)segmentAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *rightSegment;

@property (weak, nonatomic) IBOutlet UIButton *leftSegment;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view1;

//view1
- (IBAction)sureAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@end
