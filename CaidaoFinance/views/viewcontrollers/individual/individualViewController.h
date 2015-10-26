//
//  individualViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/20.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@interface individualViewController : CaidaoViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *zongjine;
@property (weak, nonatomic) IBOutlet UILabel *keyongjine;
@property (weak, nonatomic) IBOutlet UILabel *redpackage;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
- (IBAction)signAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signButton;

- (IBAction)photoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
- (IBAction)buttonAction:(id)sender;
- (IBAction)infoAction:(id)sender;
@end
