//
//  BaseInteractionController.h
//  Summary
//
//  Created by 马腾飞 on 17/2/22.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureBlock)();

typedef enum : NSUInteger {
    InteractiveTransitionGestureDirectionLeft = 0,
    InteractiveTransitionGestureDirectionRight,
    InteractiveTransitionGestureDirectionUp,
    InteractiveTransitionGestureDirectionDown
} InteractiveTransitionGestureDirection;//手势方向

typedef enum : NSUInteger {
    InteractiveTransitionTypePresent = 0,
    InteractiveTransitionTypeDismiss,
    InteractiveTransitionTypePush,
    InteractiveTransitionTypePop,
    InteractiveTransitionTypeTab
} InteractiveTransitionType;//转场类型

@interface BaseInteractionController : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**触发手势present的时候的block，block中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureBlock presentBlock;
/**触发手势push的时候的block，block中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureBlock pushBlock;

+ (instancetype)interactiveTransitionWithTransitionType:(InteractiveTransitionType)type gestureDirection:(InteractiveTransitionGestureDirection)direction viewController:(UIViewController *)viewController;

@end
