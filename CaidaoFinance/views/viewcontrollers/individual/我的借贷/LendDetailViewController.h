//
//  LendDetailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LendDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (id)initWithBorrowerData:(NSDictionary*)data;

@end
