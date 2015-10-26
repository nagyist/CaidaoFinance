//
//  IndexProductTableViewCell.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/6.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel.h>

@protocol ProduceCellDelegate <NSObject>

- (void)didSelectedProduct:(NSInteger)productIndex;

@end
@interface IndexProductTableViewCell : UITableViewCell

@property (nonatomic,strong)id<ProduceCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

- (IBAction)investAction:(id)sender;
@end
