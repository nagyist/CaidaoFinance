//
//  LocationCollectionViewCell.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "LocationCollectionViewCell.h"

@implementation LocationCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

-(id)init
{
    self = [super init];
    if (self) {
        
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

- (IBAction)buttonAction:(id)sender {
}
@end
