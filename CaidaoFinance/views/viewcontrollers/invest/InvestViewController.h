//
//  InvestViewController.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@interface InvestViewController : CaidaoViewController
@property (weak, nonatomic) IBOutlet UIButton *leftSegment;
@property (weak, nonatomic) IBOutlet UIButton *rightSegment;
- (IBAction)segmentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
