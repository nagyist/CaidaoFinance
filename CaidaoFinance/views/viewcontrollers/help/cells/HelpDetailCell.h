//
//  HelpDetailCell.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/30.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *head;

-(CGFloat)calulateHeightWithDesrip:(NSString *)str head:(NSString*)head;

@end
