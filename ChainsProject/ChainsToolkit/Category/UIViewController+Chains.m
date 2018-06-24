//
//  UIViewController+Chains.m
//  Summary
//
//  Created by 马腾飞 on 16/4/29.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "UIViewController+Chains.h"

@implementation UIViewController (Chains)

+ (UIViewController *)chains_visibleViewController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]])
    {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (void)chains_configNavigationBarWithBackgroundImage:(UIImage *)bgImage translucent:(BOOL)translucent titleSize:(float)size titleColor:(UIColor *)titleColor barButtonTintColor:(UIColor *)barButtonTintColor statusBarStyle:(UIBarStyle)barStyle
{
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:translucent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:size],
                                                                      NSForegroundColorAttributeName:titleColor}];
    [self.navigationController.navigationBar setTintColor:barButtonTintColor];
    [self.navigationController.navigationBar setBarStyle:barStyle];
}

@end
