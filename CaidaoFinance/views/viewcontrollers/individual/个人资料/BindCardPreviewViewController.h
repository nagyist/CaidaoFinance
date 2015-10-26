//
//  BindCardPreviewViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindCardPreviewViewController : UIViewController

- (id)initWithBinbankData:(NSDictionary*)bindData;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankArea;
@property (weak, nonatomic) IBOutlet UILabel *bankAreaName;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;

@end
