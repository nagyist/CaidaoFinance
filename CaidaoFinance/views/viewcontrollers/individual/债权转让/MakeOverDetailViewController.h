//
//  MakeOverDetailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLProgressBar.h>
#import "MZSelectableLabel.h"
#import <UICountingLabel.h>
#import "ContractListView.h"

@interface MakeOverDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;
- (IBAction)detailAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICountingLabel *zongjia;
@property (weak, nonatomic) IBOutlet UICountingLabel *yishoujine;
@property (weak, nonatomic) IBOutlet ContractListView *contractView;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *daoqiri;
@property (weak, nonatomic) IBOutlet UILabel *fangshi;
@property (weak, nonatomic) IBOutlet UILabel *oldcode;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *progressRate;

@property (weak, nonatomic) IBOutlet UILabel *code;
- (id)initWithMakeoverData:(NSDictionary *)data;
@end
