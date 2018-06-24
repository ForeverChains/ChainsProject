//
//  BaseTransitionAnimationController.h
//  Summary
//
//  Created by 马腾飞 on 17/2/23.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTransitionAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.YES:退回
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;

@end
