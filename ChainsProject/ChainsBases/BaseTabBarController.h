//
//  BaseTabBarController.h
//  CommonProject
//
//  Created by lianzun on 2017/9/20.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController
@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *normalImageArr;
@property (strong, nonatomic) NSArray *selectedImageArr;
@property (strong, nonatomic) NSArray *vcNameArr;
@property (assign, nonatomic) BOOL needCustomTabBar;//是否需要自定义TabBar
@property (assign, nonatomic) NSInteger specialIndex;//凸出按钮位置
@end
