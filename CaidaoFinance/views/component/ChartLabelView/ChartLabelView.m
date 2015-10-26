//
//  ChartLabelView.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/31.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ChartLabelView.h"

@implementation ChartLabelView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

- (void)setDatas:(NSArray *)datas
{
    UILabel*last_l = nil;
    CGFloat marginX = (self.frame.size.width - 27)/[datas count];
    if (datas) {
        [datas enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL*stop)
         {
             UILabel*label = [UILabel new];
             label.text = (NSString*)obj;
             label.textAlignment = NSTextAlignmentCenter;
             label.textColor = [UIColor lightGrayColor];
             label.font = [UIFont systemFontOfSize:10];
             label.backgroundColor = [UIColor clearColor];
             [self addSubview:label];
             [label mas_makeConstraints:^(MASConstraintMaker*make)
              {
                  make.left.equalTo(@(27+marginX*idx));
                  make.top.equalTo(@5);
                  
              }];
         }];
    }
    _datas = datas;
}


@end
