//
//  IndexProductTableViewCell.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/6.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "IndexProductTableViewCell.h"

@implementation IndexProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)investAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelectedProduct:)]) {
        [_delegate didSelectedProduct:self.tag];
    }
}
@end
