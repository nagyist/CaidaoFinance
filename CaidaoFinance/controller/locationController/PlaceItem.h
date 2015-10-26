//
//  PlaceItem.h
//  GAZREY.FRAME
//
//  Created by ZhuWeijie on 14-5-16.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PlaceItem : NSObject

@property(nonatomic,strong)NSString * address; //街道地址
@property(nonatomic,strong)NSString * city;  //市  如江苏省
@property(nonatomic,strong)CLLocation * location;
@property(nonatomic,strong)NSString * country; //国家
@property (nonatomic, strong) NSDictionary *addressDictionary;
@property (nonatomic, strong) CLRegion *region;
// address dictionary properties
@property (nonatomic, strong) NSString *name; // eg. Apple Inc.
@property (nonatomic, strong) NSString *subThoroughfare; // eg. 1
@property (nonatomic, strong) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property (nonatomic, strong) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, strong) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, strong) NSString *ISOcountryCode; // eg. US
@property (nonatomic, strong) NSString *inlandWater; // eg. Lake Tahoe
@property (nonatomic, strong) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic, strong) NSArray *areasOfInterest; // eg. Golden Gate Park



@end
