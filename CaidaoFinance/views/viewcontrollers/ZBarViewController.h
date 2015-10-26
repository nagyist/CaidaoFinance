//
//  ZBarViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/3.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZBarReaderView.h>

@interface ZBarViewController : UIViewController
@property (weak, nonatomic) IBOutlet ZBarReaderView *readerView;
@property (weak, nonatomic) IBOutlet UIView *redLine;


@end
