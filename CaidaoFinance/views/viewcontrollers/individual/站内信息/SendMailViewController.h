//
//  SendMailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *text;
- (id)initWithFriendData:(NSDictionary*)friendData;

@end
