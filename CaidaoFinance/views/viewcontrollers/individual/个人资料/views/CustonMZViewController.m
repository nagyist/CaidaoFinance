//
//  CustonMZViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CustonMZViewController.h"
#import "InfoCell.h"

@interface CustonMZViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray * collectionDatas;
}

@end

@implementation CustonMZViewController

- (id)initWithDatas:(NSArray *)data
{
    self = [super init];
    if (self) {
        collectionDatas = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitle];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView setShowsVerticalScrollIndicator:NO];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[InfoCell class] forCellWithReuseIdentifier:@"InfoCell"];
    // Do any additional setup after loading the view from its nib.
}

#pragma  mark settitle
- (void)settitle{
    switch (self.style) {
        case MZViewContentStyleEducation:
            self.titleLabel.text = @"选择教育程度";
            break;
        case MZViewContentStyleJob:
            self.titleLabel.text = @"选择从事职业";
            break;
        case MZViewContentStyleBank:
            self.titleLabel.text = @"选择开户银行";
            break;
            
        default:
            break;
    }
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InfoCell * cell = (InfoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell select];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MZViewControllerSelected" object:nil userInfo:@{@"text":collectionDatas[indexPath.row],@"id":self}];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [collectionDatas count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"InfoCell";
    InfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.button setTitle:collectionDatas[indexPath.row] forState:UIControlStateNormal];
    [cell.button setTitle:collectionDatas[indexPath.row] forState:UIControlStateSelected];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemSize;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
