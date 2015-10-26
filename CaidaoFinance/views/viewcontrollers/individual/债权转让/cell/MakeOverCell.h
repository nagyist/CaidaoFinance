//
//  MakeOverCell.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLProgressBar.h>
#import <UICountingLabel.h>

@interface MakeOverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *percent;
- (void)setProgress:(CGFloat)progress;
@end
