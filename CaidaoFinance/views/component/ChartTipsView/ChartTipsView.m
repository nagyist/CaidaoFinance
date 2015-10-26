//
//  ChartTipsView.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/29.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ChartTipsView.h"

@interface ChartTipsView ()
{
    UILabel * title;
}

@end

@implementation ChartTipsView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImageView*image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    image.image = UIIMAGE(@"individual_chart_alert_bg");
    [self addSubview:image];
    
    title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = RGBCOLOR(139, 32, 35);
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.centerX.equalTo(self.mas_centerX);
         make.centerY.equalTo(self.mas_centerY);
     }];
}

- (void)setText:(NSString *)text{
    title.text = text;
    [title mas_updateConstraints:^(MASConstraintMaker*make)
     {
         make.centerX.equalTo(self.mas_centerX);
         make.centerY.equalTo(self.mas_centerY);
     }];

}

- (void)setup
{
    
}

@end
