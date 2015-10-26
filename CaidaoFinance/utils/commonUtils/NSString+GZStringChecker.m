//
//  NSString+GZStringChecker.m
//  法律通
//
//  Created by ZhuWeijie on 14-8-15.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "NSString+GZStringChecker.h"

//验证Email地址：
#define EMAIL_REGX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"


//验证电话号码
#define TEL_REGX @"^((d{3,4})|d{3,4}-)?d{7,8}$"

@implementation NSString (GZStringChecker)

//验证手机号码格式
+(BOOL)checkPhoneReg:(NSString *)phone
{
    
    NSString * MOBILE = TEL_REGX;
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phone];
    BOOL res2 = [regextestcm evaluateWithObject:phone];
    BOOL res3 = [regextestcu evaluateWithObject:phone];
    BOOL res4 = [regextestct evaluateWithObject:phone];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//验证邮箱格式
+(BOOL)checkEmailReg:(NSString *)email
{
    NSString * EMAIL = EMAIL_REGX;
    NSPredicate *regextestemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL];
    BOOL res = [regextestemail evaluateWithObject:email];
    
    return res;
}

+(BOOL)checkCharacterReg:(NSString *)text {
    NSString * charcter = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *regextestcharcter = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", charcter];
    BOOL res = [regextestcharcter evaluateWithObject:text];
    
    return res;
    
}



@end
