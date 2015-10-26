//
//  CreditViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditViewController : UIViewController

- (id)initWithDetailData:(NSDictionary*)data;

@property (weak, nonatomic) IBOutlet UILabel *bishu;
@property (weak, nonatomic) IBOutlet UILabel *cishu;
@property (weak, nonatomic) IBOutlet UILabel *jieru;
@property (weak, nonatomic) IBOutlet UILabel *yuqi;
@property (weak, nonatomic) IBOutlet UILabel *zonge;
@property (weak, nonatomic) IBOutlet UILabel *huan;

@end
