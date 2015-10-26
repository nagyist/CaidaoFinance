//
//  ApplyMakeoverViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@interface ApplyMakeoverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIView *viewone;
@property (weak, nonatomic) IBOutlet UIView *viewtwo;
@property (weak, nonatomic) IBOutlet UIView *viewthree;
@property (weak, nonatomic) IBOutlet UIView *viewfour;
- (IBAction)nextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UICountingLabel *benjinyue;
@property (weak, nonatomic) IBOutlet UICountingLabel *jujianfuwufei;
@property (weak, nonatomic) IBOutlet UILabel *qixianlabel;
- (id)initWithApplyDetailData:(NSDictionary*)data;

@end
