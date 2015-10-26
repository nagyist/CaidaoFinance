//
//  MessageCell.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

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

-(CGFloat)calulateHeightWithDesrip:(NSString *)str
{
    CGFloat preMaxWaith = GZContent_Width - 42;
    [self.text setPreferredMaxLayoutWidth:preMaxWaith];
    self.text.numberOfLines = 0;
    [self.text layoutIfNeeded];
    [self.text setText:str];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

@end
