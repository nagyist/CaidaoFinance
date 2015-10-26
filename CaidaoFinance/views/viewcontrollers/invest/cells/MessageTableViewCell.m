//
//  MessageTableViewCell.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/22.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)calulateHeightWithDesrip:(NSString *)str
{
    CGFloat preMaxWaith =self.text.frame.size.width - 5;
    [self.text setPreferredMaxLayoutWidth:preMaxWaith];
    self.text.numberOfLines = 0;
    [self.text layoutIfNeeded];
    self.text.text = str;
    [self.text updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}


@end
