//
//  InsMessageDetailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsMessageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *msgTitle;

- (id)initWithDetailData:(NSDictionary *)data;

@end
