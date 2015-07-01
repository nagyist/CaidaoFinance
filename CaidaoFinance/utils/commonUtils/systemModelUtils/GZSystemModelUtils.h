//
//  GZSystemModelUtils.h
//  GAZREY.FRAME
//
//  Created by ZhuWeijie on 14-5-13.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYQAssetPickerController.h"

@protocol GZSystemModelDelegate <NSObject>



@end

@interface GZSystemModelUtils : NSObject

//打开相机
+(void)takePhotoWithVC:(UIViewController*)controller withDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) delegate;

//打开多选相册
+(void)takeMultiplePhotoWithViewController:(UIViewController*)controller withDelegate:(id<UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>)delegate;

//打开相册 单选
+(void)LocalPhotoWithVC:(UIViewController*)controller delegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) delegate;

//弹出提醒框
+(void)showAlertViewForTitle:(NSString*)title message:(NSString*)msg;


//弹出上拉菜单
+(void)showActionSheetWithTitle:(NSString*)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString*)cancelTitle destoryButtonTitle:(NSString*)destoryTitle otherButtonTitle:(NSString*)otherTitle inview:(UIView*)view;


/**  时间选择器 **/
/************  选择器 *******/
+(void)showPickerViewWithData:(NSArray*)data frame:(CGRect)frame view:(UIView*)view delegate:(id<UIPickerViewDelegate>)delegate datasource:(id<UIPickerViewDataSource>)datasource;


@end
