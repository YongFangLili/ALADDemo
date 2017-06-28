//
//  AppDelegate.m
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/22.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "ADvertisementManager.h"
#import "ADALCustomerView.h"

@interface AppDelegate ()

@property (nonatomic, strong) ADALCustomerView *adCustomeView;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *baseVC = [[ViewController alloc] init];
    baseVC.view.backgroundColor = [UIColor yellowColor];
    _window.rootViewController = baseVC;
    [_window makeKeyAndVisible];
    [ADvertisementManager showAD];
//    [self.adCustomeView showAD];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [ADvertisementManager saveCurrentDataWhenAPPBackInGround];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
     [ADvertisementManager showAD];
//    [self.adCustomeView showAD];
    [ADvertisementManager showADFromBackGround];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (ADALCustomerView *)adCustomeView {
    
    if (!_adCustomeView) {
        _adCustomeView = [[ADALCustomerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _adCustomeView;
}


@end
