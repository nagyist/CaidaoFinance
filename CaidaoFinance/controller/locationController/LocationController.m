//
//  LocationController.m
//  GAZREY.FRAME
//
//  Created by ZhuWeijie on 14-5-15.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "LocationController.h"
#import "PlaceItem.h"


#define DISTANCE_REFRESH 500  //距离过滤

static LocationController * locationControllerInstance;

@implementation LocationController

-(CLLocationCoordinate2D)getCLLocationCoordinate2D
{
    CLLocationDegrees latitude= [USER_DEFAULT doubleForKey:USER_DEFAULT_CLLOCATION_LATITUDE];
    CLLocationDegrees longitude=[USER_DEFAULT doubleForKey:USER_DEFAULT_CLLOCATION_LONGITUDE];
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
    
    return location;
}

-(PlaceItem*)currentLocation
{
    return self.currentLocation;
}


- (void)stopLocationUpdates
{
    [self.locationManager stopUpdatingLocation];
}

-(void)startLocationUpdates
{
    [self.locationManager startUpdatingLocation];
}

/** 设备是否允许定位 **/
-(BOOL)locationEnabled
{
    return  [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
}

+(LocationController*)locationInstance
{
    static LocationController * locationControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        locationControllerInstance = [[self alloc] init];
    });
    return locationControllerInstance;
}


/**开始定位**/
-(void)startLocation
{
//    if ([self locationEnabled])
//    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
        [self.locationManager startUpdatingLocation];
//    }
}

#pragma mark - CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSMutableArray * locationsArr = [NSMutableArray new];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray * placemarks,NSError*error)
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
         }
            self.currentLocation = [locationsArr firstObject];
         [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerNotificationLocationUpdatedName
                                                             object:self];
//             [self.delegate didUpDateLocations:manager place:locationsArr locaitons:locations];
     }];
}




-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            // do
            break;
            
        case kCLAuthorizationStatusAuthorized:
       
            break;
            
        case kCLAuthorizationStatusRestricted:
            // next
        case kCLAuthorizationStatusDenied:
       
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerNotificationAuthorizationChangedName
                                                        object:self userInfo:@{@"status":@(status)}];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString * errorString = @"";
    switch ([error code]) {
            // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
            // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
        case kCLErrorDenied:
            errorString = @"需获取位置的授权";
            break;
        case kCLErrorLocationUnknown:
            errorString = @"获取位置信息出现未知错误";
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerNotificationFailedName
                                                        object:self userInfo:@{@"error":errorString}];
}


-(void)saveCLLocation:(CLLocation *)location
{
    [USER_DEFAULT setDouble:location.coordinate.latitude forKey:USER_DEFAULT_CLLOCATION_LATITUDE];
    [USER_DEFAULT setDouble:location.coordinate.longitude forKey:USER_DEFAULT_CLLOCATION_LONGITUDE];
}


@end
