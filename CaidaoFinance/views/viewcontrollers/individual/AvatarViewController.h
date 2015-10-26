//
//  AvatarViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/24.
//  Copyright (c) 2015年 zwj. All rights reserved.
//



#import <UIKit/UIKit.h>
@protocol AvatarDelegate <NSObject>
- (void)didSelectedAvatarUrl:(NSString *)url;

@end


@interface AvatarViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)sureAction:(id)sender;

@property (nonatomic,strong)id<AvatarDelegate>delegate;

@end
