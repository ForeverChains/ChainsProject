//
//  WaveView.m
//  Summary
//
//  Created by 马腾飞 on 17/8/13.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "WaveView.h"

@interface WaveView()
{
    CGFloat _waveA;//水纹振幅
    CGFloat _waveW ;//水纹周期
    CGFloat _offsetX; //位移
    CGFloat _currentK; //当前波浪高度Y
    CGFloat _waveSpeed;//水纹速度
    CGFloat _waveWidth; //水纹宽度
    CGFloat _wave4;//sin(π/2+α) = cosα  正余弦转化
}
@property (nonatomic,strong)CADisplayLink *waveDisplayLink;
@property (nonatomic,strong)CAShapeLayer *waveLayer;
@property (nonatomic,strong)UIColor *waveColor;
@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame waveColor:(UIColor *)color waveSpeed:(float)speed waveA:(float)waveA waveW:(float)waveW wave4:(float)wave4
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.layer.masksToBounds = YES;
    
    //设置波浪的宽度
    _waveWidth = self.frame.size.width;
    
    //第一个波浪颜色
    _waveColor = color;
    
    _wave4 = wave4;
    
    //初始化layer
    if (!_waveLayer)
    {
        //初始化
        self.waveLayer = [CAShapeLayer layer];
        //设置闭环的颜色
        self.waveLayer.fillColor = color.CGColor;
        //设置边缘线的颜色
        //_waveLayer.strokeColor = [UIColor blueColor].CGColor;
        //设置边缘线的宽度
        //self.waveLayer.lineWidth = 1.0;
        //        self.waveLayer.strokeStart = 0.0;
        //        self.waveLayer.strokeEnd = 0.8;
        
        [self.layer addSublayer:self.waveLayer];
    }
    
    
    //设置波浪流动速度
    _waveSpeed = speed;
    //设置振幅
    _waveA = waveA;
    //设置周期
    _waveW = waveW;
    
    //设置波浪纵向位置
    _currentK = self.frame.size.height-waveA*2;//屏幕居中
    
    //启动定时器
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return self;
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    
    //实时的位移
    _offsetX += _waveSpeed;
    
    [self setCurrentFirstWaveLayerPath];
}

/*
 y =Asin（ωx+φ）+C
 A表示振幅，也就是使用这个变量来调整波浪的高度
 ω表示周期，也就是使用这个变量来调整在屏幕内显示的波浪的数量
 φ表示波浪横向的偏移，也就是使用这个变量来调整波浪的流动
 C表示波浪纵向的位置，也就是使用这个变量来调整波浪在屏幕中竖直的位置。
 周期为T=2π/ω
 */
-(void)setCurrentFirstWaveLayerPath{
    
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = _currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (NSInteger i =0.0f; i<_waveWidth; i++) {
        //正弦函数波浪公式
        y = _waveA * sin(_waveW * i+ _offsetX + _wave4)+_currentK;
        
        //将点连成线
        CGPathAddLineToPoint(path, nil, i, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    
    CGPathCloseSubpath(path);
    self.waveLayer.path = path;
    
    //使用layer 而没用CurrentContext
    CGPathRelease(path);
    
}


-(void)dealloc
{
    [self.waveDisplayLink invalidate];
}

@end
