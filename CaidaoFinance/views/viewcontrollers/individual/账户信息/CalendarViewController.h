//
//  CalendarViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@interface CalendarViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UILabel *left;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg2;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (nonatomic,strong)NSMutableDictionary * activity;
@property (weak, nonatomic) IBOutlet UICountingLabel *benjin;
@property (weak, nonatomic) IBOutlet UICountingLabel *lixi;
@property (weak, nonatomic) IBOutlet UICountingLabel *fuwu;
@property (weak, nonatomic) IBOutlet UICountingLabel *zonge;



@end
