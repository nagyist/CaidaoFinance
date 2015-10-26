//
//  RecommandCodeViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommandCodeViewController : UIViewController
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtOne;
@property (weak, nonatomic) IBOutlet UITextField *txtTwo;

@end
