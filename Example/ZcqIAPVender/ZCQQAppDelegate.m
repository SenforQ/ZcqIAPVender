//
//  ZCQQAppDelegate.m
//  ZcqIAPVender
//
//  Created by Z cq on 10/18/2022.
//  Copyright (c) 2022 Z cq. All rights reserved.
//

#import "ZCQQAppDelegate.h"
#import "ZCQDemoViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <ZcqIAPVender/ZcqIAPVender.h>
@implementation ZCQQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //配置内购清单.
    [ZcqIAPVenderConfig shared];
    [ZcqIAPVenderConfig shared].ipaIdArrays = @[@"com.demoweek.ceshi",@"com.demomonth.ceshi",@"com.demoyear.ceshi"];
    [ZcqIAPVenderConfig shared].ipaAppSecretkey = @"e0c5fafbe363427e8bc9d4165b907ff1";
    [[ZcqIAPVenderConfig shared] showConfigMessage];
    
    [ZcqIAPVenderConfig shared].isForeverVip = YES;
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                //配置
                [[ZcqApiVenderManager shared] defaultManager];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                //配置
                [[ZcqApiVenderManager shared] defaultManager];
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
    
    //初始化window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    ZCQDemoViewController* vc = [[ZCQDemoViewController alloc]init];
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = navi;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
