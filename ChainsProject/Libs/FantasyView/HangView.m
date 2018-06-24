//
//  HangView.m
//  RotateDemo
//
//  Created by 马腾飞 on 16/7/29.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "HangView.h"

@interface HangView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

@implementation HangView

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageStr
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    
    [self addSubview:self.imageView];
    self.imageStr = imageStr;
    [self startMonitoring];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    
    [self addSubview:self.imageView];
    
    return self;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] init];
        float w = self.frame.size.width;
        float h = self.frame.size.height;
        double imageViewWidth = sqrt(w*w + h*h);
        _imageView.frame = CGRectMake(-(imageViewWidth-w)/2, -(imageViewWidth-h)/2, imageViewWidth, imageViewWidth);
    }
    
    return _imageView;
}

- (CMMotionManager *)motionManager
{
    if (_motionManager == nil)
    {
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    return _motionManager;
}

- (void)setMotionEnabled:(BOOL)motionEnabled
{
    _motionEnabled = motionEnabled;
    if (_motionEnabled) {
        [self startMonitoring];
    } else {
        [self stopMonitoring];
    }
}

- (void)setImageStr:(NSString *)imageStr
{
    _imageStr = imageStr;
    self.imageView.image = [UIImage imageNamed:imageStr];
}

#pragma mark - Core Motion

- (void)startMonitoring
{
    if ([self.motionManager isDeviceMotionAvailable] && ![self.motionManager isDeviceMotionActive])
    {
        self.motionManager.deviceMotionUpdateInterval = 0.01f;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startDeviceMotionUpdatesToQueue:queue
                                                withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                                                    double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        // update UI here
                                                        self.imageView.transform = CGAffineTransformMakeRotation(rotation);
                                                    }];
                                                }];
    } else {
        NSLog(@"There is not available deviceMotion.");
    }
}

- (void)stopMonitoring
{
    [self.motionManager stopDeviceMotionUpdates];
}


@end
