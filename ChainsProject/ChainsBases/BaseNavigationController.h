//
//  BaseNavigationController.h
//  Coding_iOS
//
//  Created by Ease on 15/2/5.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

//1536x2048    iPad

//@class CEReversibleAnimationController, CEBaseInteractionController;
@class BaseTransitionAnimationController, BaseInteractionController;

@interface BaseNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic, strong) BaseTransitionAnimationController<UIViewControllerAnimatedTransitioning> *forwardsAnimationController;//正方向
@property (nonatomic, strong) BaseTransitionAnimationController<UIViewControllerAnimatedTransitioning> *reverseAnimationController;//反方向
@property (nonatomic, weak) BaseInteractionController *forwardsInteractionController;
@property (nonatomic, strong) BaseInteractionController *reverseInteractionController;

@end
