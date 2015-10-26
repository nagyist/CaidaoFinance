//
//  AvatarViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/24.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "AvatarViewController.h"
#import "PicCell.h"
#import "GZNetConnectManager.h"
#import <UIImageView+WebCache.h>

@interface AvatarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray * picData;
    NSString * picUrl;
}

@end

@implementation AvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"默认头像";
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    picData = [NSArray new];
    
    [self loadData];
    
    _avatarImg.layer.masksToBounds = YES;
    _avatarImg.layer.cornerRadius = 35;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setShowsVerticalScrollIndicator:NO];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[PicCell class] forCellWithReuseIdentifier:@"PicCell"];
    [_scrollView setDelaysContentTouches:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,USERHEAD] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            NSDictionary * dic = JSON(returnData);
            picData = [dic allValues];
            [_collectionView reloadData];
        }
    }];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * url = [NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,picData[indexPath.row]];
    picUrl = picData[indexPath.row];
    [_avatarImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [picData count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PicCell";
    PicCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString * url = [NSString stringWithFormat:@"%@%@",TEST_IMG_NETADDRESS,picData[indexPath.row]];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:UIIMAGE(@"avatar_icon_default")];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 10, 7);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width / 5 - 28;
    return CGSizeMake(width, width);
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

- (IBAction)sureAction:(id)sender {
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?PHOTO=%@",TEST_NETADDRESS,UPDATEAVATAR,picUrl] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        if (bSuccess) {
            if ([_delegate respondsToSelector:@selector(didSelectedAvatarUrl:)]) {
                [_delegate didSelectedAvatarUrl:picUrl];
            }
            [self.navigationController popViewControllerAnimated:YES];

        }
    }];

    }
@end
