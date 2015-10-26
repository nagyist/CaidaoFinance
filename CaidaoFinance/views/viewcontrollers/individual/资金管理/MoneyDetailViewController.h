//
//  MoneyDetailViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger,MoneyDetailViewType){
    MoneyDetailViewTypeMoney = 0,
    MoneyDetailViewTypeRecharge
    
};


@interface MoneyDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UILabel *outprice;

@property (weak, nonatomic) IBOutlet UILabel *input;
- (IBAction)alertAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleTwo;
@property (weak, nonatomic) IBOutlet UILabel *titleThree;

@property (nonatomic)MoneyDetailViewType type;

- (IBAction)tabAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
