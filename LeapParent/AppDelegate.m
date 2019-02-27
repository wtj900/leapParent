//
//  AppDelegate.m
//  leapParent
//
//  Created by 王史超 on 2018/6/5.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "AppDelegate.h"

#import "OWXBaseNavigationController.h"
#import "OWXHomeViewController.h"
#import "OWXRoleChooseViewController.h"
#import <iflyMSC/iflyMSC.h>

NSString * const OWXAPPSwitchRootViewControllerNotification = @"OWXAPPSwitchRootViewControllerNotification";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Set log level
    [IFlySetting setLogFile:LVL_ALL];
    
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IFLY_APPID_VALUE];
    [IFlySpeechUtility createUtility:initString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:OWXAPPSwitchRootViewControllerNotification object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[OWXBaseNavigationController alloc] initWithRootViewController:[[OWXRoleChooseViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)switchRootViewController:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"login"] boolValue]) {
        self.window.rootViewController = [[OWXBaseNavigationController alloc] initWithRootViewController:[[OWXHomeViewController alloc] init]];
    } else {
        self.window.rootViewController = [[OWXBaseNavigationController alloc] initWithRootViewController:[[OWXRoleChooseViewController alloc] init]];
    }
    
    
//    if (IS_EMPTY_STRING([OWXUserInfoModel share].ids)) {
//    }
//    else {
//        OWXMainViewController *mainViewController = [[OWXMainViewController alloc] init];
//        self.window.rootViewController = mainViewController;
//    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
