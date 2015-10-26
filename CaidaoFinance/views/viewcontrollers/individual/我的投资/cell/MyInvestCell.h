//
//  MyInvestCell.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@protocol MyInvestDelegate <NSObject>

- (void)didMakeOver:(NSInteger)index;
- (void)didWatch:(NSInteger)index;

@end

@interface MyInvestCell : UITableViewCell
- (IBAction)watchAction:(id)sender;
- (IBAction)makeoverAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *investTime;
@property (weak, nonatomic) IBOutlet UILabel *state;

@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (nonatomic,strong)id<MyInvestDelegate>delegate;
@end
