//
//  AddFriendViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AddFriendType) {
    AddFriendTypeCode = 0,
    AddFriendTypeTel,
    AddFriendTypeName
};


@interface AddFriendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *LabelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
- (IBAction)sureAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtTwo;
@property (weak, nonatomic) IBOutlet UITextField *txtOne;

@property (nonatomic)AddFriendType type;

- (id)initWithQscanData:(NSString*)data;

@end
