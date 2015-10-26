//
//  InvestCell.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InvestCell.h"

@implementation InvestCell

- (void)awakeFromNib {
    // Initialization code
  
    
}

- (void)setProgress:(CGFloat)progress
{
    _progressBar.type = YLProgressBarTypeRounded;
    [_progressBar setProgressTintColors:@[RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198)]];
    [_progressBar setTrackTintColor:[UIColor clearColor]];
    [_progressBar setIndicatorTextDisplayMode:YLProgressBarIndicatorTextDisplayModeNone];
    _progressBar.behavior                 = YLProgressBarBehaviorIndeterminate;

    [_progressBar setProgress:progress animated:YES];
    [_progressBar setHideGloss:YES];
}

-(void)setType:(InvestType)type
{
    switch (type) {
        case InvestTypeInvest:
//            self.titleLabel.text = @"投资项目编号";
            break;
        case InvestTypeTransfer:
//            self.titleLabel.text = @"转让项目编号";
            self.rewardLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)investAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didInvest:type:)]) {
        [_delegate didInvest:self.tag type:self.type];
    }
}
@end
