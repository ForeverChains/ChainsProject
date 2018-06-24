//
//  ExtendView.m
//  RotateDemo
//
//  Created by 马腾飞 on 16/7/29.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "ExtendView.h"

static const CGFloat MotionViewRotationMinimumTreshold = 0.1f;
static const CGFloat MotionGyroUpdateInterval = 1 / 100;
static const CGFloat MotionViewRotationFactor = 4.0f;

@interface ExtendView ()

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat motionRate;
@property (nonatomic, assign) NSInteger minimumXOffset;
@property (nonatomic, assign) NSInteger maximumXOffset;
@property (nonatomic, assign) NSInteger minimumYOffset;
@property (nonatomic, assign) NSInteger maximumYOffset;

@end

@implementation ExtendView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image unidirectionMode:(BOOL)unidirection
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    
    _viewFrame = frame;
    _minimumXOffset = 0;
    _minimumYOffset = 0;
    _unidirectionMode = unidirection;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self startMonitoring];
    self.image = image;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    
    
    
    return self;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewFrame.size.width, _viewFrame.size.height)];
        [_scrollView setUserInteractionEnabled:NO];
        [_scrollView setBounces:NO];
        [_scrollView setContentSize:CGSizeZero];
        [_scrollView setBackgroundColor:[UIColor redColor]];
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewFrame.size.width, _viewFrame.size.height)];
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

#pragma mark - Setters

//三种情况：
//1.image的width > height 单一方向或全方向
//2.image的width = height 全方向延伸
//3.image的width < height 单一方向或全方向
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    float w = _image.size.width;
    float h = _image.size.height;
    float W;
    float H;
    if (w == h)
    {
        H = _viewFrame.size.height * 2;
        W = H;
        
        
        self.scrollView.contentSize = CGSizeMake(W, H);
        self.imageView.frame = CGRectMake(0, 0, W, H);
        self.imageView.image = image;
        _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2);
        
        _motionRate = w / _viewFrame.size.width * MotionViewRotationFactor;
        _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
        _maximumYOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
    }
    else
    {
        if (self.isUnidirectionMode)
        {
            if (w > h)
            {
                H = _viewFrame.size.height;
                W = H * w / h;
                self.imageView.frame = CGRectMake(0, 0, W, H);
                self.imageView.image = image;
                self.scrollView.contentSize = CGSizeMake(W, H);
                _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, 0);
                
                _motionRate = w / _viewFrame.size.width * MotionViewRotationFactor;
                _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
            }
            
            if (w < h)
            {
                W = _viewFrame.size.width;
                H = W * h / w;
                self.imageView.frame = CGRectMake(0, 0, W, H);
                self.imageView.image = image;
                self.scrollView.contentSize = CGSizeMake(W, H);
                _scrollView.contentOffset = CGPointMake(0, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2);
                
                _motionRate = h / _viewFrame.size.height * MotionViewRotationFactor;
                _maximumYOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
            }
        }
        else
        {
            H = _viewFrame.size.height * 2;
            W = H;
            
            
            self.scrollView.contentSize = CGSizeMake(W, H);
            self.imageView.frame = CGRectMake(0, 0, W, H);
            self.imageView.image = image;
            _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2);
            
            _motionRate = w / _viewFrame.size.width * MotionViewRotationFactor;
            _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
            _maximumYOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
        }
    }
    
    
    
//    CGFloat width = _viewFrame.size.height / _image.size.height * _image.size.width;
//    [_imageView setFrame:CGRectMake(0, 0, width, _viewFrame.size.height)];
//    [_imageView setBackgroundColor:[UIColor blackColor]];
//    [_imageView setImage:_image];
//    
//    _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _scrollView.frame.size.height);
//    _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, 0);
//    
//    _motionRate = _image.size.width / _viewFrame.size.width * MotionViewRotationFactor;
//    _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
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

#pragma mark - Core Motion

- (void)startMonitoring
{
    if (![self.motionManager isGyroActive] && [self.motionManager isGyroAvailable])
    {
        self.motionManager.gyroUpdateInterval = MotionGyroUpdateInterval;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startGyroUpdatesToQueue:queue
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        CGFloat rotationRateX = gyroData.rotationRate.x;
                                        CGFloat rotationRateY = gyroData.rotationRate.y;
                                        if (fabs(rotationRateY) >= MotionViewRotationMinimumTreshold)
                                        {
                                            CGFloat offsetX = _scrollView.contentOffset.x - rotationRateY * _motionRate;
                                            if (offsetX > _maximumXOffset)
                                            {
                                                offsetX = _maximumXOffset;
                                            }
                                            else if (offsetX < _minimumXOffset)
                                            {
                                                offsetX = _minimumXOffset;
                                            }
                                            
                                            CGFloat offsetY = _scrollView.contentOffset.y - rotationRateX * _motionRate;
                                            if (offsetY > _maximumYOffset)
                                            {
                                                offsetY = _maximumYOffset;
                                            }
                                            else if (offsetY < _minimumYOffset)
                                            {
                                                offsetY = _minimumYOffset;
                                            }
                                            
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                // update UI here
                                                [UIView animateWithDuration:0.3f
                                                                      delay:0.0f
                                                                    options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                                                                 animations:^{
                                                                     [_scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:NO];
                                                                 }
                                                                 completion:nil];
                                            }];
                                            
                                        }
                                    }];
    } else {
        NSLog(@"There is not available gyro.");
    }
}

- (void)stopMonitoring
{
    [self.motionManager stopGyroUpdates];
}

@end
