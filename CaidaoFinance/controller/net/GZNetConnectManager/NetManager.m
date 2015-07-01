//
//  NetManager.m
//  FuChiTong
//
//  Created by 朱玮杰 on 15/6/4.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "NetManager.h"
#import <SVProgressHUD.h>
#import "Reachability.h"


@implementation NetManager

+(void)startConnect:(NSString *)url connectType:(connectType)type params:(NSDictionary *)params ntag:(NSUInteger)ntag completeblock:(void (^)(BOOL, id, NSUInteger, AFHTTPRequestOperation *))block failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    Reachability*reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
                       });
        if (type == connectType_GET) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:[NSString stringWithFormat:@"%@%@",NETDOMAIN,url] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if (block) {
                    [SVProgressHUD dismiss];
                    block(YES,responseObject,ntag,operation);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (failure) {
                    failure(operation,error);
                }
            }];
        }
        else if(type == connectType_POST)
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = params;
            [manager POST:[NSString stringWithFormat:@"%@%@",NETDOMAIN,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if (block) {
                    [SVProgressHUD dismiss];
                    block(YES,responseObject,ntag,operation);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (failure) {
                    failure(operation,error);
                }
            }];
        }
        
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [SVProgressHUD showErrorWithStatus:@"网络错误,请检查网络" maskType:SVProgressHUDMaskTypeClear];

    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    
}
@end
