//
//  LocationCell.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        [_button setUserInteractionEnabled:NO];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [_button setSelected:selected];
}

-(void)setText:(NSString *)text
{
    [_button setTitle:text forState:UIControlStateNormal];
    [_button setTitle:text forState:UIControlStateSelected];
}



@end
