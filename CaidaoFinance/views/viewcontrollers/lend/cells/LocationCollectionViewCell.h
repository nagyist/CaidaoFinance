//
//  LocationCollectionViewCell.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/13.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCollectionViewCell : UICollectionViewCell
- (IBAction)buttonAction:(id)sender;

@property (strong, nonatomic) UIButton *button;

@property (nonatomic,strong)NSString * text;


@end
