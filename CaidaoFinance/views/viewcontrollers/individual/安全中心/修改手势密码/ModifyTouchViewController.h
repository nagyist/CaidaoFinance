//
//  ModifyTouchViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyTouchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *passTitle;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)sureAction:(id)sender;

- (IBAction)forgetAction:(id)sender;
@end
