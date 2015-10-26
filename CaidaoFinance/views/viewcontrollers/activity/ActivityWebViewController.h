//
//  ActivityWebViewController.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/6.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityWebViewController : UIViewController
- (id)initWithURL:(NSURL*)url;

- (id)initWithURL:(NSURL *)url isActivity:(BOOL)activity;
@end
