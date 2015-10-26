//
//  InvestCell.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLProgressBar.h>
#import <UICountingLabel.h>

@protocol InvestCellDelegate;

typedef NS_ENUM (NSUInteger, InvestType)
{
    /**
     * 直投
     */
    InvestTypeInvest = 0,
    /**
     * 债权转让
     */
    InvestTypeTransfer = 1,
};

@interface InvestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressValue;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,assign) BOOL isReward;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UICountingLabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic,strong)id<InvestCellDelegate>delegate;

@property (nonatomic)InvestType type;
- (IBAction)investAction:(id)sender;

- (void)setProgress:(CGFloat)progress;

@end

@protocol InvestCellDelegate <NSObject>

-(void)didInvest:(NSInteger)index type:(InvestType)type;


@end