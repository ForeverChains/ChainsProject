//
//  UIView+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/8/21.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Fade = 0,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
} AnimationType;

typedef enum : NSUInteger {
    TransitionFromRight = 0,
    TransitionFromLeft,
    TransitionFromTop,
    TransitionFromBottom
} AnimationSubtype;

@interface UIView (Chains)

@end

@interface UIView (Nib)

/**
 *  加载Xib文件
 */
+ (instancetype)chains_loadFromNib;

@end

@interface UIView (CornerRadius)

/**
 *  切割圆角
 *
 *  @param radius 圆角半径
 */
- (void)chains_cutCornerWithRadius:(float)radius;
- (void)chains_cutCornerWithRadius:(float)radius rectCorner:(UIRectCorner)corner;

/**
 *  绘制边框
 *
 *  @param color 边框颜色
 *  @param width 边框宽度
 */
- (void)chains_drawBorderWithColor:(UIColor *)color width:(float)width;

/**
 设置阴影

 @param color 阴影颜色
 @param offset 阴影偏移，默认(0, -3)
 @param radius 阴影半径，默认3
 @param opacity 阴影透明度，默认0
 @param viewArray 目标视图
 */
+ (void)chains_shadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(float)radius opacity:(float)opacity forViews:(NSArray *)viewArray;

/**
 通过 CAShapeLayer 方式绘制虚线
 */
- (void)chains_drawDashlineWithLength:(int)lineLength spacing:(int)lineSpacing color:(UIColor *)lineColor directionH:(BOOL)isHorizonal;

@end

@interface UIView (ScreenShot)

/**
 *  Get a screenshot from a view with Y offset
 *
 *  @param deltaY offset Y
 *
 *  @return The screenshot image.
 */
- (UIImage *)chains_screenshotWithOffsetY:(CGFloat)deltaY;

/**
 *  Get a screenshot with all the partern of view.
 *
 *  @return The screenshot image
 */
- (UIImage *)chains_screenshot;

@end

@interface UIView (Animation)

- (void)chains_transitionWithType:(AnimationType)type subtype:(AnimationSubtype)subtype duration:(NSTimeInterval)duration;

/**
 *  缩放动画
 *
 *  @param duration   动画执行时间
 *  @param delay      动画延迟时间
 *  @param value      缩放倍数，例：@(1.2)
 */
- (void)chains_scaleAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay value:(nullable id)value options:(UIViewAnimationOptions)options completion:(void (^ __nullable)(BOOL finished))completion;


/**
 闪烁动画

 @param duration 动画执行一次用时
 */
- (void)chains_flashAnimateWithDuration:(NSTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue;


/**
 旋转动画

 @param duration 动画执行一次用时
 */
- (void)chains_rotationAnimateWithDuration:(NSTimeInterval)duration;

/**
 动画暂停
 
 @param layer 被停止的layer
 */
+ (void)chains_pauseLayer:(CALayer * _Nonnull)layer;


/**
 动画恢复
 
 @param layer 被恢复的layer
 */
+ (void)chains_resumeLayer:(CALayer * _Nonnull)layer;

@end

@interface UIView (AutoLayout)
/*
 注意:
 1.子视图必须先添加到父视图后才能进行布局
 2.视图在设置translatesAutoresizingMaskIntoConstraints为NO之前,frame设置有效;为No之后,启用自动布局,对frame进行的设置或更改均无效
 */


/**
 *  设置size
 *
 *  @param bounds    视图大小
 */
- (void)chains_autoLayoutBounds:(CGSize)bounds;

/**
 设置宽

 @param width 视图宽度
 */
- (NSLayoutConstraint *)chains_autoLayoutWidth:(float)width;

/**
 设置高
 
 @param height 视图高度
 */
- (NSLayoutConstraint *)chains_autoLayoutHeight:(float)height;

/**
 *  设置水平方向距基准视图中心的距离
 *
 *  @param distance      距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutCenterHorizontalDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  设置竖直方向距基准视图中心的距离
 *
 *  @param distance      距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutCenterVerticalDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图底到基准视图顶的距离(从下往上布局)
 *
 *  @param distance      距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutBottomToTopDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图顶到基准视图底的距离(从上往下布局)
 *
 *  @param distance      距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutTopToBottomDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图前边到基准视图后边的距离(从前往后布局)
 *
 *  @param distance      距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutLeadingToTrailingDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图的后边到基准视图的前边的距离(从后往前布局)
 *
 *  @param distance      距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutTrailingToLeadingDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图与基准视图的上边距
 *
 *  @param distance  距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutTopDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图与基准视图的下边距
 *
 *  @param distance  距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutBottomDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图与基准视图的前边距
 *
 *  @param distance  距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutLeadingDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;

/**
 *  待布局视图与基准视图的后边距
 *
 *  @param distance  距离
 *  @param referenceView 基准视图
 */
- (void)chains_autoLayoutTrailingDistance:(float)distance referenceView:(UIView * _Nonnull)referenceView;


@end

@interface UIView (Frame)

/**
 *  1.起始点X值
 */
@property (nonatomic, assign) CGFloat x;

/**
 *  2.起始点Y值
 */
@property (nonatomic, assign) CGFloat y;

/**
 *  3.宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  4.高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  5.中心点X值
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 *  6.中心点Y值
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 *  7.尺寸大小
 */
@property (nonatomic, assign) CGSize size;

/**
 *  8.起始点
 */
@property (nonatomic, assign) CGPoint origin;


/**
 底的y值
 */
@property (nonatomic, assign) CGFloat bottom;


/**
 右边的x值
 */
@property (nonatomic, assign) CGFloat right;

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y

@end
