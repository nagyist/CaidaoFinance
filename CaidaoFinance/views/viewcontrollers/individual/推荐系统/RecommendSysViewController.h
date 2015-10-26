//
//  RecommendSysViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendSysViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *code;
- (IBAction)cellAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)copyAction:(id)sender;
@end
