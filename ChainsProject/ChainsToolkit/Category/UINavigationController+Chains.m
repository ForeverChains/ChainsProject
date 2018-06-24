//
//  UINavigationController+Chains.m
//  CommonProject
//
//  Created by lianzun on 2017/9/24.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import "UINavigationController+Chains.h"
#import <objc/runtime.h>

@implementation UINavigationController (Chains)
    
- (NSDictionary *)titleTextAttributes
{
    return objc_getAssociatedObject(self, _cmd);
}
    
- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes
{
    objc_setAssociatedObject(self, @selector(titleTextAttributes), titleTextAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationBar.titleTextAttributes = titleTextAttributes;
}
    
- (UIColor *)barButtonColor
{
    return objc_getAssociatedObject(self, _cmd);
}
    
- (void)setBarButtonColor:(UIColor *)barButtonColor
{
    objc_setAssociatedObject(self, @selector(barButtonColor), barButtonColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationBar.tintColor = barButtonColor;
}

- (UIImage *)barBgImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBarBgImage:(UIImage *)barBgImage
{
    objc_setAssociatedObject(self, @selector(barBgImage), barBgImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationBar setBackgroundImage:[barBgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
}

- (BOOL)barStyleBlack
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setBarStyleBlack:(BOOL)barStyleBlack
{
    objc_setAssociatedObject(self, @selector(barStyleBlack), [NSNumber numberWithBool:barStyleBlack], OBJC_ASSOCIATION_ASSIGN);
    
    [self.navigationBar setBarStyle:barStyleBlack];
}

- (float)barAlpha
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBarAlpha:(float)barAlpha
{
    objc_setAssociatedObject(self, @selector(barAlpha), [NSNumber numberWithFloat:barAlpha], OBJC_ASSOCIATION_ASSIGN);
    
    //设置BackgroundImage
    self.barBgImage = [self.barBgImage chains_changeAlpha:barAlpha];
}

@end
