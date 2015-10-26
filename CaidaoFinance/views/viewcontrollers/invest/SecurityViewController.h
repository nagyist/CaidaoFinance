//
//  SecurityViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecurityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (id)initWithDetailData:(NSDictionary*)data;

@end
