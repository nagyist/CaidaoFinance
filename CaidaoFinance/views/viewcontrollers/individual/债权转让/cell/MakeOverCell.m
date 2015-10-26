//
//  MakeOverCell.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MakeOverCell.h"

@implementation MakeOverCell

- (void)awakeFromNib {
    // Initialization code
    _progressBar.type = YLProgressBarTypeRounded;
    [_progressBar setProgressTintColors:@[RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198),RGBCOLOR(28, 121, 198)]];
    [_progressBar setTrackTintColor:[UIColor grayColor]];
    [_progressBar setIndicatorTextDisplayMode:YLProgressBarIndicatorTextDisplayModeNone];
    _progressBar.behavior                 = YLProgressBarBehaviorIndeterminate;
    [_progressBar setHideTrack:YES];
    
}

- (void)setProgress:(CGFloat)progress
{
    [_progressBar setProgress:progress animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _bgImg.image = UIIMAGE(@"individual_message_cell_selected_bg");
    }
    else{
        _bgImg.image = UIIMAGE(@"individual_message_cell_bg");
    }
    // Configure the view for the selected state
}

@end
