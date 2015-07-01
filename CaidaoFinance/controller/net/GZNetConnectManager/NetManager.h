//
//  NetManager.h
//  FuChiTong
//
//  Created by 朱玮杰 on 15/6/4.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZNetConnectManager.h"
#import "AFNetworking.h"


@interface NetManager : NSObject

+(void)startConnect:(NSString*)url connectType:(connectType)type params:(NSDictionary*)params ntag:(NSUInteger)ntag completeblock:(void(^)(BOOL rSuccess,id returnData,NSUInteger ntag,AFHTTPRequestOperation*operation))block failure:(void(^)(AFHTTPRequestOperation*operation,NSError*error))failure;

@end