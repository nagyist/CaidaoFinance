//
//  GZMessUtils.h
//  ForeignLanguage
//
//  Created by ZhuWeijie on 14-7-25.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GZMessUtilsDelegate <NSObject>

-(void)didTapOnDarkView;

@end

/********负责一些乱七八糟,比较常见的小功能**********/

@interface GZMessUtils : NSObject

@property (nonatomic,strong)UIView * dview;

@property (nonatomic,strong)id<GZMessUtilsDelegate>delegate;

//黑色半透明遮罩
-(void)showDarkMask:(UIView*)view delegate:(id<GZMessUtilsDelegate>)delegate;
//移除黑色半透明遮罩
-(void)removeDarkMask;

-(void)startCountDown:(NSInteger)time label:(UILabel*)label block:(void(^)())block;

+(GZMessUtils*)sharedUtils;


@end
