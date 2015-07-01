//
//  GZSystemModelUtils.m
//  GAZREY.FRAME
//
//  Created by ZhuWeijie on 14-5-13.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "GZSystemModelUtils.h"

#define MAX_MULTIPLE_PHOTO_COUNT   10

@implementation GZSystemModelUtils

+(void)takePhotoWithVC:(UIViewController*)controller withDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) delegate
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = delegate;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [controller presentViewController:picker animated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
+(void)LocalPhotoWithVC:(UIViewController*)controller delegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) delegate
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = delegate;
        [imagePicker setAllowsEditing:YES];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [UINavigationBar appearance].backIndicatorImage = nil;
        [controller presentViewController:imagePicker animated:YES completion:nil];
        //        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //        if (block) {
        //            block(popover);
        //            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        //        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
}

+(void)takeMultiplePhotoWithViewController:(UIViewController *)controller withDelegate:(id<UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>)delegate
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MAX_MULTIPLE_PHOTO_COUNT;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate= delegate;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [controller presentViewController:picker animated:YES completion:NULL];
    
}


+(void)showAlertViewForTitle:(NSString *)title message:(NSString *)msg
{
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [Notpermitted show];
}

+(void)showActionSheetWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destoryButtonTitle:(NSString *)destoryTitle otherButtonTitle:(NSString *)otherTitle inview:(UIView *)view
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:title
                              delegate:delegate
                              cancelButtonTitle:cancelTitle
                              destructiveButtonTitle:destoryTitle
                              otherButtonTitles:otherTitle, nil];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:view]) {
        [mySheet showInView:view];
    } else {
        [mySheet showInView:window];
    }
}

+(void)showPickerViewWithData:(NSArray*)data frame:(CGRect)frame view:(UIView*)view delegate:(id<UIPickerViewDelegate>)delegate datasource:(id<UIPickerViewDataSource>)datasource
{
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:frame];
    pickerView.dataSource = datasource;
    pickerView.delegate = delegate;
    [view addSubview:pickerView];
}

@end
