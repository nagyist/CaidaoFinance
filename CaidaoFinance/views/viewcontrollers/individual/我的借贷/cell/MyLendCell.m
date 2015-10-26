//
//  MyLendCell.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MyLendCell.h"

@implementation MyLendCell

- (void)awakeFromNib {
    // Initialization code
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
