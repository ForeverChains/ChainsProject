//
//  MBProgressHUD+Chains.h
//  AFNetworkingDemo
//
//  Created by 马腾飞 on 16/9/30.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Chains)

/**
 *  带菊花的提示框
 *
 *  @param tip  提示文字
 *  @param view 展示视图
 *
 *  @return 用于隐藏提示框的实例对象
 */
+ (MBProgressHUD *)chains_showActivityIndicatorWithTip:(NSString *)tip toView:(UIView *)view;

/**
 *  信息提示框
 *
 *  @param tip        提示文字
 *  @param view       展示视图
 *  @param afterDelay 持续时间
 */
+ (void)chains_showTip:(NSString *)tip toView:(UIView *)view hideAfterDelay:(float)afterDelay;

+ (void)chains_showTip:(NSString *)tip toView:(UIView *)view;

/**
 *  带动画的提示框
 *
 *  @param gifArr        NSString类型的，从NSBundle加载本地.gif文件用UIWebView播放;NSArray类型的,用UIImageView播放
 *  @param tip        提示文字
 *  @param view       展示视图
 */
+ (MBProgressHUD *)chains_showGif:(NSArray *)gifArr andTip:(NSString *)tip toView:(UIView *)view;

+ (void)chains_hideForView:(UIView *)view;

@end
