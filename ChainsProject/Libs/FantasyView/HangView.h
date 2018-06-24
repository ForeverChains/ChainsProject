//
//  HangView.h
//  RotateDemo
//
//  Created by 马腾飞 on 16/7/29.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

//悬垂视图
@interface HangView : UIView

@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, assign, getter = isMotionEnabled) BOOL motionEnabled;

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageStr;

@end
