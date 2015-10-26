//
//  AppDelegate.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/5.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "GZMenuView.h"
#import <MBLocationManager.h>
#import "MZFormSheetBackgroundWindow.h"
#import "MZFormSheetController.h"
#import "APService.h"
#import "TouchPassViewController.h"

#define JPUSH_KEY "78e96c8579b24e160d2ea4a6"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[GZMenuView appearance] setTextNormalColor:RGBCOLOR(167, 52, 49)];
    [[GZMenuItem appearance] setItemTextColor:RGBCOLOR(167, 52, 49)];
    [[GZMenuItem appearance] setItemBgImg:UIIMAGE(@"individual_menu_item_bg")];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:NO];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[MZFormSheetController appearance] setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    [[MZFormSheetController appearance] setShouldDismissOnBackgroundViewTap:YES];
    [[MZFormSheetController appearance] setPresentedFormSheetSize:CGSizeMake(230, 280)];
//    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];

    
    [[MBLocationManager sharedManager] startLocationUpdates:kMBLocationManagerModeStandard
                                             distanceFilter:kCLDistanceFilterNone
                                                   accuracy:kCLLocationAccuracyThreeKilometers];
    

    UIImage*image = UIIMAGE(@"back_button_normal");
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorImage = image;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont fontWithName:@"HiraginoSansGB-W3" size:19],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBackgroundImage:UIIMAGE(@"nav_bg") forBarMetrics:UIBarMetricsDefault];
    IndexViewController * view = [IndexViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:view];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[MBLocationManager sharedManager] stopLocationUpdates];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[MBLocationManager sharedManager] startLocationUpdates];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if([USER_DEFAULT objectForKey:TOUCH_PASS] && [[USER_DEFAULT objectForKey:OPEN_TOUCH_PASS]boolValue]) {
        NSLog(@"%@",[USER_DEFAULT objectForKey:TOUCH_PASS]);
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:[TouchPassViewController new] animated:YES completion:^{
//            [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:^{
//                
//            }];
        }];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[MBLocationManager sharedManager] stopLocationUpdates];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
