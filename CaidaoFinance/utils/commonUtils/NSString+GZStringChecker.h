//
//  NSString+GZStringChecker.h
//  法律通
//
//  Created by ZhuWeijie on 14-8-15.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GZStringChecker)

+(BOOL)checkPhoneReg:(NSString*)phone;

+(BOOL)checkEmailReg:(NSString*)email;

@end
