//
//  LendViewController.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/8.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@interface LendViewController : CaidaoViewController
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *submitImage;
- (IBAction)sexAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UIView *jiekuanview;
@property (weak, nonatomic) IBOutlet UITextField *priceTxt;
@property (weak, nonatomic) IBOutlet UITextField *qixiantxt;
@property (weak, nonatomic) IBOutlet UITextField *telTxt;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)phoneAction:(id)sender;

- (IBAction)locationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UIImageView *menuImage;
@end
