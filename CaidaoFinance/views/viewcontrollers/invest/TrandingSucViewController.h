//
//  TrandingSucViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/19.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@interface TrandingSucViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

- (IBAction)investAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICountingLabel *touzi;
@property (weak, nonatomic) IBOutlet UICountingLabel *yue;

@property (weak, nonatomic) IBOutlet UILabel *date;
- (id)initWithSuccessData:(NSDictionary*)dic price:(CGFloat)price;
@end
