//
//  ChooseLocationViewController.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/12.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@protocol ChooseViewControllerDelegate <NSObject>

- (void)didChooseArea:(NSArray*)data;

@end

@interface ChooseLocationViewController : CaidaoViewController
@property (weak, nonatomic) IBOutlet UILabel *provinceName;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)areaAction:(id)sender;


@property (nonatomic,strong)id<ChooseViewControllerDelegate>delegate;
@end
