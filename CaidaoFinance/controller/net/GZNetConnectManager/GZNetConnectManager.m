//
//  CWLWConnectManager.m
//  GAZREY.FRAME_1.0
//
//  Created by ZhuWeijie on 14-11-19.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "GZNetConnectManager.h"
#import "Reachability.h"


static GZNetConnectManager *_pConnectionMgr_ = nil;

@interface GZConnItem : NSObject <ASIHTTPRequestDelegate>
@property (nonatomic, assign) connectType cType;
@property (nonatomic, assign) NSInteger nTag;
@property (nonatomic, strong) NSString  *sKey;
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSString *sURL;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) ASIHTTPRequest *httpReq;
+ (GZConnItem *) connWithtype:(connectType) ct
                          url:(NSString *) sl
                       params:(NSDictionary *) pd
                          Tag:(NSInteger) nt
                          key:(NSString *) sk
                     delegate:(id) del;

- (GZConnItem *) initWithtype:(connectType) ct
                          url:(NSString *) sl
                       params:(NSDictionary *) pd
                          Tag:(NSInteger) nt
                          key:(NSString *) sk
        blockWithOutTagAndKey:(void(^)(BOOL bSuccess,id returnData,NSError *error)) blockWithOutTagAndKey
              blockWithOutKey:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag)) blockWithOutKey
                        block:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag, NSString *skey)) block;
- (void) start;

@end

@implementation GZConnItem
@synthesize nTag,sKey,delegate,sURL,cType,params;
@synthesize httpReq;

- (void) dealloc {
    [httpReq clearDelegatesAndCancel];
    [httpReq release];
    
    [params release];
    [sURL release];
    [sKey release];
    [super dealloc];
}

+ (GZConnItem *) connWithtype:(connectType) ct
                          url:(NSString *) sl
                       params:(NSDictionary *) pd
                          Tag:(NSInteger) nt
                          key:(NSString *) sk
                     delegate:(id) del {
    GZConnItem *item = [[GZConnItem alloc] init];
    item.nTag = nt;
    item.sKey = sk;
    item.sURL = sl;
    item.delegate = del;
    item.cType = ct;
    item.params = pd;
    return [item autorelease];
}

- (GZConnItem *) initWithtype:(connectType) ct
                          url:(NSString *) sl
                       params:(NSDictionary *) pd
                          Tag:(NSInteger) nt
                          key:(NSString *) sk
        blockWithOutTagAndKey:(void(^)(BOOL bSuccess,id returnData,NSError *error)) blockWithOutTagAndKey
              blockWithOutKey:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag)) blockWithOutKey
                        block:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag, NSString *skey)) block {
    if (self = [super init]) {
        self.nTag = nt;
        self.sKey = sk;
        self.sURL = sl;
        self.cType = ct;
        self.params = pd;
        
        if (cType == connectType_GET) {
            self.httpReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:sURL]];
            [httpReq setRequestMethod:@"GET"];
        } else if (cType == connectType_POST) {
            self.httpReq = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:sURL]];
            [httpReq setRequestMethod:@"POST"];
            ASIFormDataRequest *form = (ASIFormDataRequest *) httpReq;
            for (NSString *paramKey in [params allKeys]) {
                [form addPostValue:[params objectForKey:paramKey] forKey:paramKey];
            }
        }
        
        [httpReq setCompletionBlock:^(void){
            //如果没有tag和key
            if (blockWithOutTagAndKey) {
                blockWithOutTagAndKey(YES, httpReq.responseString, nil);
            }
            //如果没有key
            if (blockWithOutKey) {
                blockWithOutKey(YES, httpReq.responseString, nil, nTag);
            }
            
            if (block) {
                block(YES, httpReq.responseString, nil, self.nTag, self.sKey);
            }
            
            if([[GZNetConnectManager sharedInstance] respondsToSelector:@selector(didFinishedWithItems:error:)]) {
                [[GZNetConnectManager sharedInstance] performSelector:@selector(didFinishedWithItems:error:)
                                                          withObject:self
                                                          withObject:nil];
            }
        }];
        
        [httpReq setFailedBlock:^(void) {
            if (blockWithOutTagAndKey) {
                blockWithOutTagAndKey(NO, httpReq.responseString, httpReq.error);
            }
            
            if (blockWithOutKey) {
                blockWithOutKey(NO, httpReq.responseString, httpReq.error, nTag);
            }
            
            if (block) {
                block(NO, httpReq.responseString, httpReq.error, self.nTag, self.sKey);
            }
            
            if([[GZNetConnectManager sharedInstance] respondsToSelector:@selector(didFinishedWithItems:error:)]) {
                [[GZNetConnectManager sharedInstance] performSelector:@selector(didFinishedWithItems:error:)
                                                          withObject:self
                                                          withObject:httpReq.error];
            }
        }];
        
        [httpReq startAsynchronous];
    }
    return self;
}

- (void) start {
    NSAssert((sURL != nil), @"url can't be nil");
    
    sURL = [sURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (cType == connectType_GET) {
        httpReq = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:sURL]];
        [httpReq setRequestMethod:@"GET"];
    } else if (cType == connectType_POST) {
        httpReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:sURL]];
        [httpReq setRequestMethod:@"GET"];
        ASIFormDataRequest *form = (ASIFormDataRequest *) httpReq;
        for (NSString *paramKey in [params allKeys]) {
            [form addPostValue:[params objectForKey:paramKey] forKey:paramKey];
        }
    }
    httpReq.delegate = self;
    [httpReq startAsynchronous];
}

- (BOOL) isEqual:(id)object {
    GZConnItem *item = (GZConnItem *)object;
    if (![self.sURL isEqualToString:item.sURL]) {
        return NO;
    }
    if (self.cType != item.cType) {
        return NO;
    }
    if (self.delegate != item.delegate) {
        return NO;
    }
    if (self.nTag != item.nTag) {
        return NO;
    }
    if (self.sKey != nil && item.sKey != nil &&
        ![self.sKey isEqualToString:item.sKey]) {
        return NO;
    }
    for (NSString *paramKey in self.params) {
        id sp1 = [self.params objectForKey:paramKey];
        id sp2 = [self.params objectForKey:paramKey];
        if (sp2 == nil) {
            return NO;
        }
        if (![sp1 isEqual:sp2]) {
            return NO;
        }
    }
    return YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if([[GZNetConnectManager sharedInstance] respondsToSelector:@selector(didFinishedWithItems:error:)]) {
        [[GZNetConnectManager sharedInstance] performSelector:@selector(didFinishedWithItems:error:)
                                                  withObject:self
                                                  withObject:nil];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    if([[GZNetConnectManager sharedInstance] respondsToSelector:@selector(didFinishedWithItems:error:)]) {
        [[GZNetConnectManager sharedInstance] performSelector:@selector(didFinishedWithItems:error:)
                                                  withObject:self
                                                  withObject:request.error];
    }
}

@end


#pragma mark - CWLWConnectManager
@interface GZNetConnectManager()
@property (nonatomic, strong) NSMutableDictionary *connItems;
@property (nonatomic,strong) UIWindow *alertWindow;

//移除元素
- (id) hasItem:(GZConnItem *) item;
- (void) removeItems:(GZConnItem *) conn;
- (void) didFinishedWithItems:(GZConnItem *) conn
                        error:(NSError *) error;

@end

@implementation GZNetConnectManager

@synthesize connItems;

- (id) init {
    if (_pConnectionMgr_) {
        return _pConnectionMgr_;
    }
    if (self = [super init]) {
        self.connItems = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void) dealloc {
    [connItems release];
    [super dealloc];
}

+ (GZNetConnectManager *) sharedInstance {
    if (_pConnectionMgr_ == nil) {
        _pConnectionMgr_ = [[GZNetConnectManager alloc] init];
    }
    return _pConnectionMgr_;
}

+ (void) releaseInstance {
    if (_pConnectionMgr_ != nil) {
        [_pConnectionMgr_ release];
        _pConnectionMgr_ = nil;
    }
}

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
             delegate:(id) del {
    return [self conURL:sURL
            connectType:cType
                 params:params
               delegate:del
                    tag:0];
}

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
             delegate:(id) del
                  tag:(NSInteger) nTag {
    return [self conURL:sURL
            connectType:cType
                 params:params
               delegate:del
                    tag:nTag
                    key:nil];
}

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
             delegate:(id) del
                  tag:(NSInteger) nTag
                  key:(NSString *) sKey {
    
    GZConnItem *item = [GZConnItem connWithtype:cType
                                            url:sURL
                                         params:params
                                            Tag:nTag
                                            key:sKey
                                       delegate:del];
    if ([self hasItem:item]) {
        //重复调用方法
    }
    NSUInteger hashValue = [item hash];
    [self.connItems setObject:item forKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    [item start];
    
    return hashValue;
}

//取消网络连接
- (BOOL) cancelWithHashValue:(NSUInteger) nItemHashValue {
    GZConnItem *conn = [self.connItems objectForKey:[NSNumber numberWithUnsignedInteger:nItemHashValue]];
    if (conn) {
        [conn.httpReq clearDelegatesAndCancel];
        [self.connItems removeObjectForKey:[NSNumber numberWithUnsignedInteger:nItemHashValue]];
    }
    
    return YES;
}

- (BOOL) cancelURL:(NSString *) sURL
       connectType:(connectType) cType
            params:(NSDictionary *) params
          delegate:(id) del
               tag:(NSInteger) nTag
               key:(NSString *) sKey {
    GZConnItem *item = [GZConnItem connWithtype:cType
                                            url:sURL
                                         params:params
                                            Tag:nTag
                                            key:sKey
                                       delegate:del];
    GZConnItem *existItem = [self hasItem:item];
    if (existItem != nil) {
        if (existItem.httpReq != nil) {
            [existItem.httpReq clearDelegatesAndCancel];
        }
        [self.connItems removeObjectForKey:[NSNumber numberWithUnsignedInteger:[existItem hash]]];
        
        return NO;
    }
    return YES;
}

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
               result:(void(^)(BOOL bSuccess,id returnData,NSError *error)) block {
    GZConnItem *item = [[GZConnItem alloc] initWithtype:cType
                                                    url:sURL
                                                 params:params
                                                    Tag:0
                                                    key:nil
                                  blockWithOutTagAndKey:block
                                        blockWithOutKey:nil
                                                  block:nil];
    NSUInteger hashValue = [item hash];
    [self.connItems setObject:item forKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    [item release];
    
    return hashValue;
}

- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
                  tag:(NSInteger) nTag
               result:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag)) block {
    GZConnItem *item = [[GZConnItem alloc] initWithtype:cType
                                                    url:sURL
                                                 params:params
                                                    Tag:nTag
                                                    key:nil
                                  blockWithOutTagAndKey:nil
                                        blockWithOutKey:block
                                                  block:nil];
    NSUInteger hashValue = [item hash];
    [self.connItems setObject:item forKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    [item release];
    
    return hashValue;
}
- (NSUInteger) conURL:(NSString *) sURL
          connectType:(connectType) cType
               params:(NSDictionary *) params
                  tag:(NSInteger) nTag
                  key:(NSString *) sKey
               result:(void(^)(BOOL bSuccess,id returnData,NSError *error,NSInteger nTag, NSString *skey)) block {
    
    GZConnItem *item = [[GZConnItem alloc] initWithtype:cType
                                                    url:sURL
                                                 params:params
                                                    Tag:nTag
                                                    key:sKey
                                  blockWithOutTagAndKey:nil
                                        blockWithOutKey:nil
                                                  block:block];
    NSUInteger hashValue = [item hash];
    [self.connItems setObject:item forKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    [item release];
    
    return hashValue;
}

#pragma mark - private action
- (id) hasItem:(GZConnItem *) conn {
    NSUInteger hashValue = [conn hash];
    id object = [self.connItems objectForKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    if (object == nil) {
        for(id item in [self.connItems allValues]) {
            if ([conn isEqual:item]) {
                return item;
            }
        }
    } else {
        return conn;
    }
    return nil;
}

- (void) removeItems:(GZConnItem *) conn {
    NSUInteger hashValue = [conn hash];
    id object = [self.connItems objectForKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    if (object != nil) {
        [[(GZConnItem *)object httpReq] clearDelegatesAndCancel];
        [self.connItems removeObjectForKey:[NSNumber numberWithUnsignedInteger:hashValue]];
    }
}

- (void) didFinishedWithItems:(GZConnItem *) conn
                        error:(NSError *) error {
    if (error == nil) {
        if (conn.delegate && [conn.delegate respondsToSelector:@selector(didCWFinishSuccessedWithData:tag:key:)]) {
            [conn.delegate didCWFinishSuccessedWithData:conn.httpReq.responseString
                                                    tag:conn.nTag
                                                    key:conn.sKey];
        }
    } else {
        if (conn.delegate && [conn.delegate respondsToSelector:@selector(didCWFinishFailedWithError:tag:key:)]) {
            [conn.delegate didCWFinishFailedWithError:error
                                                  tag:conn.nTag
                                                  key:conn.sKey];
        }
    }
    
    [self removeItems:conn];
}

@end