//
//  SearchView.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/15.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "SearchView.h"
#import "SKTagView.h"

@interface SearchView ()
{
    SKTagView * tagOne;
    SKTagView * tagTwo;
    SKTagView * tagThree;
    SKTagView * tagFour;
    
    NSInteger tagOneIndex;
    NSInteger tagTwoIndex;
    NSInteger tagThreeIndex;
    NSInteger tagFourIndex;

}

@end

@implementation SearchView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setup];
}



-(void)setup
{
//    UIImageView * textBg = [[UIImageView alloc] initWithImage:UIIMAGE(@"invest_searchtext_bg")];
//    [textBg setFrame:CGRectZero];
//    [self addSubview:textBg];
//    [textBg mas_makeConstraints:^(MASConstraintMaker*make)
//     {
//         make.left.equalTo(@15);
//         make.top.equalTo(@30);
//         
//     }];
    
//    
//    UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectZero];
//    [textfield setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:16]];
//    [textfield setPlaceholder:@"输入关键字"];
//    [self addSubview:textfield];
//    [textfield setTextColor:RGBCOLOR(145,34,37)];
//    [textfield mas_makeConstraints:^(MASConstraintMaker*make)
//     {
//         UIEdgeInsets padding = UIEdgeInsetsMake(0, 10, 0, 5);
//         make.edges.equalTo(textBg).with.insets(padding);
//     }];
    
    UILabel * labelOne = [[UILabel alloc] initWithFrame:CGRectZero];
    labelOne.text = @"年化利率:";
    labelOne.textColor = [UIColor whiteColor];
    labelOne.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15];
    [self addSubview:labelOne];
    
    [labelOne mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@20);
         make.top.equalTo(@20);
         make.width.mas_equalTo(70);
     }];
    
    tagOne = [[SKTagView alloc] initWithFrame:CGRectZero];
    tagOne.backgroundColor = [UIColor clearColor];
    tagOne.padding = UIEdgeInsetsMake(0, 5, 5, 5);
    tagOne.insets = 5;
    tagOne.lineSpace = 8;
    tagOne.didClickTagAtIndex = ^(NSUInteger index)
    {
        NSLog(@"%ld",index);
        tagOneIndex = index;
        
    };
    [self addSubview:tagOne];

    [tagOne mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.top.equalTo(labelOne.mas_top).offset(0);
         make.left.equalTo(labelOne.mas_right).with.offset(10);
         make.right.equalTo(@-10);
     }];
    [@[@"不限",@"12%以下",@"12％－15%",@"15%－18%",@"18%以上"] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop)
     {
         SKTag * tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.textSelectColor = RGBCOLOR(145,34,37);
         tag.cornerRadius = 6;
         tag.borderColor = [UIColor whiteColor];
         tag.borderWidth = 1;
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(0, 6, 0, 6);
         [tagOne addTag:tag];
     }];
    
    UILabel * labelTwo = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTwo.text = @"借款期限:";
    labelTwo.textColor = [UIColor whiteColor];
    labelTwo.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15];
    [self addSubview:labelTwo];
    
    [labelTwo mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@20);
         make.top.equalTo(tagOne.mas_bottom).equalTo(@15);
         make.width.mas_equalTo(70);
     }];
    
    tagTwo = [[SKTagView alloc] initWithFrame:CGRectZero];
    tagTwo.backgroundColor = [UIColor clearColor];
    tagTwo.padding = UIEdgeInsetsMake(0, 5, 5, 5);
    tagTwo.insets = 5;
    tagTwo.lineSpace = 8;
    [tagTwo setSelectedIndex:0];
    tagTwo.didClickTagAtIndex = ^(NSUInteger index)
    {
        NSLog(@"%ld",index);
        tagTwoIndex = index;


    };
    [self addSubview:tagTwo];

    [tagTwo mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.top.equalTo(labelTwo.mas_top).offset(0);
         make.left.equalTo(labelTwo.mas_right).with.offset(10);
         make.right.equalTo(@-10);
     }];
    [@[@"不限",@"1月以下",@"1-3月",@"3-6月",@"6-12月",@"12月以上"] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop)
     {
         SKTag * tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.textSelectColor = RGBCOLOR(145,34,37);
         tag.cornerRadius = 6;
         tag.borderColor = [UIColor whiteColor];
         tag.borderWidth = 1;
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(0, 6, 0, 6);
         [tagTwo addTag:tag];
     }];
    
    UILabel * labelThree = [[UILabel alloc] initWithFrame:CGRectZero];
    labelThree.text = @"起投金额:";
    labelThree.textColor = [UIColor whiteColor];
    labelThree.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15];
    [self addSubview:labelThree];
    
    [labelThree mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@20);
         make.top.equalTo(tagTwo.mas_bottom).equalTo(@15);
         make.width.mas_equalTo(70);
     }];
    
    tagThree = [[SKTagView alloc] initWithFrame:CGRectZero];
    tagThree.backgroundColor = [UIColor clearColor];
    tagThree.padding = UIEdgeInsetsMake(0, 5, 5, 5);
    tagThree.insets = 5;
    tagThree.lineSpace = 8;
    tagThree.didClickTagAtIndex = ^(NSUInteger index)
    {
        NSLog(@"%ld",index);
        tagThreeIndex = index;

    };
    [self addSubview:tagThree];
    
    [tagThree mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.top.equalTo(labelThree.mas_top).offset(0);
         make.left.equalTo(labelThree.mas_right).with.offset(10);
         make.right.equalTo(@-10);
     }];
    [@[@"不限",@"￥1000~￥5000",@"￥5000~￥10000",@"￥10000以上"] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop)
     {
         SKTag * tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.textSelectColor = RGBCOLOR(145,34,37);
         tag.cornerRadius = 6;
         tag.borderColor = [UIColor whiteColor];
         tag.borderWidth = 1;
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(0, 6, 0, 6);
         [tagThree addTag:tag];
     }];
    
    UILabel * labelFour = [[UILabel alloc] initWithFrame:CGRectZero];
    labelFour.text = @"投标状态:";
    labelFour.textColor = [UIColor whiteColor];
    labelFour.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15];
    [self addSubview:labelFour];
    
    [labelFour mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@20);
         make.top.equalTo(tagThree.mas_bottom).equalTo(@15);
         make.width.mas_equalTo(70);
     }];
    
    tagFour = [[SKTagView alloc] initWithFrame:CGRectZero];
    tagFour.backgroundColor = [UIColor clearColor];
    tagFour.padding = UIEdgeInsetsMake(0, 5, 5, 5);
    tagFour.insets = 5;
    tagFour.lineSpace = 8;
    tagFour.didClickTagAtIndex = ^(NSUInteger index)
    {
        NSLog(@"%ld",index);
        tagFourIndex = index;

    };
    [self addSubview:tagFour];
    
    [tagFour mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.top.equalTo(labelFour.mas_top).offset(0);
         make.left.equalTo(labelFour.mas_right).with.offset(10);
         make.right.equalTo(@-10);
 
     }];
    [@[@"不限",@"正在招标",@"满标审核",@"正在还款",@"成功借款"] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop)
     {
         SKTag * tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.textSelectColor = RGBCOLOR(145,34,37);
         tag.cornerRadius = 6;
         tag.borderColor = [UIColor whiteColor];
         tag.borderWidth = 1;
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(0, 6, 0, 6);
         [tagFour addTag:tag];
     }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagFour.mas_bottom).equalTo(@15);
        make.left.equalTo(@0);
        make.width.equalTo(self);
        make.height.equalTo(@1);

    }];
    
    UIButton * cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbutton setTitle:@"查询" forState:UIControlStateNormal];
    [cancelbutton.titleLabel setTextColor:RGBCOLOR(237, 231, 231)];
    [cancelbutton.titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:16]];
    [cancelbutton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelbutton];
    [cancelbutton mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.top.equalTo(tagFour.mas_bottom).equalTo(@20);
         make.centerX.equalTo(self);
         make.width.equalTo(self);
     }];

}

-(void)cancelAction:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(didSearch:)]) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%ld",tagOneIndex],@"one",
                              [NSString stringWithFormat:@"%ld",tagTwoIndex],@"two",
                              [NSString stringWithFormat:@"%ld",tagThreeIndex],@"three",
                              [NSString stringWithFormat:@"%ld",tagFourIndex],@"four", nil];
        
        NSLog(@"%@",dic);
        [_delegate didSearch:dic];
    }
}

@end
