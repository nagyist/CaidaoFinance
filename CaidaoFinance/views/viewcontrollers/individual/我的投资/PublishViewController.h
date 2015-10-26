//
//  PublishViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractListView.h"
#import <UICountingLabel.h>

@interface PublishViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg1;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)publishAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConHeight;

@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UICountingLabel *transfercost;
@property (weak, nonatomic) IBOutlet ContractListView *contractView;
- (id)initWithPostdata:(NSDictionary*)postData;

@end
