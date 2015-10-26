//
//  MyInvestCell.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MyInvestCell.h"

@implementation MyInvestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)watchAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didWatch:)]) {
        [_delegate didWatch:self.tag];
    }
}

- (IBAction)makeoverAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didMakeOver:)]) {
        [_delegate didMakeOver:self.tag];
    }
}
@end
