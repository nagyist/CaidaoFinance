//
//  FriendsCell.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendCellDelegate <NSObject>

- (void)sendMail:(NSInteger)index;

@end

@interface FriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
- (IBAction)mailAction:(id)sender;

@property (nonatomic,strong)id<FriendCellDelegate>delegate;

@end
