//
//  ExtendView.h
//  RotateDemo
//
//  Created by 马腾飞 on 16/7/29.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

//延展视图
@interface ExtendView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter = isUnidirectionMode) BOOL unidirectionMode;//是否只支持单一方向延展。NO:图片宽高比例应为1：1。YES:图片宽高比例任意。
@property (nonatomic, assign, getter = isMotionEnabled) BOOL motionEnabled;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image unidirectionMode:(BOOL)unidirection;

@end
