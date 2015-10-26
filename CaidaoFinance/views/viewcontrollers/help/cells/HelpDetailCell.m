//
//  HelpDetailCell.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/30.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "HelpDetailCell.h"

@implementation HelpDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(CGFloat)calulateHeightWithDesrip:(NSString *)str head:(NSString *)head
{
    CGFloat preMaxWaith = GZContent_Width - 40;
    [self.head setPreferredMaxLayoutWidth:preMaxWaith];
    self.head.numberOfLines = 0;
    [self.content setPreferredMaxLayoutWidth:preMaxWaith];
    self.content.numberOfLines = 0;
    [self.content setText:str];
    [self.head setText:head];
    [self.head layoutIfNeeded];
    [self.content layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

@end
