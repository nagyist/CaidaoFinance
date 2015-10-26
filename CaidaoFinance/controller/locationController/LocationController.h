//
//  LocationController.h
//  GAZREY.FRAME
//
//  Created by ZhuWeijie on 14-5-15.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PlaceItem.h"

static NSString *const kLocationManagerNotificationLocationUpdatedName = @"kLocationManagerNotificationLocationUpdatedName";
static NSString *const kLocationManagerNotificationFailedName = @"kLocationManagerNotificationFailed";


static NSString *const kLocationManagerNotificationAuthorizationChangedName = @"kLocationManagerNotificationAuthorizationChangedName";

@protocol LocationControllerDelegate <NSObject>

-(void)didUpDateLocations:(CLLocationManager*)manager place:(NSArray*)place locaitons:(NSArray*)locations;
-(void)didChangedStatusToAuthorized:(CLLocationManager*)manager;
-(void)didChangedStatusToDenied:(CLLocationManager*)manager;

@end

@interface LocationController : NSObject<CLLocationManagerDelegate>

@property (nonatomic) BOOL locationEnabled;

@property (nonatomic,strong)PlaceItem * currentLocation;

+(LocationController*)locationInstance;

/*******CLLocationCoordinate2D对象 参数dic里的参数名:latitude(纬度) longitude(经度) ********/

-(CLLocationCoordinate2D)getCLLocationCoordinate2D;

//开始定位
-(void)startLocation;

- (void)stopLocationUpdates;
-(void)startLocationUpdates;



//保存当前经纬度到本地

-(void)saveCLLocation:(CLLocation*)location;

@property (nonatomic , retain) CLLocationManager * locationManager;
@property (nonatomic , assign)id<LocationControllerDelegate>delegate;

@end
