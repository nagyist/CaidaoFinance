//
//  HelpDetailViewController.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/7.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@interface HelpDetailViewController : CaidaoViewController

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

//1 欢迎加入我们  2如何投资  3免责声明
-(id)initWithName:(NSString*)name type:(NSInteger)index;
@end
