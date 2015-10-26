//
//  SettingViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/24.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
- (IBAction)switchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
- (IBAction)cellAction:(id)sender;
- (IBAction)outAction:(id)sender;

@end
