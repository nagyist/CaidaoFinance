//
//  AccountInfoViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartLabelView.h"
#import <UICountingLabel.h>

@interface AccountInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)calendarAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet ChartLabelView *labelView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;

- (id)initWithPersonData:(NSDictionary*)personData;

@end
