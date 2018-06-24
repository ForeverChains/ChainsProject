//
//  BaseTransitionAnimationController.m
//  Summary
//
//  Created by 马腾飞 on 17/2/23.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "BaseTransitionAnimationController.h"

@implementation BaseTransitionAnimationController

- (id)init
{
    if (self = [super init]) {
        self.duration = 0.5f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    //我们首先需要得到参与切换的两个ViewController的信息，使用context的方法拿到它们的参照；
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    
}
@end
