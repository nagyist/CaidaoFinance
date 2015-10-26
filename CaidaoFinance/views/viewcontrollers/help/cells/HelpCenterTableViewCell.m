//
//  HelpCenterTableViewCell.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/7.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "HelpCenterTableViewCell.h"
@implementation HelpCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.bgImage.image = UIIMAGE(@"help_cell_bg_selected");
    }
    else
    {
        self.bgImage.image = UIIMAGE(@"help_cell_bg_normal");
    }
    // Configure the view for the selected state
}

@end
