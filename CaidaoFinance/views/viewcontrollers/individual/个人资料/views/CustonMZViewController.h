//
//  CustonMZViewController.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MZViewContentDelegate <NSObject>

//- (void)didSelectedItem:(NSInteger)index

@end
typedef NS_ENUM(NSInteger, MZViewContentStyle) {
    MZViewContentStyleEducation = 0,
    MZViewContentStyleJob,
    MZViewContentStyleBank,
};
@interface CustonMZViewController :UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) MZViewContentStyle style;
- (id)initWithDatas:(NSArray*)data;

@property (nonatomic)CGSize itemSize;

@end
