//
//  AppDelegate.m
//  ChainsProject
//
//  Created by lianzun on 2018/5/11.
//  Copyright © 2018年 Chains. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"DocumentsPath : %@",[NSFileManager chains_getDocumentsPath]);
    
    //应用持有人信息
    NSLog(@"UserList:%@",[NSBundle mainBundle].infoDictionary);
    [ApplicationContext sharedInstance].owner = [Owner modelWithDic:[NSBundle mainBundle].infoDictionary];
    
    //应用支持的方向
    self.interfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    //更改设备方向，触发转屏事件，设备方向必须为界面所支持的方向
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationUnknown] forKey:@"orientation"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
    self.window.rootViewController = tabVC;
    
    [UITextField appearance].tintColor = [UIColor chains_colorWithHexString:COLOR_THEME];
    [UITextView appearance].tintColor = [UIColor chains_colorWithHexString:COLOR_THEME];
    [UISearchBar appearance].tintColor = [UIColor chains_colorWithHexString:COLOR_THEME];
    
    if (@available(iOS 11.0, *))
    {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    //自动登录
    [User autoLoginSuccess];
    
    //网络监测
//    AFNetworkReachabilityManager *networkManager = [AFHTTPSessionManager manager].reachabilityManager;
//    [networkManager startMonitoring];
//    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status==AFNetworkReachabilityStatusReachableViaWiFi ||status==AFNetworkReachabilityStatusReachableViaWWAN) {
//            NSLog(@"可以联网,重启初始化");
//        }else if(status==AFNetworkReachabilityStatusNotReachable){
//            NSLog(@"无网络连接");
//        }else{
//            NSLog(@"未知网络");
//        }
//    }];
    
    return YES;
}

#pragma mark - InterfaceOrientation
//屏幕旋转全局控制
- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    return self.interfaceOrientationMask;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //若为登录状态，保存数据
    if ([ApplicationContext sharedInstance].currentUser)
    {
        [User saveCurrentUserToLocal:[ApplicationContext sharedInstance].currentUser];
    }
}


@end
