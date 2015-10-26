//
//  RegisterSecondViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterSecondViewController : UIViewController
- (IBAction)nextAction:(id)sender;

- (id)initWithPostData:(NSMutableDictionary*)data;

@property (weak, nonatomic) IBOutlet UITextField *pswTxtOne;
@property (weak, nonatomic) IBOutlet UITextField *pswTxtTwo;
@end
