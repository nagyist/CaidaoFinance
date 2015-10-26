//
//  RegisterThirdViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/1.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterThirdViewController : UIViewController
- (IBAction)completeAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)areaAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *card;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UITextField *addreaaText;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
- (id)initWithPostData:(NSMutableDictionary*)data;

@end
