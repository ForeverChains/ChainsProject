//
//  UINavigationController+Chains.h
//  CommonProject
//
//  Created by lianzun on 2017/9/24.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Chains)
    
/*
 改变barAlpha值,通过UINavigationBar的- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forBarPosition:(UIBarPosition)barPosition barMetrics:(UIBarMetrics)barMetrics方法设置不同透明度的BackgroundImage
 通过UINavigationBar的titleTextAttributes设置标题颜色
 通过UINavigationBar的tintColor设置导航按钮颜色
 UINavigationBar的shadowImage设置为nil隐藏底部线或者[UIImage new]显示底部线
 */
@property (assign, nonatomic) float barAlpha;

@property (strong, nonatomic) UIImage *barBgImage;
@property (assign, nonatomic) BOOL barStyleBlack;//导航栏为黑，状态栏为白
    
@property (strong, nonatomic) NSDictionary *titleTextAttributes;
@property (strong, nonatomic) UIColor *barButtonColor;


@end
