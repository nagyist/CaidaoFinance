//
//  NounDetailViewController.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/8.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@interface NounDetailViewController : CaidaoViewController

-(id)initWithContent:(NSString*)detail title:(NSString*)title;

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *text;
@end
