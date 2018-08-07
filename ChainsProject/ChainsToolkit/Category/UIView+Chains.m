//
//  UIView+Chains.m
//  MyConclusion
//
//  Created by 马腾飞 on 15/8/21.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import "UIView+Chains.h"

@implementation UIView (Chains)

@end

@implementation UIView (Nib)

+ (instancetype)chains_loadFromNib
{
    Class kClass = [self class];
    NSString *nibName = [self description];
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    
    for (id object in objects) {
        if ([object isKindOfClass:kClass]) {
            return object;
        }
    }
    
    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", nibName, NSStringFromClass(kClass)];
    
    return nil;
}

@end

@implementation UIView (CornerRadius)

- (void)chains_cutCornerWithRadius:(float)radius
{
    [self chains_cutCornerWithRadius:radius rectCorner:UIRectCornerAllCorners];
}

/*
 clipsToBounds
 是指视图上的子视图,如果超出父视图的部分就截取掉
 
 masksToBounds
 是指视图的图层上的子图层,如果超出父图层的部分就截取掉
 */

- (void)chains_cutCornerWithRadius:(float)radius rectCorner:(UIRectCorner)corner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius,
                                                                                radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)chains_drawBorderWithColor:(UIColor *)color width:(float)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

+ (void)chains_shadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(float)radius opacity:(float)opacity forViews:(NSArray *)viewArray
{
    [viewArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = color.CGColor;
        view.layer.shadowOffset = offset;
        view.layer.shadowRadius = radius;
        view.layer.shadowOpacity = opacity;
        
        
        //路径阴影
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        
//        float width = view.bounds.size.width;
//        float height = view.bounds.size.height;
//        float x = view.bounds.origin.x;
//        float y = view.bounds.origin.y;
//        float addWH = 3;
//        
//        CGPoint topLeft  =  CGPointMake(x-addWH, y-addWH);
//        CGPoint topMiddle  =  CGPointMake(x+width/2, y-addWH);
//        CGPoint topRight     = CGPointMake(x+width+addWH,y-addWH);
//        
//        CGPoint bottomRight  = CGPointMake(x+width+addWH,y+height+addWH);
//        CGPoint bottomMiddle  =  CGPointMake(x+width/2, y+height+addWH);
//        CGPoint bottomLeft   = CGPointMake(x-addWH,y+height+addWH);
//        
//        [path moveToPoint:topLeft];
//        [path addQuadCurveToPoint:topRight controlPoint:topMiddle];
//        [path addLineToPoint:bottomRight];
//        [path addQuadCurveToPoint:bottomLeft controlPoint:bottomMiddle];
//        [path addLineToPoint:topLeft];
//        
//        view.layer.shadowPath = path.CGPath;
    }];
}

- (void)chains_drawDashlineWithLength:(int)lineLength spacing:(int)lineSpacing color:(UIColor *)lineColor directionH:(BOOL)isHorizonal
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:self.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(self.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

@end


@implementation UIView (ScreenShot)

- (UIImage *)chains_screenshotWithOffsetY:(CGFloat)deltaY
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //  KEY: need to translate the context down to the current visible portion of the tablview
    CGContextTranslateCTM(ctx, 0, deltaY);
    [self.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

- (UIImage *)chains_screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end


@implementation UIView (Animation)

static NSArray *animationTypeArr = nil;
static NSArray *animationSubtypeArr = nil;

- (void)chains_transitionWithType:(AnimationType)type subtype:(AnimationSubtype)subtype duration:(NSTimeInterval)duration
{
    animationTypeArr = @[@"fade",@"push",@"reveal",@"moveIn",@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose",@"curlDown",@"curlUp",@"flipFromLeft",@"flipFromRight"];
    animationSubtypeArr = @[kCATransitionFromRight,kCATransitionFromLeft,kCATransitionFromTop,kCATransitionFromBottom];
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = duration;
    
    //设置运动type
    animation.type = animationTypeArr[type];
    
    if (subtype) animation.subtype = animationSubtypeArr[subtype];
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.layer addAnimation:animation forKey:@"animation"];
    });
    
}

- (void)chains_scaleAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay value:(id)value options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        [self.layer setValue:value forKeyPath:@"transform.scale"];
    } completion:completion];
}

- (void)chains_flashAnimateWithDuration:(NSTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue=[NSNumber numberWithFloat:fromValue];
    
    animation.toValue=[NSNumber numberWithFloat:toValue];
    
    animation.autoreverses=YES;
    
    animation.duration=duration;
    
    animation.repeatCount=FLT_MAX;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.layer addAnimation:animation forKey:nil];
    });
    
}

- (void)chains_rotationAnimateWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue=@(0);
    animation.toValue=@(M_PI*2);
    animation.duration=duration;
    animation.repeatCount=HUGE;//永久重复动画
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.layer addAnimation:animation forKey:@"animation"];
    });
    
}

+ (void)chains_pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed               = 0.0;
    layer.timeOffset          = pausedTime;
}

+ (void)chains_resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime     = [layer timeOffset];
    layer.speed                   = 1.0;
    layer.timeOffset              = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime               = timeSincePause;
}

@end

@implementation UIView (AutoLayout)

- (void)chains_autoLayoutBounds:(CGSize)bounds
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:bounds.width].active = YES;
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:bounds.height].active = YES;
}

- (NSLayoutConstraint *)chains_autoLayoutWidth:(float)width
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:width];
    layout.active = YES;
    return layout;
}

- (NSLayoutConstraint *)chains_autoLayoutHeight:(float)height
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:height];
    layout.active = YES;
    return layout;
}

- (void)chains_autoLayoutCenterHorizontalDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:distance].active = YES;
}

- (void)chains_autoLayoutCenterVerticalDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:distance].active = YES;
}

- (void)chains_autoLayoutBottomToTopDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:-distance].active = YES;
}

- (void)chains_autoLayoutTopToBottomDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:distance].active = YES;
}

- (void)chains_autoLayoutLeadingToTrailingDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:distance].active = YES;
}

- (void)chains_autoLayoutTrailingToLeadingDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:-distance].active = YES;
}

- (void)chains_autoLayoutTopDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:distance].active = YES;
}

- (void)chains_autoLayoutBottomDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:-distance].active = YES;
}

- (void)chains_autoLayoutLeadingDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:distance].active = YES;
}

- (void)chains_autoLayoutTrailingDistance:(float)distance referenceView:(UIView *)referenceView
{
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:referenceView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-distance].active = YES;
}

@end

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect newFrame   = self.frame;
    newFrame.origin.y = bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setRight:(CGFloat)right
{
    CGRect newFrame   = self.frame;
    newFrame.origin.x = right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end


