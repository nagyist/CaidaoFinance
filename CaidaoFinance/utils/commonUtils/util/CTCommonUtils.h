//
//  CTCommonUtils.h
//  ChinaReward
//
//  Created by Chao Liu on 13-8-15.
//  Copyright (c) 2013年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define SCREEN_RECT [[UIScreen mainScreen]bounds]

#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define IS_IPHONE_5 [[UIScreen mainScreen ]bounds].size.height == 568

typedef enum {
    CTCommonUtilsShowTop = 0,
    CTCommonUtilsShowCenter = 1,
    CTCommonUtilsShowBottom = 2
} CTCommonUtilsShowType;


@interface CTCommonUtils : NSObject


@property (nonatomic,strong)UIView * view;

//缩放
+ (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes;

+ (UIColor *)ColorWithHexString:(NSString *)string;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;
+ (NSMutableURLRequest *)getRequest:(NSDictionary *)params fromServer:(NSString *)server_addr;

+(UIImageView *) imageViewWithImage:(NSString *)imageName uiEdgeInsets:(UIEdgeInsets)insets frame:(CGRect)aframe;

+ (void)loadDataWithContentsOfURLString:(NSString *)url withCache:(BOOL)cache completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

+ (void)showAlertViewOnView:(UIView *)currentView withText:(NSString *)text alignment:(CTCommonUtilsShowType)alignment;

+ (void)showWhiteAlertViewOnView:(UIView *)currentView withText:(NSString *)text alignment:(CTCommonUtilsShowType)alignment;


+ (NSString *)getFormatedURL:(NSString *)url;

+ (double)usedMemory;

+ (double)availableMemory;

+ (BOOL)currentNetworkStatus;

+ (UITableViewCell *)getLoadMoreCell;

+ (void)letCellLoading:(UITableViewCell *)cell;

+ (NSString *)getStringFromDate:(NSDate *)date;

/*     正在加载中     */
-(void)showAlertViewOnViewWithState:(UIView *)currentView withText:(NSString *)text ;


-(void)hideAlertViewOnView;

+(CTCommonUtils*)sharedUtils;

@end
