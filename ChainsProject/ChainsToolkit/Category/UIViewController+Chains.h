//
//  UIViewController+Chains.h
//  Summary
//
//  Created by 马腾飞 on 16/4/29.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Chains)

/**
 *  返回当前界面
 */
+ (UIViewController *)chains_visibleViewController;

- (void)chains_configNavigationBarWithBackgroundImage:(UIImage *)bgImage translucent:(BOOL)translucent titleSize:(float)size titleColor:(UIColor *)titleColor barButtonTintColor:(UIColor *)barButtonTitleColor statusBarStyle:(UIBarStyle)barStyle;

@end
