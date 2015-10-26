//
//  InputPassViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/19.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayType)
{
    PayTypeInvest = 0
};

@interface InputPassViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic)PayType type;


- (IBAction)suerAction:(id)sender;

- (id)initWithInvestData:(NSDictionary *)investData price:(CGFloat)price redNumber:(NSInteger)red  isRedBool:(BOOL)isRed;
@end
