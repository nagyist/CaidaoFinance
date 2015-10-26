//
//  MessageTableViewCell.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/22.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *text;
-(CGFloat)calulateHeightWithDesrip:(NSString *)str;
@end
