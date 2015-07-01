//
//  CWLWConnectManager.h
//  GAZREY.FRAME_1.0
//
//  Created by ZhuWeijie on 14-11-19.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef enum {
    connectType_GET = 0,
    connectType_POST
} connectType;

@interface GZNetConnectManager : NSObject

+ (GZNetConnectManager *) sharedInstance;
+ (void) releaseInstance;

//投递方法
- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
             delegate:(id) del;

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
             delegate:(id) del
                  tag:(NSInteger) nTag;

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
             delegate:(id) del
                  tag:(NSInteger) nTag
                  key:(NSString *) sKey;


#if NS_BLOCKS_AVAILABLE
- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
               result:(void(^)(BOOL bSuccess,id returnData,NSError *error)) block;

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
                  tag:(NSInteger) nTag
               result:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag)) block;

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
                  tag:(NSInteger) nTag
                  key:(NSString *) sKey
               result:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag, NSString *skey)) block;
#endif

//取消网络连接
- (BOOL) cancelWithHashValue:(NSUInteger) nItemHashValue;
- (BOOL) cancelURL:(NSString *) sURL
       connectType:(connectType) cType
            params:(NSDictionary *) params
          delegate:(id) del
               tag:(NSInteger) nTag
               key:(NSString *) sKey;

@end


@interface NSObject(CWLCConnection)
- (void) didCWFinishSuccessedWithData:(id) data
                                  tag:(NSInteger) nTag
                                  key:(NSString *) sKey;
- (void) didCWFinishFailedWithError:(NSError *) error
                                tag:(NSInteger) nTag
                                key:(NSString *) sKey;
@end