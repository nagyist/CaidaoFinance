//
//  GZAnimationController.h
//  FuChiTong
//
//  Created by LJ on 15/4/16.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZAnimationController : NSObject

//弹出弹进动画
+(void)showAlertView:(UIView*)view withAnimation:(BOOL)isAnimation;
+(void)hideAlertView:(UIView*)view withAnimation:(BOOL)isAnimation;



@end
