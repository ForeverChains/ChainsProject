//
//  BaseNavigationController.m
//  Coding_iOS
//
//  Created by Ease on 15/2/5.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "BaseNavigationController.h"
#import "AppDelegate.h"

//#import "CEBaseInteractionController.h"
//#import "CEReversibleAnimationController.h"

#import "BaseInteractionController.h"
#import "BaseTransitionAnimationController.h"

@implementation BaseNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.delegate = self;
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (!self)
    {
        return nil;
    }
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = (self.viewControllers.count > 0);
    return [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = (self.viewControllers.count > 1);
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
//    NSLog(@"shouldAutorotate:%d",[self.visibleViewController shouldAutorotate]);
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    NSLog(@"supportedInterfaceOrientations:%lu",(unsigned long)[self.visibleViewController supportedInterfaceOrientations]);
    if (![self.visibleViewController isKindOfClass:[UIAlertController class]])
    {
        return [self.visibleViewController supportedInterfaceOrientations];
    }
    else
    {
        return APP_DELEGATE.interfaceOrientationMask;
    }
}

#pragma mark - 状态栏显隐
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.visibleViewController preferredStatusBarStyle];  //默认的值是黑色的
}


#pragma mark - 转场动画
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop)
    {
        self.reverseAnimationController.reverse = YES;
        return self.reverseAnimationController;
    }
    else
    {
        self.forwardsAnimationController.reverse = NO;
        return self.forwardsAnimationController;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    
    // if we have an interaction controller - and it is currently in progress, return it
    return self.reverseInteractionController && self.reverseInteractionController.interation ? self.reverseInteractionController:nil;
}

@end
