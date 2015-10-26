//
//  ChooseLocationViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/12.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "LocationCell.h"
#import <MBLocationManager.h>
#import "PlaceItem.h"
#import "WGS84TOGCJ02.h"
#import "GZNetConnectManager.h"
#import "CTCommonUtils.h"
#import "SVProgressHUD.h"

@interface ChooseLocationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton * lastSelBtn;
    NSArray * locDatas;
    
    //省
    NSArray * provinces;
    //市
    NSArray * cities;
    //区
    NSArray * areas;
    
    NSArray * collectionDatas;
    
    BOOL isSelectedPro;
    BOOL isSelectedCity;
    bool isSelectedArea;
    
    NSInteger selectedIndex;
    
    NSMutableArray * location;
}

@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在地区";
    location = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLocation:)
                                                 name:kMBLocationManagerNotificationLocationUpdatedName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationManagerFailed:)
                                                 name:kMBLocationManagerNotificationFailedName
                                               object:nil];
    
    [_buttonOne setTintColor:[UIColor clearColor]];
    [_buttonTwo setTintColor:[UIColor clearColor]];
    [_buttonThree setTintColor:[UIColor clearColor]];
    [_buttonFour setTintColor:[UIColor clearColor]];
    lastSelBtn = _buttonOne;
    [self loadProvinceData];
    [self setup];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadAreaData:(NSInteger)index {
    
    switch (index) {
        case 0:
            [self loadProvinceData];
            break;
        case 1:
            [self loadCityData];
            break;
        case 2:
            [self loadAreaData];
            break;
        default:
            break;
    }
    
}

- (void)loadProvinceData {
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",TEST_NETADDRESS,GETPROVINCE] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if(bSuccess){
            provinces = JSON(returnData);
            collectionDatas = provinces;
            [_collectionView reloadData];
        }
    }];
}

- (void)loadCityData {
    NSString *str = [[location firstObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?areaName=%@",TEST_NETADDRESS,GETAREA,str] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if(bSuccess){
            cities = JSON(returnData);
            collectionDatas = cities;
            [_collectionView reloadData];
        }
    }];
}

- (void)loadAreaData {
    NSString *str = [location[1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [SVProgressHUD show];
    [[GZNetConnectManager sharedInstance] conURL:[NSString stringWithFormat:@"%@%@?areaName=%@",TEST_NETADDRESS,GETAREA,str] connectType:connectType_GET params:nil result:^(BOOL bSuccess, id returnData, NSError *error) {
        [SVProgressHUD dismiss];
        if(bSuccess){
            areas = JSON(returnData);
            collectionDatas = areas;
            [_collectionView reloadData];
        }
    }];
}

-(void)locationManagerFailed:(NSNotification*)notification
{
    NSLog(@"Location manager failed");
}

-(void)changeLocation:(NSNotification*)notification
{
    CLLocation*location = [[MBLocationManager sharedManager] currentLocation];
    
    NSMutableArray * locationsArr = [NSMutableArray new];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks,NSError*error)
     {
         for (CLPlacemark * mark in placemarks) {
             PlaceItem * item = [[PlaceItem alloc] init];
             item.location = mark.location;
             item.address  = [mark.addressDictionary objectForKey:@"Street"];
             item.city = mark.locality == nil? mark.administrativeArea : mark.locality;
             item.country = [mark.addressDictionary objectForKey:@"Country"];
             item.addressDictionary = mark.addressDictionary;
             item.region  = mark.region;
             item.name = mark.name;
             item.subThoroughfare = mark.subThoroughfare;
             item.subLocality = mark.subLocality;
             item.postalCode = mark.postalCode;
             item.ISOcountryCode = mark.ISOcountryCode;
             item.inlandWater = mark.inlandWater;
             item.ocean = mark.ocean;
             item.areasOfInterest = mark.areasOfInterest;
             [locationsArr addObject:item];
             PlaceItem*item2 = [locationsArr firstObject];
             _cityName.text = [item2.city substringToIndex:3];
         }}];
}



-(void)setup
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(13, 15);
//    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 5);
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 0;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setCollectionViewLayout:layout animated:YES];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[LocationCell class] forCellWithReuseIdentifier:@"LocationCell"];
    
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
    static NSString * CellIdentifier = @"LocationCell";
    NSDictionary * currentData = collectionDatas[indexPath.row];
    LocationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.text = [currentData objectForKey:@"areaName"];
    [location enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"celltext--%@|||obj%@",[currentData objectForKey:@"areaName"],obj);
        if ([[currentData objectForKey:@"areaName"] isEqualToString:(NSString*)obj]) {
            [cell.button setSelected:YES];
        }
    }];
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame)/3 - 20, 40);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedIndex) {
        case 0:
            isSelectedPro = YES;
            [location setObject:[[provinces objectAtIndex:indexPath.row] objectForKey:@"areaName"] atIndexedSubscript:0];
            break;
        case 1:
            isSelectedCity = YES;
            [location setObject:[[cities objectAtIndex:indexPath.row] objectForKey:@"areaName"] atIndexedSubscript:1];
            break;
        case 2:
            isSelectedArea = YES;
            [location setObject:[[areas objectAtIndex:indexPath.row] objectForKey:@"areaName"] atIndexedSubscript:2];
            break;
            
        default:
            break;
    }
    NSLog(@"%@",location);
    [self setAreaLabel];
    if (selectedIndex == 2) {
        
    }
    else
    {
        [self selectedTabButton:selectedIndex + 1];
    }
}


- (void)setAreaLabel {
  __block  NSString * locationStr = @"";
   [location enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if ([obj isKindOfClass:[NSString class]]) {
           if (idx != 2) {
               locationStr = [locationStr stringByAppendingString:[NSString stringWithFormat:@"%@-",obj]];
           }
           else
           {
               locationStr = [locationStr stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
           }
           
           self.provinceName.text = locationStr;
       
       }
   }];
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

-(void)completeAction
{
    if ([_delegate respondsToSelector:@selector(didChooseArea:)]) {
        [_delegate didChooseArea:location];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)areaAction:(id)sender {
  
    [self selectedTabButton:[sender tag]];
    if (lastSelBtn) {
        [lastSelBtn setSelected:NO];
    }
    selectedIndex = [sender tag];
    lastSelBtn = sender;
}

- (void)selectedTabButton:(NSInteger)tag {
    selectedIndex = tag;
    if (lastSelBtn) {
        [lastSelBtn setSelected:NO];
    }
    switch (tag) {
        case 0:
            [_buttonOne setSelected:YES];
            lastSelBtn = _buttonOne;
            break;
        case 1:
            if (isSelectedPro) {
                [_buttonTwo setSelected:YES];
                lastSelBtn = _buttonTwo;
            }
            else
            {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"请选择省份" alignment:CTCommonUtilsShowBottom];
                return;
            }
            break;
        case 2:
            if (isSelectedCity) {
                [_buttonThree setSelected:YES];
                lastSelBtn = _buttonThree;
            }
            else
            {
                [CTCommonUtils showAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withText:@"请选择城市" alignment:CTCommonUtilsShowBottom];
                return;
            }
            break;

            
        default:
            break;
    }
  
    [self loadAreaData:tag];
}
@end
