//
//  InfoCell.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)selectAction:(id)sender;
- (void)select;
@end
