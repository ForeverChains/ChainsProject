//
//  BaseInteractionController.m
//  Summary
//
//  Created by 马腾飞 on 17/2/22.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "BaseInteractionController.h"

#define ValueOfResponse                  200       //手势响应的最大值

@interface BaseInteractionController()
@property (nonatomic, weak) UIViewController *vc;
//手势方向
@property (nonatomic, assign) InteractiveTransitionGestureDirection direction;
//转场类型
@property (nonatomic, assign) InteractiveTransitionType type;
@end

@implementation BaseInteractionController

+ (instancetype)interactiveTransitionWithTransitionType:(InteractiveTransitionType)type gestureDirection:(InteractiveTransitionGestureDirection)direction viewController:(UIViewController *)viewController
{
    return [[self alloc] initWithTransitionType:type gestureDirection:direction viewController:viewController];
}

- (instancetype)initWithTransitionType:(InteractiveTransitionType)type gestureDirection:(InteractiveTransitionGestureDirection)direction viewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.direction = direction;
        self.type = type;
        self.vc = viewController;
        //添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [viewController.view addGestureRecognizer:pan];
    }
    return self;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    //手势百分比
    CGFloat persent = 0;
    //是否完成转场
    BOOL shouldCompleteTransition;
    //是否横向滑动
    BOOL isHorizontalSwipe;
    
    CGFloat transitionX = [gestureRecognizer translationInView:gestureRecognizer.view].x;
    CGFloat transitionY = [gestureRecognizer translationInView:gestureRecognizer.view].y;
    
    switch (_direction)
    {
        case InteractiveTransitionGestureDirectionLeft:
        {
            //判断方向,防止反向触发
            if (transitionX < 0)
            {
                //限定非触发方向响应值
                if (fabs(transitionY)<40)
                {
                    persent = fabs(transitionX / ValueOfResponse);
                }
            }
            isHorizontalSwipe = YES;
        }
            break;
        case InteractiveTransitionGestureDirectionRight:
        {
            if (transitionX > 0)
            {
                if (fabs(transitionY)<40)
                {
                    persent = fabs(transitionX / ValueOfResponse);
                }
            }
            isHorizontalSwipe = YES;
        }
            break;
        case InteractiveTransitionGestureDirectionUp:
        {
            if (transitionY < 0)
            {
                if (fabs(transitionX)<40)
                {
                    persent = fabs(transitionY / ValueOfResponse);
                }
            }
            isHorizontalSwipe = NO;
        }
            break;
        case InteractiveTransitionGestureDirectionDown:
        {
            if (transitionY > 0)
            {
                if (fabs(transitionX)<40)
                {
                    persent = fabs(transitionY / ValueOfResponse);
                }
            }
            isHorizontalSwipe = NO;
        }
            break;
            
        default:
            break;
    }
    
    persent = fminf(fmaxf(persent, 0.0), 1.0);
    shouldCompleteTransition = (persent > 0.5);
    
    // if an interactive transitions is 100% completed via the user interaction, for some reason
    // the animation completion block is not called, and hence the transition is not completed.
    // This glorious hack makes sure that this doesn't happen.
    // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
    if (persent >= 1.0) persent = 0.99;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            switch (_type) {
                case InteractiveTransitionTypePresent:
                {
                    if (self.presentBlock) {
                        self.presentBlock();
                    }
                }
                    break;
                case InteractiveTransitionTypeDismiss:
                    [self.vc dismissViewControllerAnimated:YES completion:nil];
                    break;
                case InteractiveTransitionTypePush:
                {
                    if (self.pushBlock) {
                        self.pushBlock();
                    }
                }
                    break;
                case InteractiveTransitionTypePop:
                    [self.vc.navigationController popViewControllerAnimated:YES];
                    break;
                case InteractiveTransitionTypeTab:
                {
                    if (isHorizontalSwipe)
                    {
                        CGPoint vel = [gestureRecognizer velocityInView:gestureRecognizer.view];
                        BOOL rightToLeftSwipe = vel.x < 0;
                        
                        if (rightToLeftSwipe)
                        {
                            if (self.vc.tabBarController.selectedIndex < self.vc.tabBarController.viewControllers.count - 1)
                            {
                                self.vc.tabBarController.selectedIndex++;
                            }
                            
                        }
                        else
                        {
                            if (self.vc.tabBarController.selectedIndex > 0)
                            {
                                self.vc.tabBarController.selectedIndex--;
                            }
                        }
                    }
                    else
                    {
                        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                       reason:@"You cannot use a vertical swipe interaction with a tabbar controller - that would be silly!"
                                                     userInfo:nil];
                    }
                }
                    break;
                default:
                    NSLog(@"Something wrong!");
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //手势过程中，通过updateInteractiveTransition设置转场过程进行的百分比
            [self updateInteractiveTransition:persent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.interation)
            {
                //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
                self.interation = NO;
                if (!shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
                {
                    [self cancelInteractiveTransition];
                }
                else
                {
                    [self finishInteractiveTransition];
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
