//
//  CTCommonUtils.m
//  ChinaReward
//
//  Created by Chao Liu on 13-8-15.
//  Copyright (c) 2013年 Alan. All rights reserved.
//

#import <sys/sysctl.h>
#import <mach/mach.h>

#import "CTCommonUtils.h"
#import "Reachability.h"

#define  REQUEST_TIMEOUT_INTERVAL 60.0

@implementation CTCommonUtils

//缩放
+ (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue=orginMultiple;
    
    animation.toValue=Multiple;
    
    animation.duration=time;
    
    animation.autoreverses=YES;
    
    animation.repeatCount=repeatTimes;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
}

+(UIColor *)ColorWithHexString:(NSString *)string {
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params {
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        NSString* escaped_value = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                               NULL, /* allocator */
                                                                                               (CFStringRef)[params objectForKey:key],
                                                                                               NULL, /* charactersToLeaveUnescaped */
                                                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                               kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSMutableURLRequest *)getRequest:(NSDictionary *)params fromServer:(NSString *)server_addr {
    NSString *url = [CTCommonUtils serializeURL:server_addr params:params];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
}

+(UIImageView *) imageViewWithImage:(NSString *)imageName uiEdgeInsets:(UIEdgeInsets)insets frame:(CGRect)aframe {
    UIImage *image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:insets];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = aframe;
    return imageView;
}

+ (void)loadDataWithContentsOfURLString:(NSString *)url withCache:(BOOL)cache completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if (cache) {

//        NSData *cache_data = [StaticCache getValueByUrl:url];
//        if (cache_data) {
//            handler(nil, cache_data, nil);
//            return;
//        }
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
         if (cache) {
             if (!error && responseCode == 200) {
//                 [StaticCache setUrl:url withValue:data];
             }
         }
         handler(response, data, error);
     }];
}

+ (void)showAlertViewOnView:(UIView *)currentView withText:(NSString *)text alignment:(CTCommonUtilsShowType)alignment{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,50,50)];
    label.font = [UIFont fontWithName:@"Heiti TC" size:13];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    CGSize ConstrainedToSize = CGSizeMake(200, 400);
    label.numberOfLines = 0;
    CGSize newSize = [label.text sizeWithFont:label.font
                            constrainedToSize:ConstrainedToSize
                                lineBreakMode:NSLineBreakByTruncatingMiddle];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, newSize.width, newSize.height);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width+20, label.frame.size.height+20)];
    view.backgroundColor = RGBCOLOR(240, 101, 49);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    switch (alignment) {
        case CTCommonUtilsShowBottom:
            view.center = CGPointMake(currentView.center.x, currentView.center.y + currentView.frame.size.height * 0.3);
            break;
            case CTCommonUtilsShowCenter:
            view.center = CGPointMake(currentView.center.x, currentView.center.y);
            break;
            case CTCommonUtilsShowTop:
            view.center = CGPointMake(currentView.center.x, 84);
            break;
            
        default:
            break;
    }
    [view addSubview:label];
    view.alpha = 0;
    [currentView addSubview:view];
    [UIView animateWithDuration:0.7
                     animations:^{
                         view.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.5 animations:^{
                             view.alpha=0;
                         } completion:^(BOOL finished){
                             [view removeFromSuperview];
                         }
                          ];
                     }
     ];
}

+(void)showWhiteAlertViewOnView:(UIView *)currentView withText:(NSString *)text alignment:(CTCommonUtilsShowType)alignment{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,50,50)];
    label.font = [UIFont fontWithName:@"Heiti TC" size:13];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    CGSize ConstrainedToSize = CGSizeMake(200, 400);
    label.numberOfLines = 0;
    CGSize newSize = [label.text sizeWithFont:label.font
                            constrainedToSize:ConstrainedToSize
                                lineBreakMode:NSLineBreakByTruncatingMiddle];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, newSize.width, newSize.height);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width+20, label.frame.size.height+20)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    switch (alignment) {
        case CTCommonUtilsShowBottom:
            view.center = CGPointMake(currentView.center.x, currentView.center.y + currentView.frame.size.height * 0.3);
            break;
        case CTCommonUtilsShowCenter:
            view.center = CGPointMake(currentView.center.x, currentView.center.y);
            break;
        case CTCommonUtilsShowTop:
            view.center = CGPointMake(currentView.center.x, currentView.center.y - 30);
            break;
            
        default:
            break;
    }
    [view addSubview:label];
    view.alpha = 0;
    [currentView addSubview:view];
    [UIView animateWithDuration:0.7
                     animations:^{
                         view.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.5 animations:^{
                             view.alpha=0;
                         } completion:^(BOOL finished){
                             [view removeFromSuperview];
                         }
                          ];
                     }
     ];
}

+ (NSString *)getFormatedURL:(NSString *)url {
    NSString *formatted_url = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)url, NULL, CFSTR("#[]@!$ '()*+,;\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return formatted_url;
}

// 获取当前设备可用内存(单位：MB）
+ (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (BOOL)currentNetworkStatus {
    Reachability *r=[Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

+ (UITableViewCell *)getLoadMoreCell {
    NSString *CellIdentifier = @"loadmorecell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"load_more"]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"加载更多";
    cell.textLabel.textColor = [CTCommonUtils ColorWithHexString:@"999999"];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:10];
    cell.tag = 5955;
    return cell;
}

+ (void)letCellLoading:(UITableViewCell *)cell {
    UILabel *label = [cell.contentView.subviews objectAtIndex:0];
    [label removeFromSuperview];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [cell.contentView addSubview:indicator];
    [indicator startAnimating];
    indicator.center = CGPointMake(160, 15);
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];         
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

-(void)showAlertViewOnViewWithState:(UIView *)currentView withText:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,50,50)];
    label.font = [UIFont fontWithName:@"Heiti TC" size:13];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    CGSize ConstrainedToSize = CGSizeMake(200, 400);
    label.numberOfLines = 0;
    CGSize newSize = [label.text sizeWithFont:label.font
                            constrainedToSize:ConstrainedToSize
                                lineBreakMode:NSLineBreakByTruncatingMiddle];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, newSize.width, newSize.height);
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width+20, label.frame.size.height+20)];
    _view.backgroundColor = [UIColor blackColor];
    _view.layer.masksToBounds = YES;
    _view.layer.cornerRadius = 5;
    _view.center = CGPointMake(currentView.center.x, currentView.center.y);
    [_view addSubview:label];
    [currentView addSubview:_view];
    
}

-(void)hideAlertViewOnView
{
    [_view removeFromSuperview];
    _view = nil;
}

+(CTCommonUtils*)sharedUtils
{
    static CTCommonUtils * locationControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        locationControllerInstance = [[self alloc] init];
    });
    return locationControllerInstance;
}

@end
