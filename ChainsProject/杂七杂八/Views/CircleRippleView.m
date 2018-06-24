//
//  CircleRippleView.m
//  JingShanFuse
//
//  Created by 马腾飞 on 17/6/8.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "CircleRippleView.h"

@interface CircleRippleView()
@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;
@end

@implementation CircleRippleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.circleShapeLayer)
    {
        [self setUpLayers];
    }
}

- (void)setUpLayers
{
    CGFloat width = self.bounds.size.width;
    
    self.circleShapeLayer = [CAShapeLayer layer];
    _circleShapeLayer.bounds = CGRectMake(0, 0, width, width);
    _circleShapeLayer.position = CGPointMake(width / 2.0, width / 2.0);
    _circleShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)].CGPath;
    _circleShapeLayer.fillColor = [UIColor greenColor].CGColor;
    _circleShapeLayer.opacity = 0.0;
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.bounds = CGRectMake(0, 0, width, width);
    replicator.position = CGPointMake(width / 2.0, width / 2.0);
    replicator.instanceDelay = 0.5;
    replicator.instanceCount = 10;
    
    [replicator addSublayer:_circleShapeLayer];
    [self.layer addSublayer:replicator];
    
    CALayer *layer=[CALayer layer];
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    layer.bounds=CGRectMake(0, 0, 20, 20);
    layer.position=CGPointMake(self.width/2, self.height/2);
    layer.cornerRadius = 10;
    [self.layer addSublayer:layer];
}

- (void)startAnimation
{
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnim.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 0.4, 0.4, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    CATransform3D t3 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[alphaAnim, scaleAnim];
    groupAnimation.duration = 1.5;
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = HUGE;
    
    [_circleShapeLayer addAnimation:groupAnimation forKey:nil];
}

- (void)stopAnimation
{
    [_circleShapeLayer removeAllAnimations];
}

@end
