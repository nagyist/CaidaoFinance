//
//  DetalViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

- (id)initWithDetailData:(NSDictionary*)data;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *yewu;
@property (weak, nonatomic) IBOutlet UILabel *shouru;
@property (weak, nonatomic) IBOutlet UILabel *yongtu;
@property (weak, nonatomic) IBOutlet UILabel *laiyuan;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *zhizhao;
@property (weak, nonatomic) IBOutlet UILabel *gongzhang;
@end
