//
//  MBProgressHUD+Chains.m
//  AFNetworkingDemo
//
//  Created by 马腾飞 on 16/9/30.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "MBProgressHUD+Chains.h"

@implementation MBProgressHUD (Chains)

+ (MBProgressHUD *)chains_showActivityIndicatorWithTip:(NSString *)tip toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = tip;
    
    //颜色设置
    //    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    
    // Change the background view style and color.
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    return hud;
}

+ (void)chains_showTip:(NSString *)tip toView:(UIView *)view hideAfterDelay:(float)afterDelay
{
    if (view == nil) view = [UIViewController chains_visibleViewController].view;
//    if (view == nil) view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    ;
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = tip;
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    hud.offset = CGPointMake(0.f, 0.f);
    hud.margin = 10.f;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:afterDelay];
}

+ (void)chains_showTip:(NSString *)tip toView:(UIView *)view
{
    [self chains_showTip:tip toView:view hideAfterDelay:2.0];
}

//CustomView必须为UIImageView并且image属性不为nil才能显示
+ (MBProgressHUD *)chains_showGif:(NSArray *)gifArr andTip:(NSString *)tip toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = gifArr;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(gifArr.count + 1) * 0.075];
    [showImageView startAnimating];
    
    hud.customView = showImageView;
    
    hud.square = YES;
    
    hud.label.text = tip;
    
    return hud;
}

+ (void)chains_hideForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [MBProgressHUD hideHUDForView:view animated:YES];
}


@end
