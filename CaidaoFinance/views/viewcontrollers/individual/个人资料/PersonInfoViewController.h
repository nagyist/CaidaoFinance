//
//  PersonInfoViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/24.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController
- (IBAction)cellAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *yzlabel;
@property (weak, nonatomic) IBOutlet UILabel *bindingLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *tel;

- (id)initWithPersonData:(NSDictionary*)data;

@end
