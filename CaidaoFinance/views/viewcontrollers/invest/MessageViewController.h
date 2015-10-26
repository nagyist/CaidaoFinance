//
//  MessageViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/22.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
- (IBAction)cellAction:(id)sender;
- (IBAction)sendAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithInvestData:(NSDictionary*)investData;

@end
